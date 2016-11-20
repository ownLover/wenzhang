//
//  AddViewController.m
//  MyBear
//
//  Created by 紫平方 on 16/11/15.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController{
    NSInteger selectIndex;
    NSMutableDictionary *amudic;
}

@synthesize myTableView;
@synthesize information;
@synthesize dataSource;
@synthesize dataSource1;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];

    amudic=[[NSMutableDictionary alloc]init];
    [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
    lObserveNet(CMD_RegistGetToken);
    [lSender getToken];

    
}

- (void)NavRightButtonClick{
    
   NSDictionary *dic = [amudic validDictionaryForKey:@"zhanghao"];
    
    NSMutableDictionary *adic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    [adic setObject:information[1] forKey:information[0]];

    [amudic setObject:adic forKey:@"zhanghao"];
    
    
    [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
    
    
    lObserveNet(CMDsend);
    
    [lSender post:[BaseViewController convertToJSONData:amudic]];

    
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI{
    self.title=@"Regist";
    [self setNavRightButtonTitle:@"Regist" selector:@selector(NavRightButtonClick)];
    
    dataSource1=[[NSMutableArray alloc]init];
    dataSource=[[NSMutableArray alloc]init];
    information=[[NSMutableArray alloc]init];
    [dataSource addObjectsFromArray:@[@"UserName",@"PassWord"]];
    for (int i=0; i<dataSource.count; i++) {
        [information addObject:@""];
    }
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ApplicationWidth, ApplicationHeight)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    //myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [myTableView setTableFooterView:[[UIView alloc]init]];
    
    [self.view addSubview:myTableView];

}


#pragma mark ========================================
#pragma mark ==UITableView
#pragma mark ========================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier01=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier01];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier01];
    }
    cell.textLabel.text=[dataSource objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[information objectAtIndex:indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = myBackgroundColor;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectIndex=indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Enter Data" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add",nil];
    [myAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[myAlert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [myAlert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [information replaceObjectAtIndex:selectIndex withObject:[alertView textFieldAtIndex:0].text];
    }
    
    [myTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
    
    if ([requestIdentifier isEqualToString: CMDsend]) {
        [self unobserveKKRequestNotificaiton:requestIdentifier];
        if (requestResult && [requestResult isKindOfClass:[NSDictionary class]]) {
            NSString *code = [requestResult stringValueForKey:@"retcode"];
            NSDictionary *data = [requestResult objectForKey:@"data"];
            NSString *msg=[requestResult stringValueForKey:@"msg"];
            if ([NSString isStringNotEmpty:code] && [[code trimLeftAndRightSpace] integerValue]==0) {
                KKShowNoticeMessage(@"success");
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
