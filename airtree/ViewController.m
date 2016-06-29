//
//  ViewController.m
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "ViewController.h"
#import "MKNetworkKit.h"
#import "NavViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_TxtUsername setText:@"13999999999"];
    [_TxtPassword setText:@"888888"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationItem setHidesBackButton:TRUE animated:NO];
    [self.navigationController setNavigationBarHidden:TRUE animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickLoginButton:(id)sender {
    NSString *path = [[NSString alloc] initWithFormat:@"/user/login"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_TxtUsername.text forKey:@"username"];
    [param setValue:_TxtPassword.text forKey:@"password"];
    
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSString *response = [completedRequest responseAsString];
        NSLog(@"Response: %@", response);
        
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

            NSDictionary *user = [json objectForKey:@"user"];
            BOOL boolValue = [success boolValue];
            if (boolValue && ![user isEqual:[NSNull null]]) {
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                appDelegate.loginUser = user;
                
                NavViewController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavViewController"];
                [self presentViewController:nav animated:YES completion:nil];
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
