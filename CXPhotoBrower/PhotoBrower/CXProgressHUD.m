//
//  CXProgressHUD.m
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/15.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import "CXProgressHUD.h"

#define VIEW_WIDTH 22 //加载区域宽度
#define VIEW_HEIGHT 22 //加载区域高度
#define BORDLINEWIDTH 1.5 //边框宽度

@interface CXProgressHUD (){
    CAShapeLayer *_sectorLayer;
    CAShapeLayer *_borderLayer;
    UIBezierPath *_sectorBezierPath;
}

@end

static CGSize _superViewSize;
static bool   _animated;

@implementation CXProgressHUD

+ (instancetype)showHUDAddTo:(UIView *)superView animated:(BOOL)animated{
    _animated = animated;
    CXProgressHUD *hud = [[self alloc] initWithSupView:superView];
    
    [superView addSubview:hud];
    
    return hud;
}

- (instancetype)initWithSupView:(UIView *)superView{
    NSAssert(superView, @"superView can not be nil");
    BOOL isOk = [self judgeSuperViewHasFrame:superView];
    NSAssert(isOk, @"superView needs frame");
    _superViewSize = (CGSize){superView.frame.size.width,superView.frame.size.height};
    return [self init];
}

- (instancetype)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initDefaultData];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)initDefaultData{
    _HUDColor = [UIColor whiteColor];
    _sectorBoldColor = _HUDColor;
    _sectorColor = _HUDColor;
    _progress = 0.f;
    
    [self loadSubViews];
}

#pragma mark - 加载所有子图层
- (void)loadSubViews{
    
    [self setFrame:CGRectMake(0, 0, (VIEW_WIDTH + BORDLINEWIDTH * 2 ) * 2,(VIEW_HEIGHT + BORDLINEWIDTH * 2) * 2)];
    [self setCenter:CGPointMake(_superViewSize.width * 0.5, _superViewSize.height * 0.5)];
    
    // 1.扇形
    CAShapeLayer *sectorLayer = [CAShapeLayer layer];
    [sectorLayer setFillColor:nil];
    [sectorLayer setStrokeColor:[_sectorBoldColor CGColor]];
    sectorLayer.lineWidth = VIEW_WIDTH;
    _sectorLayer = sectorLayer;
    [self.layer addSublayer:sectorLayer];
    
    // 2.边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    [borderLayer setFillColor:nil];
    [borderLayer setStrokeColor:[_sectorBoldColor CGColor]];
    [borderLayer setPath:[[UIBezierPath bezierPathWithArcCenter:(CGPoint){VIEW_WIDTH + BORDLINEWIDTH * 2, VIEW_HEIGHT + BORDLINEWIDTH * 2} radius:(VIEW_WIDTH + BORDLINEWIDTH * 2.f) startAngle:0 endAngle:M_PI * 2 clockwise:YES] CGPath]];
    [borderLayer setLineWidth:BORDLINEWIDTH];
    _borderLayer = borderLayer;
    [self.layer addSublayer:borderLayer];
}

#pragma mark - 判断父控件是否为空或不合理
- (BOOL)judgeSuperViewHasFrame:(UIView *)superView{
    if(superView.frame.size.width <= 0 || superView.frame.size.height <= 0){
        return NO;
    }
    return YES;
}

#pragma mark - 设定 进度
- (void)setProgress:(CGFloat)progress{
    if(progress > 1) return;
    _sectorBezierPath = [UIBezierPath bezierPathWithArcCenter:(CGPoint){VIEW_WIDTH + BORDLINEWIDTH * 2, VIEW_HEIGHT + BORDLINEWIDTH * 2} radius:VIEW_WIDTH * 0.5 startAngle:-M_PI_2 endAngle:-M_PI_2 + progress * M_PI * 2 clockwise:YES];
    [_sectorLayer setPath:[_sectorBezierPath CGPath]];
    
    if(progress == 1){
        if(!_animated) {
            [self removeFromSuperview];
            return;
        }
        [UIView animateWithDuration:0.3f animations:^{
            [self setAlpha:0.f];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 设定 颜色
- (void)setHUDColor:(UIColor *)HUDColor {
    [_sectorLayer setStrokeColor:[HUDColor CGColor]];
    [_borderLayer setStrokeColor:[HUDColor CGColor]];
}

- (void)setSectorBoldColor:(UIColor *)sectorBoldColor{
    [_borderLayer setStrokeColor:[sectorBoldColor CGColor]];
}

- (void)setSectorColor:(UIColor *)sectorColor{
    [_sectorLayer setStrokeColor:[sectorColor CGColor]];
}

- (void)dismiss{
    [self removeFromSuperview];
}

-(void)dealloc {
    NSLog(@"dadada");
}

@end
