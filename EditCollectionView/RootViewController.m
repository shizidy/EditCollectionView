//
//  RootViewController.m
//  EditCollectionView
//
//  Created by wdyzmx on 2018/4/20.
//  Copyright © 2018年 wdyzmx. All rights reserved.
//

#import "RootViewController.h"
#import "PopCollectionView.h"
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    PopCollectionView *popView = [[PopCollectionView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight) selectedArray:@[@"关注",@"推荐", @"视频", @"家居", @"汽车", @"军事", @"美食"] unselectedArray:@[@"搞笑", @"热点", @"房产", @"科技", @"健康", @"财经", @"历史", @"小说"]];
    [self.view addSubview:popView];
    // Do any additional setup after loading the view.
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
