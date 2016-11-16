//
//  TextEditViewController.m
//  EAT
//
//  Created by beartech on 15/5/12.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "TextEditViewController.h"

@interface TextEditViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,copy)NSString *placeHoleder;
@property (nonatomic,copy)NSString *titleString;
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)NSString *initText;
@property (nonatomic,assign)NSInteger maxLenth;
@property (nonatomic,assign)BOOL isNumber;
@property (nonatomic,assign)BOOL englishCharacterHalfLenth;
@property (nonatomic,assign)BOOL isSingleLine;

@property (nonatomic,retain)UIView *backView;


@end

@implementation TextEditViewController@synthesize myTextField,myTextView,type;
@synthesize placeHoleder,titleString,key,initText;
@synthesize delegate = myDelegate;
@synthesize maxLenth,isNumber;
@synthesize maxLenthLabel;
@synthesize englishCharacterHalfLenth;
@synthesize isSingleLine;
@synthesize backView;

- (void)dealloc{
    [myTextField release];
    [myTextView release];
    [backView release];
    [maxLenthLabel release];
    
    [placeHoleder release];
    [titleString release];
    [key release];
    [initText release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
static float needAdd=64;

- (instancetype)initWithType:(TextEditType)aType
                placeHoleder:(NSString*)aPlaceHolder
                       title:(NSString*)aTitle
                    initText:(NSString*)aInitText
                         key:(NSString*)aKey
                    maxLenth:(NSInteger)aMaxLenth
engCharacterHalfLenth:(BOOL)engCharacterHalfLenth
                isSingleLine:(BOOL)aIsSingleLine
                    isNumber:(BOOL)aIsNumber{
    self = [super init];
    if (self) {
        type = aType;
        placeHoleder = [aPlaceHolder copy];
        titleString = [aTitle copy];
        key = [aKey copy];
        initText = [aInitText copy];
        maxLenth = aMaxLenth;
        isNumber = aIsNumber;
        englishCharacterHalfLenth = engCharacterHalfLenth;
        isSingleLine = aIsSingleLine;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = titleString;
    [self showNavigationDefaultBackButton_ForNavPopBack];
    [self setNavRightButtonTitle:@"确定" selector:@selector(finishedEdit)];
    
    if (type==TextEditType_TextFeild) {
        backView = [[UIView alloc] initWithFrame:CGRectMake(-10, 0+needAdd, ApplicationWidth+20, 42)];
        backView.backgroundColor = [UIColor redColor];
        [backView setBorderColor:RGB_Color(216, 216, 216) width:0.5];
        [self.view addSubview:backView];
        
        [self observeNotificaiton:UITextFieldTextDidChangeNotification selector:@selector(UITextFieldTextDidChangeNotification:)];

        myTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0+needAdd, ApplicationWidth-30, 40)];
        myTextField.backgroundColor = [UIColor yellowColor];
        myTextField.font = [UIFont systemFontOfSize:16];
        myTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        myTextField.placeholder = placeHoleder;
        myTextField.returnKeyType = UIReturnKeyDone;
        myTextField.enabled = YES;
        myTextField.delegate = self;
        [self.view addSubview:myTextField];
        myTextField.text = initText;

        if (isNumber) {
            if ([initText floatValue]==0) {
                myTextField.text = @"";
            }
            myTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        if (maxLenth>0) {
            //限制字数
            maxLenthLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame), ApplicationWidth-30, 20)];
            [maxLenthLabel clearBackgroundColor];
            maxLenthLabel.textColor = [UIColor blackColor];
            maxLenthLabel.textAlignment = NSTextAlignmentRight;
            maxLenthLabel.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:maxLenthLabel];
        }
        [self checkMaxLenth];
    }
    else{
        backView = [[UIView alloc] initWithFrame:CGRectMake(-10, 0+needAdd, ApplicationWidth+20, 122)];
        backView.backgroundColor = [UIColor whiteColor];
        [backView setBorderColor:RGB_Color(216, 216, 216) width:0.5];
        [self.view addSubview:backView];

        [self observeNotificaiton:UITextViewTextDidChangeNotification selector:@selector(UITextViewTextDidChangeNotification:)];

        myTextView = [[KKTextView alloc]initWithFrame:CGRectMake(10, 10+needAdd, ApplicationWidth-20, 110)];
        myTextView.delegate = self;
        [myTextView clearBackgroundColor];
        myTextView.placeholder = placeHoleder;
        myTextView.editable = YES;
        myTextView.selectable = YES;
        myTextView.font = [UIFont systemFontOfSize:16];
        [myTextView setContentInset:UIEdgeInsetsMake(-3, 5, -3, -10)];//设置UITextView的内边距
        [self.view addSubview:myTextView];
        myTextView.text = initText;
        
        if (isSingleLine) {
            myTextView.returnKeyType = UIReturnKeyDone;
        }
        else{
            myTextView.returnKeyType = UIReturnKeyDefault;
        }
        
        if (maxLenth>0) {
            //限制字数
            maxLenthLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame), ApplicationWidth-30, 20)];
            [maxLenthLabel clearBackgroundColor];
            maxLenthLabel.textColor = [UIColor blackColor];
            maxLenthLabel.textAlignment = NSTextAlignmentRight;
            maxLenthLabel.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:maxLenthLabel];
        }
        
        [self checkMaxLenth];
    }
    
}

