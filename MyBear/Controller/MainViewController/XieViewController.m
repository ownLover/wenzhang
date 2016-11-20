//
//  XieViewController.m
//  MyBear
//
//  Created by 紫平方 on 16/11/15.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "XieViewController.h"

@interface XieViewController ()

@end

@implementation XieViewController{
    NSMutableArray *dataSource;
    NSArray *tempArr;
    NSString *tempImgPath;
    
    NSMutableDictionary *tempDic;
    
    
    NSString *upPath;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
    lObserveNet(CMD_RegistGetToken);
    [lSender getToken];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource=[[NSMutableArray alloc]init];
    
    tempDic=[[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view from its nib.
    [self setNavRightButtonTitle:@"post" selector:@selector(RightButtonClick)];
    [_tf setBorderColor:[UIColor lightGrayColor] width:1];
    [_choseBtn setBorderColor:[UIColor lightGrayColor] width:1];
    [_choseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (IBAction)btn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"cancel"
                                  destructiveButtonTitle:@"photo"
                                  otherButtonTitles:@"album",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag=3000;
    [actionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
        if (buttonIndex == 0) {
            UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = NO;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else if (buttonIndex == 1) {
            NSLog(@"1");
            KKAlbumPickerController * viewController = [[KKAlbumPickerController alloc]
                                                        initWithDelegate:self
                                                        numberNeedSelected:1
                                                        editEnable:NO
                                                        cropSize:CGSizeMake(200, 200)
                                                        pushToDefaultDirectory:YES];
            
            [self presentViewController:viewController animated:YES completion:^{
            }];
        }
}


- (void)RightButtonClick{
    
//    NSArray *arr=[LUserDefault objectForKey:@"value"];
//    if ([arr isNotEmptyArray]) {
//        NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
//        
//      NSData *data=  UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:tempImgPath],    0.8);
    
        
//       //NSData *data =  [NSData dataWithContentsOfFile:tempImgPath];
//        NSString *base64Decoded = [[NSString alloc]
//                                  initWithData:data encoding:NSUTF8StringEncoding];
//        NSString *test=[data description];
//        NSString *  str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; //NSData转NSString

//        [array addObject:@{@"text":_tf.text,@"img":test}];
//        [LUserDefault setObject:array forKey:@"value"];
//    }else{
//        NSData *data =  [NSData dataWithContentsOfFile:tempImgPath];
////        NSString *base64Decoded = [[NSString alloc]
////                                   initWithData:data encoding:NSUTF8StringEncoding];
//
//        NSString *test=[data description];
//        
//      NSString *  str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; //NSData转NSString
//
//        
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        [array addObject:@{@"text":_tf.text,@"img":test}];
//        [LUserDefault setObject:array forKey:@"value"];
//
//    }
//    KKShowNoticeMessage(@"success");
//    _tf.text=@"";
//    [_choseBtn setBackgroundImage:Limage(@"") forState:UIControlStateNormal];
//    
//    NSArray *arr1=[LUserDefault objectForKey:@"value"];
    
    [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
    
//    lObserveNet(CMDsend);
//    
//    NSString *jsonString = [[NSString alloc] initWithData:[self toJSONData:arr1]
//                                                 encoding:NSUTF8StringEncoding];
//
//    
//    [lSender post:jsonString];
    
    

    [MBProgressHUD showHUDAddedTo:Window0 animated:YES];

    
    lObserveNet(CMDsend);
    
    [dataSource addObject:@{@"text":_tf.text,@"img":upPath}];


    [tempDic setObject:dataSource forKey:@"shuoshuo"];
    
   NSString *postString= [BaseViewController convertToJSONData:tempDic];
//    NSString *postString=[tempDic translateToJSONString];
    
    [lSender post:postString];
    


}

- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}


#pragma mark ==================================================
#pragma mark == KKAlbumPickerControllerDelegate【图片】
#pragma mark ==================================================
- (void)KKAlbumPickerController_DidFinishedPickImage:(NSArray*)aImageArray imageInformation:(NSArray*)aImageInformationAray
{
    if ([aImageArray count]>0) {
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
        
        [NSData convertImage:aImageArray toDataSize:200 convertImageOneCompleted:^(NSData *imageData, NSInteger index) {
            
            
            
            NSString *path = [NSString stringWithFormat:@"%@/Documents/PublishFinanceImage_header.jpg", NSHomeDirectory()];
            tempImgPath=path;
            BOOL result = [imageData writeToFile:path atomically:YES];
            if (result) {
                [_choseBtn setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:path] forState:UIControlStateNormal];
                //                [information setObject:path forKey:touxiang];
                //                [myTableView reloadData];
                [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
                
                lObserveNet(cmdpost);
                [lSender postImg:tempImgPath];

                
            }
        } KKImageConvertImageAllCompletedBlock:^{
            [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
        }];
    }
}


#pragma mark ========================================
#pragma mark ==UIImagePickerController
#pragma mark ========================================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSArray *arr=[NSArray arrayWithObjects:image, nil];
    [NSData convertImage:arr toDataSize:200 convertImageOneCompleted:^(NSData *imageData, NSInteger index) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/PublishFinanceImage_header.jpg", NSHomeDirectory()];
        tempImgPath=path;
        
        BOOL result = [imageData writeToFile:path atomically:YES];
        if (result) {
            [_choseBtn setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:path] forState:UIControlStateNormal];

            //            [information setObject:path forKey:touxiang];
            //            [myTableView reloadData];
            [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
            
            lObserveNet(cmdpost);
            [lSender postImg:tempImgPath];
            

        }
        
    } KKImageConvertImageAllCompletedBlock:^{
        [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
    }];
}

#pragma mark ==================================================
#pragma mark == 【网络】与【数据处理】
#pragma mark ==================================================
- (void)KKRequestRequestFinished:(NSDictionary *)requestResult
                  httpInfomation:(NSDictionary *)httpInfomation
               requestIdentifier:(NSString *)requestIdentifier
{
    [MBProgressHUD hideAllHUDsForView:Window0 animated:YES];
    if ([requestIdentifier isEqualToString: CMDsend]) {
        [self unobserveKKRequestNotificaiton:requestIdentifier];
        if (requestResult && [requestResult isKindOfClass:[NSDictionary class]]) {
            NSString *code = [requestResult stringValueForKey:@"retcode"];
            NSDictionary *data = [requestResult objectForKey:@"data"];
            NSString *msg=[requestResult stringValueForKey:@"msg"];
            if ([NSString isStringNotEmpty:code] && [[code trimLeftAndRightSpace] integerValue]==0) {
                KKShowNoticeMessage(@"success");
                _tf.text=@"";
                [_choseBtn setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:@""] forState:UIControlStateNormal];

            }
            else{
                KKShowNoticeMessage(msg);
            }
        }else{
            
            KKShowNoticeMessage(@"网络错误");
        }
    }
    if ([requestIdentifier isEqualToString: cmdpost]) {
        [self unobserveKKRequestNotificaiton:requestIdentifier];
        if (requestResult && [requestResult isKindOfClass:[NSDictionary class]]) {
            NSString *code = [requestResult stringValueForKey:@"retcode"];
            NSString *data = [requestResult objectForKey:@"filename"];
            NSString *msg=[requestResult stringValueForKey:@"msg"];
            if ([NSString isStringNotEmpty:code] && [[code trimLeftAndRightSpace] integerValue]==0) {
                
                
                upPath=data;
                
                

            }
            else{
                KKShowNoticeMessage(msg);
            }
        }else{
            
            KKShowNoticeMessage(@"网络错误");
        }
    }
    
    
    if ([requestIdentifier isEqualToString: CMD_RegistGetToken]) {
        [self unobserveKKRequestNotificaiton:requestIdentifier];
        if (requestResult && [requestResult isKindOfClass:[NSDictionary class]]) {
            NSString *code = [requestResult stringValueForKey:@"retcode"];
            NSString *data = [requestResult objectForKey:@"data"];
            NSString *msg=[requestResult stringValueForKey:@"msg"];
            if ([NSString isStringNotEmpty:code] && [[code trimLeftAndRightSpace] integerValue]==0) {
                if (data) {
                    [dataSource removeAllObjects];
                    tempDic= [[NSMutableDictionary alloc]initWithDictionary:[NSDictionary dictionaryFromJSONString:data]];
                    [dataSource addObjectsFromArray:[tempDic validArrayForKey:@"shuoshuo"]];
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
