//
//  TextEditViewController.h
//  EAT
//
//  Created by beartech on 15/5/12.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "KKTextView.h"
#import "KKThemeManager.h"

@protocol TextEditViewControllerDelegate;

typedef NS_ENUM(NSInteger, TextEditType){
    TextEditType_TextFeild=0,//
    TextEditType_TextView=1,//
};

@interface TextEditViewController : BaseViewController{
    Class delegateClass;
    id<TextEditViewControllerDelegate> myDelegate;
}

@property (nonatomic,retain)KKTextView *myTextView;
@property (nonatomic,retain)UITextField *myTextField;
@property (nonatomic,retain)UILabel *maxLenthLabel;
@property (nonatomic,assign)TextEditType type;
@property (nonatomic,assign)id<TextEditViewControllerDelegate> delegate;

/**
 1、aType  编辑框的类型（TextEditType_TextFeild、TextEditType_TextView）
 2、aPlaceHolder 提示文字
 3、aTitle 导航条标题
 4、aInitText 初始化文字（默认填充在编辑框里面的文字）
 5、aKey 标识符（代理返回的时候会返回这个字段，以便代理好做识别处理）
 6、aMaxLenth 最大输入长度限制（>0有效，否则就是不限制输入长度）
 7、engCharacterHalfLenth 计算文字长度的时候英文是否算半个字符
 8、aIsSingleLine 是否允许换行（这个只针对TextEditType_TextView有效，TextEditType_TextFeild本身就不能换行）
 9、aIsNumber 是否只能允许数字整数输入（如果是，则会弹出数字键盘）
 */
- (instancetype)initWithType:(TextEditType)aType
                placeHoleder:(NSString*)aPlaceHolder
                       title:(NSString*)aTitle
                    initText:(NSString*)aInitText
                         key:(NSString*)aKey
                    maxLenth:(NSInteger)aMaxLenth
       engCharacterHalfLenth:(BOOL)engCharacterHalfLenth
                isSingleLine:(BOOL)aIsSingleLine
                    isNumber:(BOOL)aIsNumber;
@end


@protocol TextEditViewControllerDelegate <NSObject>

- (BOOL)TextEditViewController:(TextEditViewController*)viewController
          shouldReturnWithText:(NSString*)text
                           key:(NSString*)aKey
                      initText:(NSString*)aInitText
                      maxLenth:(NSInteger)aMaxLenth
                      isNumber:(BOOL)aIsNumber;

@end
