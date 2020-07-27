//
//  LimitTextField.h
//  Limit_InputTextField
//
//  Created by AMBER088 on 2020/7/27.
//  Copyright © 2020 AMBER088. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LimitTextFieldInputType){
    LimitInputTextFieldTypeNone = 0 ,                //初始状态，无限制
    LimitInputTextFieldTypeNumber = 1 << 0,           //纯数字
    LimitInputTextFieldTypeCharacter = 1 << 2,        //纯英文字符
    LimitTextFieldInputTypeHant = 1 << 4              //仅汉字
};

NS_ASSUME_NONNULL_BEGIN

@interface LimitTextField : UITextField <UITextFieldDelegate>

//最大输入长度
@property (nonatomic, assign) int max_length;

@property (nonatomic, assign) LimitTextFieldInputType inputType;


@end

NS_ASSUME_NONNULL_END
