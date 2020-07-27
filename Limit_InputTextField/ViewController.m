//
//  ViewController.m
//  Limit_InputTextField
//
//  Created by AMBER088 on 2020/7/27.
//  Copyright © 2020 AMBER088. All rights reserved.
//

#import "ViewController.h"
#import "InputTextField.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    InputTextField *textfield = [[InputTextField alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [textfield setBackgroundColor:[UIColor redColor]];
    textfield.max_length = 10;
    textfield.inputType = LimitInputTextFieldTypeCharacter | LimitTextFieldInputTypeHant;
    [self.view addSubview:textfield];
    // Do any additional setup after loading the view.
}


@end
