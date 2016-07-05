//
//  RegisterController.m
//  airtree
//
//  Created by Bin Shen on 6/1/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "RegisterController.h"
#import "MKNetworkKit.h"

@interface RegisterController ()

@property NSTimer *timer;
@property NSInteger count;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:FALSE animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    if(self.timer != nil) {
        [self.timer invalidate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClickBtnValidate:(id)sender {
    if(self.TextTel.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请输入手机号." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        NSString *path = [[NSString alloc] initWithFormat:@"/user/request_code"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.TextTel.text forKey:@"tel"];
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
            // NSString *response = [completedRequest responseAsString];
            // NSLog(@"Response: %@", response);
            
            NSError *error = [completedRequest error];
            NSData *data = [completedRequest responseData];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *success = [json objectForKey:@"success"];
            NSLog(@"Success: %@", success);
            if([success boolValue]) {
                self.count = 60;
                [self.BtnValidate setTitle:@"剩余60秒" forState:UIControlStateNormal];
                [self.BtnValidate setEnabled:NO];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoRefreshData) userInfo:nil repeats:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:[json objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
        [host startRequest:request];
    }

}

- (IBAction)ClickBtnRegister:(id)sender {
    if(self.TextTel.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请输入手机号." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if(self.TextCode.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请输入验证码." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if(self.TextPwd.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请输入密码." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        NSString *path = [[NSString alloc] initWithFormat:@"/user/register"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.TextTel.text forKey:@"username"];
        [param setValue:self.TextPwd.text forKey:@"password"];
        [param setValue:self.TextCode.text forKey:@"code"];
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
            // NSString *response = [completedRequest responseAsString];
            // NSLog(@"Response: %@", response);
            
            NSError *error = [completedRequest error];
            NSData *data = [completedRequest responseData];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *success = [json objectForKey:@"success"];
            NSLog(@"Success: %@", success);
            if([success boolValue]) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:[json objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
        [host startRequest:request];
    }
}

- (void) autoRefreshData {
    self.count--;
    if(self.count < 1) {
        [self.BtnValidate setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.BtnValidate setEnabled:YES];
    } else {
        [self.BtnValidate setTitle:[NSString stringWithFormat:@"剩余%ld秒", (long)self.count] forState:UIControlStateNormal];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
