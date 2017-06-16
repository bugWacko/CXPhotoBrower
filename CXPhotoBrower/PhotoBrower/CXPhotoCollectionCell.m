//
//  CXPhotoCollectionCell.m
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/13.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import "CXPhotoCollectionCell.h"
#import "CXPhotoImageView.h"

@interface CXPhotoCollectionCell ()

@property (weak, nonatomic) CXPhotoImageView * photoImageView;

@end

@implementation CXPhotoCollectionCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setPhotoImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPhotoImageView];
    }
    return self;
}

-(void)setPhotoImageView {

    __weak typeof(self) weakSelf = self;
    CXPhotoImageView *photoImageView = [[CXPhotoImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoImageView.singleTapBlock = ^(){
        if(weakSelf.singleTap){
            weakSelf.singleTap();
        }
    };
    
    photoImageView.longPressBlock = ^(){
        if(weakSelf.longPress){
            weakSelf.longPress();
        }
    };
    
    _photoImageView = photoImageView;
    [self.contentView addSubview:photoImageView];
}

- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder {

    [_photoImageView sd_ImageWithUrl:[NSURL URLWithString:url] placeHolder:placeHolder];
}

@end
