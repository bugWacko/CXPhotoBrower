//
//  LocationImageVC.m
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/16.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import "LocationImageVC.h"
#import "CXPhotoBrower.h"
#import "CXPhotoModel.h"

@interface LocationImageVC ()
@property (nonatomic, strong) NSMutableArray *itemsArray;

@end

@implementation LocationImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Location";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.itemsArray = [[NSMutableArray alloc] init];
    
    CGFloat viewWidth = self.view.frame.size.width;
    // 背景View =======================
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, viewWidth - 20, viewWidth - 20)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    
    NSMutableArray *imageArr = [NSMutableArray array];
    [imageArr addObject:[UIImage imageNamed:@"1.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"2.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"3.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"4.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"5.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"6.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"7.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"8.jpg"]];
    [imageArr addObject:[UIImage imageNamed:@"9.jpg"]];
    
    for (NSInteger i = 0 ;i < imageArr.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        imageView.tag = i;
        imageView.image = imageArr[i];
        
        imageView.backgroundColor = [UIColor grayColor];
        
        CGFloat width = (view.frame.size.width - 40) / 3;
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        imageView.frame = CGRectMake(x, y, width, width);
        
        CXPhotoModel *items = [[CXPhotoModel alloc] init];
        items.sourceView = imageView;
        [self.itemsArray addObject:items];
        
        [view addSubview:imageView];
    }
}

- (void)click:(UITapGestureRecognizer *)tap{
    CXPhotoBrower *photoBrower = [[CXPhotoBrower alloc] init];
    photoBrower.itemsArr = [_itemsArray copy];
    photoBrower.currentIndex = tap.view.tag;
    
    [photoBrower show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
