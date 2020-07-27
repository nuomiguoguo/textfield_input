//
//  InputTextField.m
//  Limit_InputTextField
//
//  Created by AMBER088 on 2020/7/27.
//  Copyright © 2020 AMBER088. All rights reserved.
//

#import "InputTextField.h"


@interface InputTextField() <UITextFieldDelegate>
{
    BOOL _isDelete; //是否为删除键
    NSString * _currentString; //当前显示的字符串
}

@end

@implementation InputTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self init_view];
    }
    return self;
}

- (void)init_view
{
    [self addSubview:self.contentTextField];
    self.inputType = LimitInputTextFieldTypeNone;
    self.max_length = 0;
}

#pragma mark - event

- (NSString *)fetch_regularExpressionBy
{
    NSString *tempRegularString = @"";
    switch (self.inputType) {
        case LimitInputTextFieldTypeNumber:
            tempRegularString = @"[0-9]";
            break;
        case LimitInputTextFieldTypeCharacter:
            tempRegularString = @"[A-Za-z]";
            break;
        case LimitTextFieldInputTypeHant:
            tempRegularString = @"[\u4e00-\u9fa5]";
            break;
        case LimitInputTextFieldTypeNumber|LimitInputTextFieldTypeCharacter:
            tempRegularString = @"[0-9A-Za-z]";
            break;
        case LimitInputTextFieldTypeNumber|LimitTextFieldInputTypeHant:
            tempRegularString = @"[0-9\u4e00-\u9fa5]";
            break;
        case LimitInputTextFieldTypeCharacter|LimitTextFieldInputTypeHant:
            tempRegularString = @"[A-Za-z\u4e00-\u9fa5]";
            break;
        default:
            break;
    }
  return tempRegularString;
}

- (BOOL)checkMatchWithString:(NSString *)inputString
{
    //正则表达式
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:[self fetch_regularExpressionBy] options:NSRegularExpressionCaseInsensitive error:nil];
     //符合条件有几个字节
    NSUInteger tMatchCount = [tNumRegularExpression numberOfMatchesInString:inputString options:NSMatchingReportProgress range:NSMakeRange(0, inputString.length)];
    if (tMatchCount == inputString.length) {
        return YES;
    }
    return NO;
}
- (NSString *)getSubString:(NSString*)string maxNumber:(NSInteger)maxNumber
{
    if (maxNumber > 0 && string.length > maxNumber) {
        string = [string substringToIndex:maxNumber];
    }
    return string;
}

#pragma mark - delegate

- (void)textFieldDidChanged:(UITextField *)textField
{
    //限制的逻辑代码主要写在这里
    NSString *toBeString = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    //在没有高亮输入的情况下，才进行判断。因为高亮输入并不是用户的最终输入
    if (!position) {
        //先过滤掉不符合条件的字符
        if (self.inputType != LimitInputTextFieldTypeNone) {
            for (int i = 0 ; i <textField.text.length; i++) {
                NSString * tempStr = [textField.text substringWithRange:NSMakeRange(i, 1)];
                if (![self checkMatchWithString:tempStr]) {
                    toBeString =  [toBeString stringByReplacingOccurrencesOfString:tempStr withString:@""];
                }
            }
        }
        //然后在进行最大长度截取
        NSString *getStr = [self getSubString:toBeString maxNumber:self.max_length];
        if (!_isDelete && getStr.length < _currentString.length ) {
            //如果不是删除键，出现了删除的现象。则需要用之前的值覆盖当前..
            //处理连续输入英文或者- 带来的删除现象。
            getStr = _currentString;
        }
         textField.text = getStr;
         _currentString = getStr;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _isDelete = NO;
    if (range.length == 1 && string.length == 0) {
        _isDelete = YES;
        return YES;
    }
    //最大输入做限制，防止越界报错
    if (self.max_length > 0 && textField.text.length >= self.max_length && string.length > range.length) {
        return NO;
    }
    return YES;
}

#pragma mark - getter

- (UITextField *)contentTextField
{
    if (!_contentTextField) {
        _contentTextField = [[UITextField alloc] initWithFrame:self.bounds];
        [_contentTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        _contentTextField.delegate = self;

       _contentTextField.autocorrectionType = UITextAutocorrectionTypeNo;//关闭自动联想

    }
    return _contentTextField;
}
@end