- (void)navigationControllerPopBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setDelegate:(id<TextEditViewControllerDelegate>)delegate{
    myDelegate = delegate;
    delegateClass = object_getClass(myDelegate);
}

- (void)finishedEdit{
    
    Class currentClass = object_getClass(myDelegate);
    if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(TextEditViewController:shouldReturnWithText:key:initText:maxLenth:isNumber:)]) {
        BOOL shouldReturn = NO;
        if (type==TextEditType_TextFeild) {
            shouldReturn = [myDelegate TextEditViewController:self shouldReturnWithText:myTextField.text key:key initText:initText maxLenth:maxLenth isNumber:isNumber];
        }
        else{
            shouldReturn =  [myDelegate TextEditViewController:self shouldReturnWithText:myTextView.text key:key initText:initText maxLenth:maxLenth isNumber:isNumber];
        }
        
        if (shouldReturn) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)checkMaxLenth{
    if (englishCharacterHalfLenth) {
        [self checkMaxLenthForEnglishHalf];
    }
    else{
        [self checkMaxLenthForDefault];
    }
}

- (void)checkMaxLenthForDefault{
    if (maxLenth>0) {
        
        if (myTextField) {
            
            UITextRange *selectedRange = [myTextField markedTextRange];
            if ( [selectedRange isEmpty] || selectedRange==nil) {
                NSUInteger textLenth = [myTextField.text length];
                
                if ( textLenth > maxLenth ) {
                    myTextField.text = [myTextField.text substringToIndex:maxLenth];
                }
                textLenth = [myTextField.text length];
                NSUInteger shengLenth = (unsigned long)(maxLenth-textLenth);
                maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            }

//            //获取高亮部分
//            UITextPosition *position = [myTextField positionFromPosition:selectedRange.start offset:0];
//            
//            if ( !position ) {
//                NSUInteger textLenth = [myTextField.text length];
//                
//                if ( textLenth > maxLenth ) {
//                    myTextField.text = [myTextField.text substringToIndex:maxLenth];
//                }
//                textLenth = [myTextField.text length];
//                NSUInteger shengLenth = (unsigned long)(maxLenth-textLenth);
//                maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
//            }
        }
        else if (myTextView){
            UITextRange *selectedRange = [myTextView markedTextRange];
            if ([selectedRange isEmpty] || selectedRange==nil) {
                NSUInteger textLenth = [myTextView.text length];
                
                if ( textLenth > maxLenth ) {
                    myTextView.text = [myTextView.text substringToIndex:maxLenth];
                }
                textLenth = [myTextView.text length];
                NSUInteger shengLenth = (unsigned long)(maxLenth-textLenth);
                maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            }
//            //获取高亮部分
//            UITextPosition *position = [myTextView positionFromPosition:selectedRange.start offset:0];
//            
//            if ( !position ) {
//                NSUInteger textLenth = [myTextView.text length];
//                
//                if ( textLenth > maxLenth ) {
//                    myTextView.text = [myTextView.text substringToIndex:maxLenth];
//                }
//                textLenth = [myTextView.text length];
//                NSUInteger shengLenth = (unsigned long)(maxLenth-textLenth);
//                maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
//            }
        }
        else{
            
        }
    }
}

