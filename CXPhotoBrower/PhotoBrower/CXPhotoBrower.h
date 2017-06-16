//
//  CXPhotoBrower.h
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/13.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXPhotoBrowerDelegate;
@interface CXPhotoBrower : UIView

/**
 * 当前图片索引
 */
@property (assign, nonatomic) NSInteger currentIndex;

/**
 * 存放图片数据数组 （url && data）
 */
@property (strong, nonatomic) NSArray * itemsArr;

/**
 *  是否需要 底部 UIPageControl, Default is NO
 */
@property (assign, nonatomic) BOOL isNeedPageControl;

/**
 * delegate
 */
@property (weak, nonatomic) id<CXPhotoBrowerDelegate>delegate;

/**
 * 图片大图展示方法
 */
-(void)show;

/**
 * 大图展示消失方法
 */
-(void)dismiss;

@end

@protocol CXPhotoBrowerDelegate <NSObject>

/**
 * 即将消失代理方法
 */
-(void)CXPhotoBrowerDelegateWillDismiss:(CXPhotoBrower *)photoBrower;

@end
