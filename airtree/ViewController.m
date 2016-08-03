//
//  ViewController.m
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"
#import "Constants.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    //[self.TxtUsername setText:@"13999999999"];
    //[self.TxtPassword setText:@"888888"];
    
    self.TxtUsername.delegate = self;
    self.TxtUsername.keyboardType = UIKeyboardTypeNumberPad;
    
//    if([[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"] != nil){
//        NSMutableDictionary *loginUser = [[NSMutableDictionary alloc] init];
//        [loginUser setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"] forKey:@"_id"];
//        [loginUser setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"] forKey:@"username"];
//        [loginUser setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"password"] forKey:@"password"];
//        [loginUser setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"nickname"] forKey:@"nickname"];
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        appDelegate.loginUser = [loginUser mutableCopy];
//        
//        UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavMainViewController"];
//        [self presentViewController:nav animated:YES completion:nil];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationItem setHidesBackButton:TRUE animated:NO];
    [self.navigationController setNavigationBarHidden:TRUE animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 11) ? NO : YES;
}

- (IBAction)clickLoginButton:(id)sender {
    NSString *path = [[NSString alloc] initWithFormat:@"/user/login"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.TxtUsername.text forKey:@"username"];
    [param setValue:self.TxtPassword.text forKey:@"password"];
    
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSString *response = [completedRequest responseAsString];
        NSLog(@"Response: %@", response);
        
        NSError *error = [completedRequest error];
        
        NSData *data = [completedRequest responseData];
        if (data == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请检查网络." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *success = [json objectForKey:@"success"];
            NSLog(@"Success: %@", success);

            NSDictionary *user = [json objectForKey:@"user"];
            BOOL boolValue = [success boolValue];
            if (boolValue && ![user isEqual:[NSNull null]]) {
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                appDelegate.loginUser = [user mutableCopy];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:user[@"_id"] forKey:@"user_id"];
                [userDefaults setObject:user[@"username"] forKey:@"username"];
                [userDefaults setObject:user[@"password"] forKey:@"password"];
                [userDefaults setObject:user[@"nickname"] forKey:@"nickname"];
                [userDefaults synchronize];
                
                UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavMainViewController"];
                [self presentViewController:nav animated:YES completion:nil];
            } else {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:nil forKey:@"user_id"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"输入的用户名或密码错误." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
    [host startRequest:request];
}

@end
