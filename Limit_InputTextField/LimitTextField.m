//
//  LimitTextField.m
//  Limit_InputTextField
//
//  Created by AMBER088 on 2020/7/27.
//  Copyright © 2020 AMBER088. All rights reserved.
//

#import "LimitTextField.h"

@implementation LimitTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self init_data];
    }
    return self;
}

- (void)init_data
{
    self.inputType = LimitInputTextFieldTypeNone;
    self.delegate = self;
    [self addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
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
    if (string.length > maxNumber) {
        string = [string substringToIndex:maxNumber];
    }
    return string;
//    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSData* data = [string dataUsingEncoding:encoding];
//    NSInteger length = [data length];
//    if (length > maxNumber) {
//        NSData *data1 = [data subdataWithRange:NSMakeRange(0, maxNumber)];
//        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//【注意4】：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
//        if (!content || content.length == 0) {
//            data1 = [data subdataWithRange:NSMakeRange(0, maxNumber - 1)];
//            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
//        }
//        return content;
//    }
//    return string;
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
        textField.text = getStr;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //处理如下的特殊情况
    if (self.inputType != LimitInputTextFieldTypeNone && [string isEqualToString:@"-"]) {
         return NO;
    }
    //最大输入做限制，防止越界报错
    if (textField.text.length >= self.max_length && string.length > range.length) {
        return NO;
    }
    return YES;
}

@end
