//
//  LoginViewController.m
//  MyBear
//
//  Created by 紫平方 on 16/11/15.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"Login";
}
- (IBAction)login:(id)sender {
    
    MainViewController *viewController = [[MainViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];

    return;
    
    if ([[_nameTf.text trimLeftAndRightSpace] isEqualToString:@""]) {
        KKShowNoticeMessage(@"Enter UserName");
        return;
    }
    if ([[_pwdTf.text trimLeftAndRightSpace] isEqualToString:@""]) {
        KKShowNoticeMessage(@"Enter PassWord");
        return;
    }
    if ([_nameTf.text isEqualToString:@"123"]&&[_pwdTf.text isEqualToString:@"123"]) {
        KKShowNoticeMessage(@"Success");

    }

}
- (IBAction)regist:(id)sender {
    AddViewController *viewController = [[AddViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];

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
