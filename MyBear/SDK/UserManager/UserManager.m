//
//  UserManager.m
//  StreetDancing
//
//  Created by beartech on 15/4/14.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "UserManager.h"

@interface UserManager ()


@end

    

@implementation UserManager

+ (UserManager *)defaultSender{
    static UserManager *NetWorkSender_Report_defaultSender = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NetWorkSender_Report_defaultSender = [[self alloc] init];
    });
    return NetWorkSender_Report_defaultSender;
}

- (void)setObject:(id)obj forKey:(id)key{
    NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey];
    if (dic) {
        NSMutableDictionary *muDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
        [muDic setObject:obj forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:muDic forKey:UserInfoKey];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@{key:obj} forKey:UserInfoKey];

    }
}

- (id)objectForKey:(id)key{
    NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey];

    if (dic) {
        return [dic objectForKey:key];
    }else{
        return @"";
    }
    
}

- (NSDictionary *)userInfo{
    return    [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey];

}

@end
