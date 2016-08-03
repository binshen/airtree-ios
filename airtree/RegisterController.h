//
//  RegisterController.h
//  airtree
//
//  Created by Bin Shen on 6/1/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *BtnValidate;
@property (weak, nonatomic) IBOutlet UIButton *BtnRegister;

@property (weak, nonatomic) IBOutlet UITextField *TextTel;
@property (weak, nonatomic) IBOutlet UITextField *TextCode;
@property (weak, nonatomic) IBOutlet UITextField *TextPwd;

@end
