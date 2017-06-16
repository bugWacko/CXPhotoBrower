//
//  CXPhotoImageView.h
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/13.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SingleTapBlock)();
typedef void(^LongPressBlock)();

@interface CXPhotoImageView : UIView

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, copy) SingleTapBlock singleTapBlock;
@property (nonatomic, copy) LongPressBlock longPressBlock;

- (void)sd_ImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder;
- (void)reloadFrames;

@end
