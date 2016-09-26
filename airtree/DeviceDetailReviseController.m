//
//  DeviceDetailReviseController.m
//  airtree
//
//  Created by Bin Shen on 6/1/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "DeviceDetailReviseController.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"
#import "Global.h"

@interface DeviceDetailReviseController ()

@end

@implementation DeviceDetailReviseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSDictionary *device = appDelegate.selectedDevice;
    if (device[@"name"] != nil) {
        [self.TextDeviceName setText:device[@"name"]];
    } else {
        [self.TextDeviceName setText:device[@"mac"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickUpdate:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    if(self.TextDeviceName.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请输入设备名称." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        NSDictionary *loginUser = appDelegate.loginUser;
        NSMutableDictionary *device = appDelegate.selectedDevice;
        
        NSString *path = [NSString stringWithFormat:@"/user/%@/device/%@/update_name", loginUser[@"_id"], device[@"_id"]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.TextDeviceName.text forKey:@"name"];
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
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
                [device setObject:self.TextDeviceName.text forKey:@"name"];
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
