//
//  UserManager.h
//  StreetDancing
//
//  Created by beartech on 15/4/14.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserManager : NSObject

+ (UserManager *)defaultSender;

- (void)setObject:(id)obj forKey:(id)key;
- (id)objectForKey:(id)key;

- (NSDictionary *)userInfo;

@end
