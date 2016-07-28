//
//  DeviceViewController.m
//  airtree
//
//  Created by Bin Shen on 6/30/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "DeviceViewController.h"
#import "MonitorController.h"
#import "UIImage+animatedGIF.h"

@interface DeviceViewController ()

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

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
    
    //self.electric.contentMode = UIViewContentModeScaleAspectFit;
    //CGRect rect = CGRectMake(0, 0, self.electric.frame.size.width/1.5, self.electric.frame.size.height/1.5);
//    CGRect rect = CGRectMake(0, 0, 32, 14);
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
//    [self.electric.image drawInRect:rect];
//    [self.electric setImage:UIGraphicsGetImageFromCurrentImageContext()];
//    UIGraphicsEndImageContext();
    
//    UIView *divider_1 = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/4,303,1,88)];
//    divider_1.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:divider_1];
//    
//    UIView *divider_3 = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/4*3,303,1,88)];
//    divider_3.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:divider_3];
}

- (void)viewDidLayoutSubviews {
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.divider1.frame = CGRectMake(width / 4, 303, 1, 88);
    self.divider3.frame = CGRectMake(width / 4 * 3, 303, 1, 88);
    
    if(IS_IPHONE_6P) {
        self.mainImage.center = CGPointMake(self.mainImage.center.x, self.mainImage.center.y + 15);
        self.lightImage.center = CGPointMake(self.lightImage.center.x + 30, self.lightImage.center.y + 15);
        
        self.airQuality.center = CGPointMake(self.airQuality.center.x, self.airQuality.center.y + 15);
        self.main.center = CGPointMake(self.main.center.x, self.main.center.y + 25);
        self.mainLable.center = CGPointMake(self.mainLable.center.x, self.mainLable.center.y + 40);
        self.suggest.center = CGPointMake(self.suggest.center.x, self.suggest.center.y + 80);
        
        self.viewPm25.center = CGPointMake(self.viewPm25.center.x, self.viewPm25.center.y + 120);
        self.viewTemperature.center = CGPointMake(self.viewTemperature.center.x, self.viewTemperature.center.y + 120);
        self.viewHumidity.center = CGPointMake(self.viewHumidity.center.x, self.viewHumidity.center.y + 120);
        self.viewFormaldehyde.center = CGPointMake(self.viewFormaldehyde.center.x, self.viewFormaldehyde.center.y + 120);
        self.divider1.center = CGPointMake(self.divider1.center.x, self.divider1.center.y + 120);
        self.divider2.center = CGPointMake(self.divider2.center.x, self.divider2.center.y + 120);
        self.divider3.center = CGPointMake(self.divider3.center.x, self.divider3.center.y + 120);
        
        self.electric.frame = CGRectMake(self.electric.frame.origin.x - 20, self.electric.frame.origin.y + 10, self.electric.frame.size.width*1.1, self.electric.frame.size.height*1.1);
        self.mainImage.frame = CGRectMake(self.mainImage.frame.origin.x, self.mainImage.frame.origin.y, self.mainImage.frame.size.width*1.1, self.mainImage.frame.size.height*1.1);
        self.lightImage.frame = CGRectMake(self.lightImage.frame.origin.x, self.lightImage.frame.origin.y, self.lightImage.frame.size.width*1.1, self.lightImage.frame.size.height*1.1);
        
        self.airQuality.font = [UIFont systemFontOfSize: 70];
        self.main.font = [UIFont systemFontOfSize: 90];
        self.mainLable.font = [UIFont systemFontOfSize: 18];
        self.suggest.font = [UIFont systemFontOfSize: 18];
        
        self.pm25Label.font = [UIFont systemFontOfSize: 18];
        self.temperatureLabel.font = [UIFont systemFontOfSize: 18];
        self.humidityLabel.font = [UIFont systemFontOfSize: 18];
        self.formalehydeLabel.font = [UIFont systemFontOfSize: 18];
        self.pm25Value.font = [UIFont systemFontOfSize: 17];
        self.temperatureValue.font = [UIFont systemFontOfSize: 17];
        self.humidityValue.font = [UIFont systemFontOfSize: 17];
        self.formaldehydeValue.font = [UIFont systemFontOfSize: 17];
        
    } else if(IS_IPHONE_6) {
        self.mainImage.center = CGPointMake(self.mainImage.center.x, self.mainImage.center.y + 10);
        self.lightImage.center = CGPointMake(self.lightImage.center.x + 5, self.lightImage.center.y + 10);
        
        self.airQuality.center = CGPointMake(self.airQuality.center.x, self.airQuality.center.y + 10);
        self.main.center = CGPointMake(self.main.center.x, self.main.center.y + 15);
        self.mainLable.center = CGPointMake(self.mainLable.center.x, self.mainLable.center.y + 30);
        self.suggest.center = CGPointMake(self.suggest.center.x, self.suggest.center.y + 40);

        self.viewPm25.center = CGPointMake(self.viewPm25.center.x, self.viewPm25.center.y + 50);
        self.viewTemperature.center = CGPointMake(self.viewTemperature.center.x, self.viewTemperature.center.y + 50);
        self.viewHumidity.center = CGPointMake(self.viewHumidity.center.x, self.viewHumidity.center.y + 50);
        self.viewFormaldehyde.center = CGPointMake(self.viewFormaldehyde.center.x, self.viewFormaldehyde.center.y + 50);
        self.divider1.center = CGPointMake(self.divider1.center.x, self.divider1.center.y + 50);
        self.divider2.center = CGPointMake(self.divider2.center.x, self.divider2.center.y + 50);
        self.divider3.center = CGPointMake(self.divider3.center.x, self.divider3.center.y + 50);
    } else {
        self.lightImage.center = CGPointMake(self.lightImage.center.x - 25, self.lightImage.center.y);
        
        self.airQuality.center = CGPointMake(self.airQuality.center.x, self.airQuality.center.y - 15);
        self.main.center = CGPointMake(self.main.center.x, self.main.center.y - 20);
        self.mainLable.center = CGPointMake(self.mainLable.center.x, self.mainLable.center.y - 15);
        self.suggest.center = CGPointMake(self.suggest.center.x, self.suggest.center.y - 15);
        
        self.viewPm25.center = CGPointMake(self.viewPm25.center.x, self.viewPm25.center.y - 10);
        self.viewTemperature.center = CGPointMake(self.viewTemperature.center.x, self.viewTemperature.center.y - 10);
        self.viewHumidity.center = CGPointMake(self.viewHumidity.center.x, self.viewHumidity.center.y - 10);
        self.viewFormaldehyde.center = CGPointMake(self.viewFormaldehyde.center.x, self.viewFormaldehyde.center.y - 10);
        self.divider1.center = CGPointMake(self.divider1.center.x, self.divider1.center.y - 10);
        self.divider2.center = CGPointMake(self.divider2.center.x, self.divider2.center.y - 10);
        self.divider3.center = CGPointMake(self.divider3.center.x, self.divider3.center.y - 10);
        
        self.electric.frame = CGRectMake(self.electric.frame.origin.x + 34, self.electric.frame.origin.y, self.electric.frame.size.width*0.8, self.electric.frame.size.height*0.8);
        self.mainImage.frame = CGRectMake(self.mainImage.frame.origin.x, self.mainImage.frame.origin.y, self.mainImage.frame.size.width*0.8, self.mainImage.frame.size.height*0.8);
        self.lightImage.frame = CGRectMake(self.lightImage.frame.origin.x, self.lightImage.frame.origin.y, self.lightImage.frame.size.width*0.8, self.lightImage.frame.size.height*0.8);
        [self.airQuality setFont:[UIFont fontWithName:self.airQuality.font.fontName size:self.airQuality.font.pointSize - 5]];
        [self.main setFont:[UIFont fontWithName:self.main.font.fontName size:self.main.font.pointSize - 10]];
    }
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
        
        NSString *type = device[@"type"];
        if ([type longLongValue] == 1) {
            if ((NSNull *) data == [NSNull null] || ![data objectForKey:@"x13"]) {
                [self.electric setImage:[UIImage imageNamed:@"ic_ele_n0s.png"]];
            } else {
                [self.electric setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_ele_n%@s.png", data[@"x13"]]]];
            }
        } else {
            [self.electric setImage:[UIImage imageNamed:@"ic_ele_n4s.png"]];
        }
        [self.electric setHidden:NO];
    } else {
        if ((NSNull *) data == [NSNull null]) {
            [self.suggest setText:@""];
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([data[@"created"] longLongValue] / 1000)]];
            [self.suggest setText:[NSString stringWithFormat:@"上次检测时间:\n%@", dateString]];
        }
        
        [self.electric setHidden:YES];
    }
    
    if ((NSNull *) data == [NSNull null]) {
        [self.pm25Value setText:@"0ug/m³"];
        [self.temperatureValue setText:@"0℃"];
        [self.humidityValue setText:@"0%"];
        [self.formaldehydeValue setText:@"0mg/m³"];
        [self.suggest setText:@""];
        [self.airQuality setText:@"未知"];
    } else {
        NSInteger p1 = [data[@"p1"] integerValue];
        if(p1 == 3) {
            if([data objectForKey:@"x9"]) {
                [self.main setText:[NSString stringWithFormat:@"%@", data[@"x9"]]];
                [self.mainLable setText:@"当前甲醛浓度（mg/m³）"];
            } else {
                [self.main setText:@"未知"];
                [self.mainLable setHidden:YES];
            }
        } else if(p1 == 4) {
            if([data objectForKey:@"x11"]) {
                [self.main setText:[NSString stringWithFormat:@"%@", data[@"x11"]]];
                [self.mainLable setText:@"当前温度（℃）"];
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
                [self.mainImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"rank_1" withExtension:@"gif"]]];
            } else if(feiLevel == 2) {
                [self.airQuality setText:@"良"];
                [self.mainImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"rank_2" withExtension:@"gif"]]];
            } else if(feiLevel == 3) {
                [self.airQuality setText:@"中"];
                [self.mainImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"rank_3" withExtension:@"gif"]]];
            } else if(feiLevel == 4) {
                [self.airQuality setText:@"差"];
                [self.mainImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"rank_4" withExtension:@"gif"]]];
            } else {
                [self.airQuality setText:@"未知"];
            }
        } else {
            if([pm25 longLongValue] <= 35) {
                [self.airQuality setText:@"优"];
                [self.mainImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"rank_1" withExtension:@"gif"]]];
            } else if([pm25 longLongValue] <= 75) {
                [self.airQuality setText:@"良"];
                [self.mainImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"rank_2" withExtension:@"gif"]]];
            } else if([pm25 longLongValue] <= 150) {
                [self.airQuality setText:@"中"];
                [self.mainImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"rank_3" withExtension:@"gif"]]];
            } else {
                [self.airQuality setText:@"差"];
                [self.mainImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"rank_4" withExtension:@"gif"]]];
            }
        }
        
        NSInteger x14 = [data[@"x14"] integerValue];
        if(x14 <= 0) {
            return;
        }
        if(x14 > 500) {
            [self.lightImage setImage:[UIImage imageNamed:@"light_01.png"]];
        } else if(x14 < 100) {
            [self.lightImage setImage:[UIImage imageNamed:@"light_03.png"]];
        } else {
            [self.lightImage setImage:[UIImage imageNamed:@"light_02.png"]];
        }
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
