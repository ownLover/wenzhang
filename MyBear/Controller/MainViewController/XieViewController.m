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
    NSString *tempImgPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    NSArray *arr=[LUserDefault objectForKey:@"value"];
    if ([arr isNotEmptyArray]) {
        NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
        
      NSData *data=  UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:tempImgPath],    0.8);
        
        
       //NSData *data =  [NSData dataWithContentsOfFile:tempImgPath];
        NSString *base64Decoded = [[NSString alloc]
                                  initWithData:data encoding:NSUTF8StringEncoding];
        NSString *test=[data description];
        NSString *  str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; //NSData转NSString

        [array addObject:@{@"text":_tf.text,@"img":test}];
        [LUserDefault setObject:array forKey:@"value"];
    }else{
        NSData *data =  [NSData dataWithContentsOfFile:tempImgPath];
//        NSString *base64Decoded = [[NSString alloc]
//                                   initWithData:data encoding:NSUTF8StringEncoding];

        NSString *test=[data description];
        
      NSString *  str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; //NSData转NSString

        
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [array addObject:@{@"text":_tf.text,@"img":test}];
        [LUserDefault setObject:array forKey:@"value"];

    }
    KKShowNoticeMessage(@"success");
    _tf.text=@"";
    [_choseBtn setBackgroundImage:Limage(@"") forState:UIControlStateNormal];
    
    NSArray *arr1=[LUserDefault objectForKey:@"value"];
    
    [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
    
    lObserveNet(CMDsend);
    
    NSString *jsonString = [[NSString alloc] initWithData:[self toJSONData:arr1]
                                                 encoding:NSUTF8StringEncoding];

    
    [lSender post:jsonString];


    
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
        
        [NSData convertImage:aImageArray toDataSize:50 convertImageOneCompleted:^(NSData *imageData, NSInteger index) {
            
            
            
            NSString *path = [NSString stringWithFormat:@"%@/Documents/PublishFinanceImage_header.jpg", NSHomeDirectory()];
            tempImgPath=path;
            BOOL result = [imageData writeToFile:path atomically:YES];
            if (result) {
                [_choseBtn setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:path] forState:UIControlStateNormal];
                //                [information setObject:path forKey:touxiang];
                //                [myTableView reloadData];
                
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
    [NSData convertImage:arr toDataSize:50 convertImageOneCompleted:^(NSData *imageData, NSInteger index) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/PublishFinanceImage_header.jpg", NSHomeDirectory()];
        tempImgPath=path;
        
        BOOL result = [imageData writeToFile:path atomically:YES];
        if (result) {
            [_choseBtn setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:path] forState:UIControlStateNormal];

            //            [information setObject:path forKey:touxiang];
            //            [myTableView reloadData];
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
            NSString *code = [requestResult stringValueForKey:@"status"];
            NSDictionary *data = [requestResult objectForKey:@"data"];
            NSString *msg=[requestResult stringValueForKey:@"msg"];
            if ([NSString isStringNotEmpty:code] && [[code trimLeftAndRightSpace] integerValue]==1) {
                if (data && [data isNotEmptyDictionary]) {
                    
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
