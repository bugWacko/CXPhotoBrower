//
//  CXPhotoBrower.m
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/13.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import "CXPhotoBrower.h"

#import "CXPhotoCollectionCell.h"
#import "CXPhotoModel.h"

#import "CXPhotoPch.h"

static NSString * ReuseIdentifier = @"CXPhotoCollectionCell";

@interface CXPhotoBrower ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView * collectionView;
@property (weak, nonatomic) UIPageControl * pageControl;
@property (weak, nonatomic) CXPhotoCollectionCell * photoCollectionCell;

@property (assign, nonatomic) bool isFirstShow;//是否第一次展示
@property (assign, nonatomic) NSInteger page;//页数

@end

@implementation CXPhotoBrower

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeDefault];
    }
    return self;
}

//添加到父控件上调用该方法
-(void)willMoveToSuperview:(UIView *)newSuperview {

    [self initializeCollectionView];
    [self initializePageControl];
}

#pragma mark - 参数初始化和控件初始化

/**
 * 初始化设置
 */
-(void)initializeDefault {

    self.backgroundColor = [UIColor blackColor];
}

/**
 * UICollectionView initialize
 */
-(void)initializeCollectionView {

    CGRect bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    bounds.size.width += PhotoBrowerMargin;
    
    //create layout
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:bounds.size];
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //create collectionView
    UICollectionView * collectionView  = [[UICollectionView alloc] initWithFrame:bounds collectionViewLayout:layout];
    
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionView setPagingEnabled:YES];
    [collectionView setBounces:YES];
    
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setDecelerationRate:0];
    [collectionView registerClass:[CXPhotoCollectionCell class] forCellWithReuseIdentifier:ReuseIdentifier];
    self.collectionView = collectionView;
    
    [self addSubview:collectionView];
}

/**
 * UIPageControl initialize
 */
-(void)initializePageControl {

    UIPageControl * pageControl = [[UIPageControl alloc] init];
    [pageControl setCurrentPage:_currentIndex];
    [pageControl setNumberOfPages:_itemsArr.count];
    [pageControl setFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 30)];
    [pageControl setHidden:!_isNeedPageControl];
    
    //_isNeedPageControl 设置与否，只要itemArr数量为1，则隐藏
    if (self.itemsArr.count == 1) {
        [pageControl setHidden:YES];
    }
    
    self.pageControl = pageControl;
    [self addSubview:pageControl];
}


#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.itemsArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof (self) weakSelf = self;
    CXPhotoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    CXPhotoModel *items = _itemsArr[indexPath.row];
    NSString *url = items.url;
    
    UIImage *tempImage = [(UIImageView *)items.sourceView image];
    
    [cell sd_ImageWithUrl:url placeHolder:tempImage ? tempImage : nil];
    
    cell.singleTap = ^(){
        [weakSelf dismiss];
    };
    
    cell.longPress = ^(){
        NSLog(@"long press action");
    };
    
    _photoCollectionCell = cell;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / (ScreenWidth + PhotoBrowerMargin);
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = (x + scrollViewW / 2) / scrollViewW;
    
    if(self.page != page){
        self.page = page;
        if(self.page + 1 <= self.itemsArr.count){
            [self.pageControl setCurrentPage:self.page];
        }
    }
}

#pragma mark - privity method

/**
 * 开始动画
 */
- (void)photoBrowerWillShowAnimated {

    //判断用户 点击了的控件是 控制器中的第几个图片. 在这里设置 collectionView的偏移量
    [self.collectionView setContentOffset:(CGPoint){self.currentIndex * (self.frame.size.width + PhotoBrowerMargin),0} animated:NO];
    
    //获取当前点击的view
    CXPhotoModel * itemModel = self.itemsArr[self.currentIndex];
    UIView * sourceView = itemModel.sourceView;
    
    CGRect rect = [sourceView convertRect:[sourceView bounds] toView:self];
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [(UIImageView *)sourceView image];
    
    [tempView setFrame:rect];
    [tempView setContentMode:sourceView.contentMode];
    [self addSubview:tempView];
    
    CGSize tempRectSize;
    
    CGFloat width = tempView.image.size.width;
    CGFloat height = tempView.image.size.height;
    
    tempRectSize = (CGSize){ScreenWidth,(height * ScreenWidth / width) > ScreenHeight ? ScreenHeight:(height * ScreenWidth / width)};
    
    [self.collectionView setHidden:YES];
    
    [UIView animateWithDuration:PhotoBrowerAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [tempView setCenter:[self center]];
        [tempView setBounds:(CGRect){CGPointZero,tempRectSize}];
    } completion:^(BOOL finished) {
        self.isFirstShow = YES;
        
        [UIView animateWithDuration:0.15 animations:^{
            [tempView setAlpha:0.f];
        } completion:^(BOOL finished) {
            [tempView removeFromSuperview];
        }];
        [self.collectionView setHidden:NO];
    }];
}

/**
 * 判断图片数据是否为空
 */
-(bool)imageArrayIsEmpty:(NSArray *)imageArray {

    if (imageArray == nil || [imageArray isKindOfClass:[NSNull class]] || imageArray.count == 0) {
        return YES;
    } else {
        return NO;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if(!self.isFirstShow){
        [self photoBrowerWillShowAnimated];
    }
}

-(void)dealloc {

    NSLog(@"dealloc");
}

#pragma mark - public method

/**
* 图片大图展示方法
*/
-(void)show {

    //判断是否有图片传入，如果没有，进行返回操作
    if ([self imageArrayIsEmpty:self.itemsArr]) {
        return;
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self setFrame:window.bounds];
    [window addSubview:self];
}

/**
 * 大图展示消失方法
 */
-(void)dismiss {

    //视图将要消失，进行代理回调通知
    if (self.delegate && [self.delegate respondsToSelector:@selector(CXPhotoBrowerDelegateWillDismiss:)]) {
        [self.delegate CXPhotoBrowerDelegateWillDismiss:self];
    }
    
    //获取退出时当前展示的图片
    CXPhotoModel *itemModel = self.itemsArr[self.currentIndex];
    
    //隐藏其他子控件
    [self.collectionView setHidden:YES];
    [self.pageControl setHidden:YES];
    
    //删除数组对象
    self.itemsArr = nil;
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = itemModel.sourceView.contentMode;
    [tempView setImage:[(UIImageView *)itemModel.sourceView image]];
    
    UIView *sourceView = itemModel.sourceView;
    CGRect rect = [sourceView convertRect:[sourceView bounds] toView:self];
    
    if(rect.origin.y > ScreenHeight ||
       rect.origin.y <= - rect.size.height ||
       rect.origin.x > ScreenWidth ||
       rect.origin.x <= -rect.size.width
       ){
        [UIView animateWithDuration:PhotoBrowerAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [tempView setAlpha:0.f];
            [self setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            [tempView removeFromSuperview];
            [UIView animateWithDuration:0.15 animations:^{
                [tempView setAlpha:0.f];
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    }else{
        CGFloat width  = tempView.image.size.width;
        CGFloat height = tempView.image.size.height;
        
        CGSize tempRectSize = (CGSize){ScreenWidth,(height * ScreenWidth / width) > ScreenHeight ? ScreenHeight:(height * ScreenWidth / width)};
        
        [tempView setBounds:(CGRect){CGPointZero,{tempRectSize.width,tempRectSize.height}}];
        [tempView setCenter:[self center]];
        [self addSubview:tempView];
        
        [UIView animateWithDuration:PhotoBrowerAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [tempView setFrame:rect];
            [self setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                [tempView setAlpha:0.f];
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    }
}


@end
