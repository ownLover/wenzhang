//
//  BaseRequestParam.m
//  PropertyManage
//
//  Created by 毛梦婕 on 15/8/5.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "BaseRequestParam.h"

@implementation BaseRequestParam

- (void)dealloc{
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addParam:@"token" withValue:[LUserDefault objectForKey:UserKeyToken]];
        [self addParam:@"user_id" withValue:LUserInor(UserKeyUserId)];

          }
    return self;
}

@end
