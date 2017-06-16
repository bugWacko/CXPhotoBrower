//
//  ViewController.m
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/12.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#import "ViewController.h"
#import "LocationImageVC.h"
#import "NetworkImageVC.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"CXPhotoBrower";
    
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cxphotoBrower";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"网络请求";
    } else {
        cell.textLabel.text = @"本地展示";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        NetworkImageVC * network = [[NetworkImageVC alloc] init];
        [network setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:network animated:YES];
    } else {
        LocationImageVC * location = [[LocationImageVC alloc] init];
        [location setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:location animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
