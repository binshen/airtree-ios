//
//  DeviceViewController.m
//  airtree
//
//  Created by Bin Shen on 6/30/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "DeviceViewController.h"
#import "MonitorController.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *pm25Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPm25Tap:)];
    [self.viewPm25 addGestureRecognizer:pm25Tap];

    UITapGestureRecognizer *temperatureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTemperatureTap:)];
    [self.viewTemperature addGestureRecognizer:temperatureTap];

    UITapGestureRecognizer *humidityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHumidityTap:)];
    [self.viewHumidity addGestureRecognizer:humidityTap];

    UITapGestureRecognizer *formaldehydeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFormaldehydeTap:)];
    [self.viewFormaldehyde addGestureRecognizer:formaldehydeTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickPm25Tap:(UITapGestureRecognizer *) recognizer {
    if (self.checkDeviceStatus) {
        return;
    }
    self.parentController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    MonitorController *monitor = [self.storyboard instantiateViewControllerWithIdentifier:@"MonitorController"];
    monitor.pageIndex = 0;
    monitor.pageDevice = self.pageDevice;
    [[self.parentController navigationController] pushViewController:monitor animated:YES];
}

- (void)clickTemperatureTap:(UITapGestureRecognizer *) recognizer {
    if (self.checkDeviceStatus) {
        return;
    }
    self.parentController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    MonitorController *monitor = [self.storyboard instantiateViewControllerWithIdentifier:@"MonitorController"];
    monitor.pageIndex = 1;
    monitor.pageDevice = self.pageDevice;
    [[self.parentController navigationController] pushViewController:monitor animated:YES];
}

- (void)clickHumidityTap:(UITapGestureRecognizer *) recognizer {
    if (self.checkDeviceStatus) {
        return;
    }
    self.parentController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    MonitorController *monitor = [self.storyboard instantiateViewControllerWithIdentifier:@"MonitorController"];
    monitor.pageIndex = 2;
    monitor.pageDevice = self.pageDevice;
    [[self.parentController navigationController] pushViewController:monitor animated:YES];
}

- (void)clickFormaldehydeTap:(UITapGestureRecognizer *) recognizer {
    if (self.checkDeviceStatus) {
        return;
    }
    self.parentController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    MonitorController *monitor = [self.storyboard instantiateViewControllerWithIdentifier:@"MonitorController"];
    monitor.pageIndex = 3;
    monitor.pageDevice = self.pageDevice;
    [[self.parentController navigationController] pushViewController:monitor animated:YES];
}

- (BOOL) checkDeviceStatus {
    if ([self.pageDevice[@"status"] integerValue] != 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请启动空气树设备" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return TRUE;
    } else {
        return FALSE;
    }
}

- (void) initViews:(NSDictionary *)device initController:(UIViewController *) controller {
    //NSLog(@"%@", device);
    
    self.pageDevice = device;
    self.parentController = controller;
    
    self.suggest.numberOfLines = 2;
    
    NSString *status = device[@"status"];
    NSDictionary *data = device[@"data"];
    if ([status longLongValue] == 1) {
        [self.suggest setText:@"云端在线"];
    } else {
        if ((NSNull *) data == [NSNull null]) {
            [self.suggest setText:@"无法获取最新数据"];
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([data[@"created"] longLongValue] / 1000)]];
            [self.suggest setText:[NSString stringWithFormat:@"上次检测时间:\n%@", dateString]];
        }
    }
    
    if ((NSNull *) data == [NSNull null]) {
        [self.pm25Value setText:@"0ug/m³"];
        [self.temperatureValue setText:@"0℃"];
        [self.humidityValue setText:@"0%%"];
        [self.formaldehydeValue setText:@"0mg/m³"];
        [self.suggest setText:@""];
        [self.airQuality setText:@"未知"];
    } else {
        NSInteger p1 = [data[@"p1"] integerValue];
        if(p1 == 3) {
            if([data objectForKey:@"x9"]) {
                [self.main setText:[NSString stringWithFormat:@"%@", data[@"x9"]]];
                [self.mainLable setText:@"当前甲醛浓度mg/m³"];
            } else {
                [self.main setText:@"未知"];
                [self.mainLable setHidden:YES];
            }
        } else if(p1 == 4) {
            if([data objectForKey:@"x11"]) {
                [self.main setText:[NSString stringWithFormat:@"%@", data[@"x11"]]];
                [self.mainLable setText:@"当前温度℃"];
            } else {
                [self.main setText:@"未知"];
                [self.mainLable setHidden:YES];
            }
        } else {
            if([data objectForKey:@"x1"]) {
                [self.main setText:[NSString stringWithFormat:@"%@", data[@"x3"]]];
                [self.mainLable setText:@"0.3um颗粒物个数"];
            } else {
                [self.main setText:@"未知"];
                [self.mainLable setHidden:YES];
            }
        }
        
        NSString *pm25 = data[@"x1"];
        [self.pm25Value setText:[NSString stringWithFormat:@"%@ug/m³", data[@"x1"]]];
        [self.temperatureValue setText:[NSString stringWithFormat:@"%@℃", data[@"x11"]]];
        [self.humidityValue setText:[NSString stringWithFormat:@"%@%%", data[@"x10"]]];
        [self.formaldehydeValue setText:[NSString stringWithFormat:@"%@mg/m³", data[@"x9"]]];
        
        if(p1 > 0) {
            NSInteger feiLevel = [data[@"fei"] integerValue];
            if(feiLevel == 1) {
                [self.airQuality setText:@"优"];
            } else if(feiLevel == 2) {
                [self.airQuality setText:@"中"];
            } else if(feiLevel == 3) {
                [self.airQuality setText:@"优"];
            } else if(feiLevel == 4) {
                [self.airQuality setText:@"差"];
            } else {
                [self.airQuality setText:@"未知"];
            }
        } else {
            if([pm25 longLongValue] <= 35) {
                [self.airQuality setText:@"优"];
            } else if([pm25 longLongValue] <= 75) {
                [self.airQuality setText:@"良"];
            } else if([pm25 longLongValue] <= 150) {
                [self.airQuality setText:@"中"];
            } else {
                [self.airQuality setText:@"差"];
            }
        }
    }

    NSString *type = device[@"type"];
    if ([type longLongValue] == 1) {
        if ((NSNull *) data == [NSNull null] || ![data objectForKey:@"x13"]) {
            [self.electric setImage:[UIImage imageNamed:@"ic_ele_1.png"]];
        } else {
            [self.electric setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_ele_%@.png", data[@"x13"]]]];
        }
    } else {
        [self.electric setImage:[UIImage imageNamed:@"ic_ele_5.png"]];
    }
}

//- (void) setParentController: (UINavigationController *) controler {
//    self.parentController = controler;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
