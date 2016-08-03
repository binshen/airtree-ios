//
//  ForgetPwdController.h
//  airtree
//
//  Created by Bin Shen on 6/1/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *BtnValidate;
@property (weak, nonatomic) IBOutlet UIButton *BtnResetPwd;

@property (weak, nonatomic) IBOutlet UITextField *TextTel;
@property (weak, nonatomic) IBOutlet UITextField *TextCode;
@property (weak, nonatomic) IBOutlet UITextField *TextPwd;

@end
