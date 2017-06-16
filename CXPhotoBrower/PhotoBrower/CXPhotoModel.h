//
//  CXPhotoModel.h
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/13.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXPhotoModel : NSObject

/**
 *  如果是网络图片,则设置url.不设置 sourceImage
 */
@property (nonatomic, copy  ) NSString *url;

/**
 *  如果加载 本地图片, url 则不可以赋值,
 */
@property (nonatomic, strong) UIImage *sourceImage;

@property (nonatomic, strong) UIView *sourceView;

@end
