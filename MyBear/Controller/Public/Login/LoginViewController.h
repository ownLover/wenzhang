//
//  LoginViewController.h
//  MyBear
//
//  Created by 紫平方 on 16/11/15.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;

@property (weak, nonatomic) IBOutlet UIButton *lgBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@end
