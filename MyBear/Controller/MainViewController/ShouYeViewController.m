//
//  ShouYeViewController.m
//  MyBear
//
//  Created by 紫平方 on 16/11/15.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "ShouYeViewController.h"
#import "SDImageCache.h"
@interface ShouYeViewController ()

@end

@implementation ShouYeViewController
@synthesize myTableView;
@synthesize information;
@synthesize dataSource;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
    lObserveNet(CMD_RegistGetToken);
    [lSender getToken];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSString -> NSData
    NSData *data = [@"520it.com" dataUsingEncoding:NSUTF8StringEncoding];
    //NSData -> NSString
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    
    // Do any additional setup after loading the view from its nib.
    dataSource=[[NSMutableArray alloc]init];
    NSArray *arr=[LUserDefault objectForKey:@"value"];
    
    if ([arr isNotEmptyArray]) {
        [dataSource addObjectsFromArray:arr];
        [myTableView reloadData];
    }

    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ApplicationWidth, ApplicationHeight)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableView.estimatedRowHeight = 1000;
    myTableView.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
    //myTableView.rowHeight = UITableViewAutomaticDimension;
    
    [myTableView setTableFooterView:[[UIView alloc]init]];
    
    [self.view addSubview:myTableView];

    lObserveNet(CMD_RegistGetToken);

    [[Net defaultSender]getToken];
    
}

#pragma mark ========================================
#pragma mark ==UITableView
#pragma mark ========================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier01=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier01];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier01];
        
        UIImageView *img = [[UIImageView alloc]init];
        img.tag=100;
        [cell.contentView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset=10;
            make.left.offset=10;
            make.right.offset=-10;
            make.height.offset=150;
        }];

        UILabel *lab = [[UILabel alloc]init];
        lab.tag=200;
//        lab.font = <##>;
//        lab.textColor = <##>;
//        lab.text= <##> ;
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(img.mas_bottom).offset=15;
            make.left.offset=10;
            make.right.offset=10;
            make.bottom.offset=10;
        }];

        
    }
    UIImageView *img=LTag(100);
    NSDictionary *adic=dataSource[indexPath.row];

    
    
    [img sd_setImageWithURL:[NSURL URLWithString:[adic objectForKey:@"img"]]];
    
    UILabel *lab=LTag(200);
    lab.text=[adic objectForKey:@"text"];
    
    cell.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = myBackgroundColor;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//    }
//}


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
                    [dataSource removeAllObjects];
                    
                    ;
                    
                    NSDictionary *Dic=  [NSDictionary dictionaryFromJSONString:data];
                    [dataSource addObjectsFromArray:[Dic validArrayForKey:@"shuoshuo"]];
                    [myTableView reloadData];
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
    
    
}

- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
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
