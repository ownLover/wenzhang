//
//  KKTextView.h
//  Demo
//
//  Created by 刘 波 on 13-9-4.
//  Copyright (c) 2013年 liubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    UILabel *placeHolderLabel;
    NSInteger _maxLength;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property(nonatomic,assign) NSInteger maxLength;

-(void)textChanged:(NSNotification*)notification;

@end

