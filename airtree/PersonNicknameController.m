//
//  PersonNicknameController.m
//  airtree
//
//  Created by Bin Shen on 5/31/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "PersonNicknameController.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"

@interface PersonNicknameController ()

@end

@implementation PersonNicknameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary  *loginUser = appDelegate.loginUser;
    if (loginUser[@"nickname"] != nil) {
        [self.TextNickname setText:loginUser[@"nickname"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickUpdate:(id)sender {
    if(self.TextNickname.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交失败" message:@"请输入昵称." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSMutableDictionary  *loginUser = appDelegate.loginUser;
        
        NSString *path = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"/user/%@/update_name", loginUser[@"_id"]]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.TextNickname.text forKey:@"nickname"];
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
            // NSString *response = [completedRequest responseAsString];
            // NSLog(@"Response: %@", response);
            
            NSError *error = [completedRequest error];
            NSData *data = [completedRequest responseData];
            if (data == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交失败" message:@"修改失败，请稍候再试." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSString *success = [json objectForKey:@"success"];
                NSLog(@"Success: %@", success);
                if([success boolValue]) {
                    [loginUser setObject:self.TextNickname.text forKey:@"nickname"];
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交失败" message:[json objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
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
