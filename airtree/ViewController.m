//
//  ViewController.m
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "ViewController.h"
#import "MKNetworkKit.h"
#import "MainController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_TxtUsername setText:@"13999999999"];
    [_TxtPassword setText:@"888888"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickLogin:(id)sender {
    
    NSString *path = [[NSString alloc] initWithFormat:@"/user/login"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_TxtUsername.text forKey:@"username"];
    [param setValue:_TxtPassword.text forKey:@"password"];
    
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        //NSString *response = [completedRequest responseAsString];
        NSError *error = [completedRequest error];
        
        NSData *data = [completedRequest responseData];
        if (data == nil) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"登录失败"
                                  message:@"请检查网络."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        } else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *success = [json objectForKey:@"success"];
            NSLog(@"Success: %@", success);
            
            BOOL boolValue = [success boolValue];
            if (boolValue) {
                MainController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"MainController"];
                [self presentViewController:main animated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"登录失败"
                                      message:@"输入的用户名或密码错误."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
    [host startRequest:request];
}

@end
