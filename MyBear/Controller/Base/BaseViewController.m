//
//  BaseViewController.m
//  MyBaseProject
//
//  Created by Bear on 16/1/6.
//  Copyright (c) 2016年 Bear. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property(nonatomic,strong)UIButton *centerBtn;

@end

@implementation BaseViewController
@synthesize centerBtn;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    self.view.backgroundColor=[UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg%ld.png",(long)arc4random()%5]]];
    
}

- (void)center{
    centerBtn=(UIButton *)[Window0 viewWithTag:999999999];
    if (!centerBtn) {
        centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        centerBtn.frame=CGRectMake((ApplicationWidth-60)/2, Screen_Height-60, 60, 60);
        [centerBtn setCornerRadius:30];
        [centerBtn setBackgroundColor:[UIColor colorWithRed:0.21 green:0.36 blue:0.49 alpha:1] forState:UIControlStateNormal];
        [centerBtn addTarget:self action:@selector(centerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [centerBtn setBorderColor:[UIColor colorWithRed:0.89 green:0.73 blue:0.46 alpha:1] width:3];
        [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        centerBtn.hidden=YES;
        centerBtn.tag=999999999;
        [Window0 addSubview:centerBtn];
        
    }

}

- (void)centerBtnClick{
    UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    tab.selectedIndex=2;
    
}


- (void)isShowCenterBtn:(BOOL)isShow{
    
    centerBtn.hidden=!isShow;
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
