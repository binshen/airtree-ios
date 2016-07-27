//
//  DeviceAddController.m
//  airtree
//
//  Created by Bin Shen on 5/31/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "DeviceAddController.h"
#import "smartlinklib_7x.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "AppDelegate.h"
#import "MKNetworkKit.h"
#import "Constants.h"

@interface DeviceAddController ()
{
    HFSmartLink * smtlk;
    BOOL isconnecting;
}
@end

@implementation DeviceAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    smtlk = [HFSmartLink shareInstence];
    smtlk.isConfigOneDevice = true;
    smtlk.waitTimers = 30;
    isconnecting=false;
    
    self.progress.progress = 0.0;
    self.switcher.on = smtlk.isConfigOneDevice;
    
    [self showWifiSsid];
    self.txtPwd.text = [self getspwdByssid:self.txtSSID.text];
    self.txtPwd.delegate = self;
    self.txtSSID.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
        isconnecting  = false;
       [self setButTitle:@"开始连接"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)butPressd:(id)sender {
    NSString * ssidStr = self.txtSSID.text;
    NSString * pswdStr = self.txtPwd.text;
    
    [self savePswd];
    self.progress.progress = 0.0;
    if(!isconnecting){
        isconnecting = true;
        [smtlk startWithSSID:ssidStr Key:pswdStr withV3x:true
                processblock: ^(NSInteger pro) {
                    self.progress.progress = (float)(pro)/100.0;
                } successBlock:^(HFSmartLinkDeviceInfo *dev) {
                    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    NSDictionary *loginUser = appDelegate.loginUser;
                    
                    NSString *path = [[NSString alloc] initWithFormat:@"/user/add_device"];
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setValue:dev.mac forKey:@"mac"];
                    [param setValue:loginUser[@"_id"] forKey:@"userID"];
                    
                    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
                    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
                    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
                        NSString *response = [completedRequest responseAsString];
                        NSLog(@"Response: %@", response);
                        
                        NSError *error = [completedRequest error];
                        NSData *data = [completedRequest responseData];
                        
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        NSString *success = [json objectForKey:@"success"];
                        NSLog(@"Success: %@", success);
                        
                        if ([success boolValue]) {
                            if([[json objectForKey:@"status"] integerValue] == 4) {
                                [self showAlertWithMsg:@"该设备已被其他人绑定过" title:@"错误信息"];
                            } else {
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        } else {
                            [self showAlertWithMsg:@"输入的用户名或密码错误." title:@"错误信息"];
                        }
                    }];
                    [host startRequest:request];
                } failBlock:^(NSString *failmsg) {
                    [self setButTitle:@"开始连接"];
                    [self showAlertWithMsg:@"绑定时发生异常，请稍候再试" title:@"错误信息"];
                } endBlock:^(NSDictionary *deviceDic) {
                    isconnecting  = false;
                    
                    [self setButTitle:@"开始连接"];
                }];
        
        [self setButTitle:@"正在连接..."];

    } else {
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            if(isOk){
                isconnecting = false;
                [self setButTitle:@"开始连接"];
                [self showAlertWithMsg:@"配网模式已被终止" title:@"确认信息"];
            } else {
                [self showAlertWithMsg:@"配网模式未能终止，请稍候再试" title:@"错误信息"];
            }
        }];
    }
}

- (IBAction)swPressed:(id)sender {
    if(self.switcher.on) {
        smtlk.isConfigOneDevice = true;
    } else {
        smtlk.isConfigOneDevice = false;
    }
}

- (void) setButTitle:(NSString *) title {
    NSAttributedString *attributedTitle = [self.butConnect attributedTitleForState:UIControlStateNormal];
    NSMutableAttributedString *butTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
    [butTitle.mutableString setString:title];
    [self.butConnect setAttributedTitle:butTitle forState:UIControlStateNormal];

}

-(void)showAlertWithMsg:(NSString *)msg title:(NSString*)title {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)savePswd {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:self.txtPwd.text forKey:self.txtSSID.text];
}

-(NSString *)getspwdByssid:(NSString * )mssid {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:mssid];
}

- (void)showWifiSsid {
    BOOL wifiOK = FALSE;
    NSDictionary *ifs;
    NSString *ssid;
    UIAlertView *alert;
    if (!wifiOK) {
        ifs = [self fetchSSIDInfo];
        ssid = [ifs objectForKey:@"SSID"];
        if (ssid != nil) {
            wifiOK= TRUE;
            self.txtSSID.text = ssid;
        } else {
            alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"请连接Wi-Fi"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
        }
    }
}

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
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