- (void)checkMaxLenthForEnglishHalf{
    if (maxLenth>0) {
        
        if (myTextField) {
            
            UITextRange *selectedRange = [myTextField markedTextRange];
            if ( [selectedRange isEmpty] || selectedRange==nil) {
                NSUInteger textLenth = [myTextField.text realLenth];
                
                if ( textLenth > maxLenth ) {
                    NSString *tempString = nil;
                    for (NSInteger i=0; i<[myTextField.text length]; i++) {
                        tempString = [myTextField.text substringToIndex:i];
                        if ([tempString realLenth]>maxLenth) {
                            tempString = [myTextField.text substringToIndex:i-1];
                            break;
                        }
                    }
                    myTextField.text = tempString;
                }
                
                textLenth = [myTextField.text realLenth];
                NSUInteger shengLenth = (unsigned long)(maxLenth-textLenth);
                maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            }
        }
        else if (myTextView){
            UITextRange *selectedRange = [myTextView markedTextRange];
            if ( [selectedRange isEmpty] || selectedRange==nil) {
                NSUInteger textLenth = [myTextView.text realLenth];
                
                if ( textLenth > maxLenth ) {
                    NSString *tempString = nil;
                    for (NSInteger i=0; i<[myTextView.text length]; i++) {
                        tempString = [myTextView.text substringToIndex:i];
                        if ([tempString realLenth]>maxLenth) {
                            tempString = [myTextView.text substringToIndex:i-1];
                            break;
                        }
                    }
                    myTextView.text = tempString;
                }
                
                textLenth = [myTextView.text realLenth];
                NSUInteger shengLenth = (unsigned long)(maxLenth-textLenth);
                maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            }
        }
        else{
            
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
    if (myTextField) {
        [myTextField becomeFirstResponder];
    }
    if (myTextView) {
        [myTextView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
    if (myTextField) {
        [myTextField resignFirstResponder];
    }
    if (myTextView) {
        [myTextView resignFirstResponder];
    }
}

#pragma mark ****************************************
#pragma mark Keyboard 监听
#pragma mark ****************************************
- (void)addKeyboardNotification{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)removeKeyboardNotification{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    keyboradAnimationDuration = animationDuration;//键盘两种高度 216  252
    
    [UIView animateWithDuration:animationDuration animations:^{

        if (type==TextEditType_TextFeild) {
            backView.frame = CGRectMake(-10, 0+needAdd, ApplicationWidth+20, MIN(Screen_Height-20-keyboardRect.size.height, 40));
            myTextField.frame = CGRectMake(10, backView.frame.origin.y+needAdd, ApplicationWidth-20, backView.frame.size.height);

            if (maxLenth>0) {
                //限制字数
                maxLenthLabel.frame = CGRectMake(10, CGRectGetMaxY(backView.frame), ApplicationWidth-20, 20);
            }
        }
        else{
            if (maxLenth>0) {
                CGFloat maxHeight = Screen_Height-20-44-keyboardRect.size.height-20 - 20;
                backView.frame = CGRectMake(-10, 0+needAdd, ApplicationWidth+20, maxHeight);
                myTextView.frame = CGRectMake(10, backView.frame.origin.y+10, ApplicationWidth-20, backView.frame.size.height-10-2);
                
                //限制字数
                maxLenthLabel.frame = CGRectMake(10, CGRectGetMaxY(backView.frame), ApplicationWidth-20, 20);
            }
            else{
                CGFloat maxHeight = Screen_Height-20-44-keyboardRect.size.height - 20;
                backView.frame = CGRectMake(-10, 0+needAdd, ApplicationWidth+20, maxHeight);
                myTextView.frame = CGRectMake(10, backView.frame.origin.y+10, ApplicationWidth-20, backView.frame.size.height-10-2);
                maxLenthLabel.frame = CGRectZero;
            }
        }
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        if (type==TextEditType_TextFeild) {
            backView.frame = CGRectMake(-10, 0+needAdd, ApplicationWidth+20, 40);
            myTextField.frame = CGRectMake(10, backView.frame.origin.y, ApplicationWidth-20, backView.frame.size.height);

            if (maxLenth>0) {
                //限制字数
                maxLenthLabel.frame = CGRectMake(10, CGRectGetMaxY(backView.frame), ApplicationWidth-20, 20);
            }
        }
        else{
            backView.frame = CGRectMake(-10, 0+needAdd, ApplicationWidth+20, 122);
            myTextView.frame = CGRectMake(10, backView.frame.origin.y+10, ApplicationWidth-20, backView.frame.size.height-10);

            if (maxLenth>0) {
                //限制字数
                maxLenthLabel.frame = CGRectMake(10, CGRectGetMaxY(backView.frame), ApplicationWidth-20, 20);
            }
        }
    
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark ****************************************
#pragma mark 【UITextFieldDelegate】
#pragma mark ****************************************
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self checkMaxLenth];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self finishedEdit];
    return YES;
}

- (void)UITextFieldTextDidChangeNotification:(NSNotification*)notice{
    [self checkMaxLenth];
}

#pragma mark ****************************************
#pragma mark 【UITextViewDelegate】
#pragma mark ****************************************
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (isSingleLine && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else{
        [self checkMaxLenth];
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    return YES;
}

- (void)UITextViewTextDidChangeNotification:(NSNotification*)notice{
    [self checkMaxLenth];
}


@end
