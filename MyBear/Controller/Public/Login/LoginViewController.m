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

@implementation LoginViewController{
    NSMutableDictionary *amudic;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
    lObserveNet(CMD_RegistGetToken);
    [lSender getToken];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"Login";
    amudic=[[NSMutableDictionary alloc]init];
}
- (IBAction)login:(id)sender {
    
   NSDictionary *dic = [amudic validDictionaryForKey:@"zhanghao"];
    NSString *pwd=[dic objectForKey:_nameTf.text];
    if (pwd&&[pwd isEqualToString:_pwdTf.text]) {
        MainViewController *viewController = [[MainViewController alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];

    }else{
        KKShowNoticeMessage(@"userName or passWord Erro");
    }
    

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

#pragma mark ==================================================
#pragma mark == 【网络】与【数据处理】
#pragma mark ==================================================
- (void)KKRequestRequestFinished:(NSDictionary *)requestResult
                  httpInfomation:(NSDictionary *)httpInfomation
               requestIdentifier:(NSString *)requestIdentifier
{
    [MBProgressHUD hideAllHUDsForView:Window0 animated:YES];
    if ([requestIdentifier isEqualToString: CMD_RegistGetToken]) {
        [self unobserveKKRequestNotificaiton:requestIdentifier];
        if (requestResult && [requestResult isKindOfClass:[NSDictionary class]]) {
            NSString *code = [requestResult stringValueForKey:@"retcode"];
            NSString *data = [requestResult objectForKey:@"data"];
            NSString *msg=[requestResult stringValueForKey:@"msg"];
            if ([NSString isStringNotEmpty:code] && [[code trimLeftAndRightSpace] integerValue]==0) {
                if (data) {
                    
                    
                    [amudic removeAllObjects];
                    
                    [amudic addEntriesFromDictionary:[NSDictionary dictionaryFromJSONString:data]];
                    
                }else{
                    //无数据
                }
            }
            else{
                KKShowNoticeMessage(msg);
            }
        }else{
            
            KKShowNoticeMessage(@"网络错误");
        }
    }
    
    if ([requestIdentifier isEqualToString: CMDsend]) {
        [self unobserveKKRequestNotificaiton:requestIdentifier];
        if (requestResult && [requestResult isKindOfClass:[NSDictionary class]]) {
            NSString *code = [requestResult stringValueForKey:@"retcode"];
            NSDictionary *data = [requestResult objectForKey:@"data"];
            NSString *msg=[requestResult stringValueForKey:@"msg"];
            if ([NSString isStringNotEmpty:code] && [[code trimLeftAndRightSpace] integerValue]==0) {
                KKShowNoticeMessage(@"注册成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                KKShowNoticeMessage(msg);
            }
        }else{
            
            KKShowNoticeMessage(@"网络错误");
        }
    }
    
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
