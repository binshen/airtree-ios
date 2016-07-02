//
//  PersonPasswordController.m
//  airtree
//
//  Created by Bin Shen on 5/31/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "PersonPasswordController.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"

@interface PersonPasswordController ()

@end

@implementation PersonPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickUpdate:(id)sender {
    NSString * oldPwd = self.PasswordOld.text;
    NSString * newPwd = self.PasswordNew.text;
    NSString * reNewPwd = self.PasswordReNew.text;
    if(oldPwd.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请输入原密码." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if(newPwd.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请输入新密码." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if(reNewPwd.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请输入确认密码." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if(![newPwd isEqual:reNewPwd]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"两次输入的新密码不一致." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSDictionary  *loginUser = appDelegate.loginUser;
        
        NSString *path = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"/user/%@/change_psw", loginUser[@"_id"]]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:oldPwd forKey:@"password"];
        [param setValue:newPwd forKey:@"new_password"];
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
                //[self.navigationController popToRootViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:[json objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
        [host startRequest:request];
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
