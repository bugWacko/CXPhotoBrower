//
//  NetworkImageVC.m
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/16.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import "NetworkImageVC.h"
#import "CXPhotoBrower.h"
#import "CXPhotoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NetworkImageVC ()<CXPhotoBrowerDelegate>

@property (nonatomic, strong) NSMutableArray *itemsArray;

@end

@implementation NetworkImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Network";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.itemsArray = [[NSMutableArray alloc] init];
    
    //为了测试效果，进行缓存清除
    [[SDWebImageManager sharedManager].imageCache clearDisk];
    
    NSArray *urlArr = @[
                        @"http://ww4.sinaimg.cn/thumbnail/7f8c1087gw1e9g06pc68ug20ag05y4qq.gif",
                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"
                        ];
    
    CGFloat viewWidth = self.view.frame.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, viewWidth - 20, viewWidth - 20)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    for (NSInteger i = 0 ;i < urlArr.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        imageView.tag = i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlArr[i]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
        imageView.backgroundColor = [UIColor grayColor];
        CGFloat width = (view.frame.size.width - 40) / 3;
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        CGFloat x = 10 + col * (10 + width);
        CGFloat y = 10 + row * (10 + width);
        imageView.frame = CGRectMake(x, y, width, width);
        
        CXPhotoModel *items = [[CXPhotoModel alloc] init];
        items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        items.sourceView = imageView;
        [self.itemsArray addObject:items];
        
        [view addSubview:imageView];
    }
}

- (void)click:(UITapGestureRecognizer *)tap{
    CXPhotoBrower *photoBrower = [[CXPhotoBrower alloc] init];
    photoBrower.itemsArr = [_itemsArray copy];
    photoBrower.currentIndex = tap.view.tag;
    [photoBrower setDelegate:self];
    [photoBrower show];
}

#pragma mark - CXPhotoBrower Delegate
-(void)CXPhotoBrowerDelegateWillDismiss:(CXPhotoBrower *)photoBrower {

    NSLog(@"CXPhotoBrowerDelegateWillDismiss");
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
