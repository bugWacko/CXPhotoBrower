//
//  CXPhotoImageView.m
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/13.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import "CXPhotoImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CXProgressHUD.h"

#import "CXPhotoPch.h"

@interface CXPhotoImageView()<UIScrollViewDelegate>

@property (weak, nonatomic) NSURL * url;
@property (weak, nonatomic) UIImage * placeHolder;
@property (weak, nonatomic) CXProgressHUD * progressHUD;

@end

@implementation CXPhotoImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollView];
        [self initializeDefault];
    }
    return self;
}

/**
 * scrollView & imageView initialize
 */
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [_scrollView addSubview:self.imageView];
        [_scrollView setDelegate:self];
        [_scrollView setClipsToBounds:YES];
    }
    return _scrollView;
}

-(UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return _imageView;
}

/**
 * 初始化设置
 */
-(void)initializeDefault {

    //生产 两种 手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidTap)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidDoubleTap:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDidPress:)];
    
    //设置 手势的要求
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setNumberOfTouchesRequired:1];
    
    //避免两种手势冲突
    [tap requireGestureRecognizerToFail:doubleTap];
    
    //添加 手势
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:longPress];
}

#pragma mark - 手势事件 
//单机事件
- (void)scrollViewDidTap {

    if(_singleTapBlock){
        _singleTapBlock();
    }
}

//长按事件
- (void)longPressDidPress:(UILongPressGestureRecognizer *)longPress {

    if(longPress.state == UIGestureRecognizerStateBegan){
        if(_longPressBlock){
            _longPressBlock();
        }
    }
}

//双击事件
- (void)scrollViewDidDoubleTap:(UITapGestureRecognizer *)doubleTap {

    // 这里先判断图片是否下载好, 如果没下载好, 直接return
    if(!_imageView.image) return;
    
    if(_scrollView.zoomScale <= 1){
        // 获取到 手势 在 自身上的 位置
        // scrollView的偏移量 x(为负) + 手势的 x 需要放大的图片的X点
        CGFloat x = [doubleTap locationInView:self].x + _scrollView.contentOffset.x;
        
        // scrollView的偏移量 y(为负) + 手势的 y 需要放大的图片的Y点
        CGFloat y = [doubleTap locationInView:self].y + _scrollView.contentOffset.y;
        [_scrollView zoomToRect:(CGRect){{x,y},CGSizeZero} animated:YES];
    }else{
        // 设置 缩放的大小  还原
        [_scrollView setZoomScale:1.f animated:YES];
    }
}

#pragma mark - public method
- (void)sd_ImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder {

    _url = url;
    _placeHolder = placeHolder;
    
    if (!url) {
        //如果不存在图片url,展示本地数据图片
        [_imageView setImage:placeHolder];
        
        //刷新布局
        [self layoutSubviews];
        
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    SDWebImageManager * manage = [SDWebImageManager sharedManager];
    //从缓存中读取数据
    [[manage imageCache] queryDiskCacheForKey:[url absoluteString] done:^(UIImage *image, SDImageCacheType cacheType) {
        
        if (_progressHUD) {//如果加载圈存在，则去除加载圈
            [_progressHUD dismiss];
        }
        
        if (image) { //如果图片存在缓存，则获取缓存并赋值
            _imageView.image = image;
            [weakSelf layoutSubviews];
            
        } else {//不存在缓存，重新下载
            //添加加载视图
            CXProgressHUD * progressHUD = [CXProgressHUD showHUDAddTo:self animated:YES];
            _progressHUD = progressHUD;
            
            [_imageView sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:placeHolder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                //加载进度赋值
                CGFloat progress = (CGFloat)receivedSize / expectedSize;
                _progressHUD.progress = progress;
                
                //判断是否加载进度已满，如果满了则去除加载进度
                if(progress == 1) {
                    if (_progressHUD) {
                        [_progressHUD dismiss];
                    }
                }
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                //设置缩放比为正常大小
                [_scrollView setZoomScale:1.f animated:YES];
                
                if (error) {
                    if (_progressHUD) {
                        [_progressHUD dismiss];
                    }
                } else {
                    [weakSelf layoutSubviews];
                }
            }];
        }
    }];
}

- (void)reloadFrames {

    CGRect frame = self.frame;
    if (_imageView.image) {
        
        CGSize imageSize = _imageView.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        
        if (frame.size.width <= frame.size.height) {
            //将图片的宽设置成 scrollView 的宽，高度等比缩放
            CGFloat ratio = frame.size.width / imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height * ratio;
            imageFrame.size.width = frame.size.width;
            
        } else {
        
            //将图片的高设置成 scrollView 的高，宽度等比缩放
            CGFloat ratio = frame.size.height / imageFrame.size.height;
            imageFrame.size.width = imageFrame.size.width * ratio;
            imageFrame.size.height = frame.size.height;
        }
        
        //设置 imageView 的 frame
        [_imageView setFrame:(CGRect){CGPointZero,imageFrame.size}];
        
        //设置 scrollView 的滚动区域
        _scrollView.contentSize = _imageView.frame.size;
        
        //获取 图片的中心点
        _imageView.center = [self centerOfScrollViewContent:_scrollView];
        
        //获取 ScrollView 高 和 图片 高 的 比率
        CGFloat maxScale = frame.size.height / imageFrame.size.height;
        //获取 宽度的比率
        CGFloat widthRadit = frame.size.width / imageFrame.size.width;
        
        //取出 最大的 比率
        maxScale = widthRadit > maxScale?widthRadit:maxScale;
        //如果 最大比率 >= PhotoBrowerImageMaxScale 倍 , 则取 最大比率 ,否则去 PhotoBrowerImageMaxScale 倍
        maxScale = maxScale > PhotoBrowerImageMaxScale?maxScale:PhotoBrowerImageMaxScale;
        
        //设置 scrollView的 最大 和 最小 缩放比率
        _scrollView.minimumZoomScale = PhotoBrowerImageMinScale;
        _scrollView.maximumZoomScale = maxScale;
        
        //设置 scrollView的 原始缩放大小
        _scrollView.zoomScale = 1.0f;
        
    } else {
        frame.origin = CGPointZero;
        _imageView.frame = frame;
        _scrollView.contentSize = _imageView.frame.size;
    }
    
    _scrollView.contentOffset = CGPointZero;
}

#pragma mark - private method
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    
    [self reloadFrames];
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    // scrollView.bounds.size.width > scrollView.contentSize.width : 说明:scrollView 大小 > 图片 大小
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // 在ScrollView上  所需要缩放的 对象
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 每次 完成 拖动时 都 重置 图片的中心点
    _imageView.center = [self centerOfScrollViewContent:scrollView];
}


@end
