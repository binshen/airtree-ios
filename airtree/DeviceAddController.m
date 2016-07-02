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
    _txtPwd.delegate=self;
    _txtSSID.delegate=self;
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
                    //[self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
                    
                    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    NSDictionary *loginUser = appDelegate.loginUser;
                    
                    NSString *path = [[NSString alloc] initWithFormat:@"/user/add_device"];
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setValue:dev.mac forKey:@"mac"];
                    [param setValue:loginUser[@"_id"] forKey:@"userID"];
                    
                    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
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
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc]
                                                      initWithTitle:@"登录失败"
                                                      message:@"输入的用户名或密码错误."
                                                      delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                            [alert show];
                        }
                    }];
                    [host startRequest:request];
                } failBlock:^(NSString *failmsg) {
                    [self  showAlertWithMsg:failmsg title:@"error"];
                } endBlock:^(NSDictionary *deviceDic) {
                    isconnecting  = false;
                    [self.butConnect setTitle:@"正在连接..." forState:UIControlStateNormal];
                }];
        [self.butConnect setTitle:@"正在连接..." forState:UIControlStateNormal];
    }else{
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            if(isOk){
                isconnecting  = false;
                [self.butConnect setTitle:@"1connect" forState:UIControlStateNormal];
                [self showAlertWithMsg:stopMsg title:@"OK"];
            }else{
                [self showAlertWithMsg:stopMsg title:@"error"];
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

-(void)showAlertWithMsg:(NSString *)msg title:(NSString*)title {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
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
