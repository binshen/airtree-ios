//
//  ViewController.h
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *TxtUsername;
@property (weak, nonatomic) IBOutlet UITextField *TxtPassword;
@property (weak, nonatomic) IBOutlet UIButton *BtnLogin;

@end

