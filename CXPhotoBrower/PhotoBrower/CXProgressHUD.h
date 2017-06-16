//
//  CXProgressHUD.h
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/15.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXProgressHUD : UIView

/**
 *  显示加载圈
 *
 *  @param superView 父控件
 *  @param animated  是否 动画显出入
 *
 *  @return 加载圈本身
 */
+ (instancetype)showHUDAddTo:(UIView *)superView animated:(BOOL)animated;

/**
 *  加载圈的 整体 颜色
 */
@property (nonatomic, strong) UIColor *HUDColor;

/**
 *  扇形颜色 ,默认为 白色
 */
@property (nonatomic, strong) UIColor *sectorColor;

/**
 *  边框颜色 , 默认为 白色
 */
@property (nonatomic, strong) UIColor *sectorBoldColor;

/**
 *  进度 , 范围 :0.f ~ 1.f
 */
@property (nonatomic, assign) CGFloat progress;

/**
 *  消失
 */
- (void)dismiss;

@end
