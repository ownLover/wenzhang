//
//  AddViewController.h
//  MyBear
//
//  Created by 紫平方 on 16/11/15.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "BaseViewController.h"

@interface AddViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)NSMutableArray *dataSource;
@property(nonatomic,retain)NSMutableArray *dataSource1;
@property(nonatomic,retain)NSMutableArray *information;

@end
