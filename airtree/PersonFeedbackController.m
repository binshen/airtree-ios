//
//  PersonFeedbackController.m
//  airtree
//
//  Created by Bin Shen on 5/31/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "PersonFeedbackController.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"

@interface PersonFeedbackController ()

@end

@implementation PersonFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.TextFeedback.layer.borderWidth = 0.5f;
    self.TextFeedback.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSubmit:(id)sender {
    if(self.TextFeedback.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请输入反馈信息." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSDictionary  *loginUser = appDelegate.loginUser;
        
        NSString *path = [NSString stringWithFormat:@"/user/%@/feedback", loginUser[@"_id"]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.TextFeedback.text forKey:@"feedback"];
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
//            NSString *response = [completedRequest responseAsString];
//            NSLog(@"Response: %@", response);
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
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
