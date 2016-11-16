//
//  ViewController.m
//  MyBear
//
//  Created by 紫平方 on 16/9/30.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [LUITabBarController LUITabBarController:@[[MainViewController new],[MessageViewController new],[VideoViewController new],[DiscoverViewController new],[MineViewController new]] titleArr:@[@"首页",@"消息",@"直播",@"发现",@"我的"] imageArr:@[@"wo",@"wo",@"wo",@"wo",@"wo"]];
    
//    UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//
//    
//    UIButton *centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    centerBtn.frame=CGRectMake((ApplicationWidth-60)/2, Screen_Height-60, 60, 60);
//    [centerBtn setCornerRadius:30];
//    [centerBtn setBackgroundColor:[UIColor colorWithRed:0.21 green:0.36 blue:0.49 alpha:1] forState:UIControlStateNormal];
//    [centerBtn addTarget:self action:@selector(centerBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [centerBtn setBorderColor:[UIColor colorWithRed:0.89 green:0.73 blue:0.46 alpha:1] width:3];
//    [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [tab.view addSubview:centerBtn];
    
    
}

- (void)centerBtnClick{
    UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    tab.selectedIndex=3;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
