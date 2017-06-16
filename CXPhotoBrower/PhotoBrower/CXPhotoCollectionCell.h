//
//  CXPhotoCollectionCell.h
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/13.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SingleTap)();
typedef void(^LongPress)();

@interface CXPhotoCollectionCell : UICollectionViewCell

@property (nonatomic, copy) SingleTap singleTap;
@property (nonatomic, copy) LongPress longPress;

- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder;

@end
