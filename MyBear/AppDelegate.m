//
//  AppDelegate.m
//  MyBear
//
//  Created by 紫平方 on 16/9/30.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    
    UINavigationController *nav=[[UINavigationController alloc]init];
    LoginViewController *viewController = [[LoginViewController alloc]init];
    nav.viewControllers=@[viewController];
    self.window.rootViewController=nav;


    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
            NSString *code = [requestResult stringValueForKey:@"status"];
            NSString *data = [requestResult objectForKey:@"data"];
            
            if ([NSString isStringNotEmpty:code] && [[code trimLeftAndRightSpace] integerValue]==1) {
                if (data) {
                    //                    KKShowNoticeMessage([requestResult stringValueForKey:@"msg"]);
                    [LUserDefault setObject:data forKey:UserKeyToken];
                    
                }else{
                }
            }
            else{
                KKShowNoticeMessage(KILocalization(code));
            }
        }else{
            //            KKShowHTTPRequestMessage(httpInfomation);
            KKShowNoticeMessage(@"网络错误，请检查网络");
        }
    }
    
//    if ([requestIdentifier isEqualToString: cmdLogin]) {
//        [self unobserveKKRequestNotificaiton:requestIdentifier];
//        if (requestResult && [requestResult isKindOfClass:[NSDictionary class]]) {
//            NSString *code = [requestResult stringValueForKey:@"status"];
//            NSString *data = [requestResult objectForKey:@"data"];
//            
//            if ([NSString isStringNotEmpty:code] && [[code trimLeftAndRightSpace] integerValue]==1) {
//                if (data) {
//                    [LUserDefault setObject:data forKey:UserKeyUserId];
//                    
//                }
//            }
//            KKShowNoticeMessage([requestResult stringValueForKey:@"msg"]);
//            
//        }else{
//            //            KKShowHTTPRequestMessage(httpInfomation);
//            KKShowNoticeMessage(@"网络错误，请检查网络");
//        }
//    }
    
}


@end
