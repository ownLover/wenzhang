//
//  XieViewController.h
//  MyBear
//
//  Created by 紫平方 on 16/11/15.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "BaseViewController.h"

@interface XieViewController : BaseViewController<UIActionSheetDelegate,KKAlbumPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tf;

@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@end
