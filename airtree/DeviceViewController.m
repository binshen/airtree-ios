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

@synthesize parentController;

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
    NSLog(@"1111");
//    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavMonitorViewController"];
//    [self presentViewController:nav animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
    NSLog(@"------------------------");
    NSLog(@"%@",self.parentController);
    UINavigationController *monitor = [self.storyboard instantiateViewControllerWithIdentifier:@"MonitorViewController"];
    [[self.parentController navigationController] pushViewController:monitor animated:YES];
}

- (void)clickTemperatureTap:(UITapGestureRecognizer *) recognizer {
    NSLog(@"2222");
}

- (void)clickHumidityTap:(UITapGestureRecognizer *) recognizer {
    NSLog(@"3333");
}

- (void)clickFormaldehydeTap:(UITapGestureRecognizer *) recognizer {
    NSLog(@"4444");
}

- (void) initViews:(NSDictionary *)device initController:(UIViewController *) controller {
    //NSLog(@"%@", device);
    
    self.parentController = controller;
    
    NSString *status = device[@"status"];
    if ([status longLongValue] == 1) {
        [self.mainLable setText:@"云端在线"];
        [self.suggest setHidden:YES];
        [self.suggestTime setHidden:YES];
    } else {
        [self.mainLable setText:@"不在线"];
        [self.suggest setHidden:NO];
        [self.suggestTime setHidden:NO];
    }
    
    NSDictionary *data = device[@"data"];
    if ((NSNull *) data == [NSNull null])
    {
        [self.main setText:@"0"];
        [self.pm25Value setText:@"0ug/m³"];
        [self.temperatureValue setText:@"0℃"];
        [self.humidityValue setText:@"0%%"];
        [self.formaldehydeValue setText:@"0mg/m³"];
        [self.suggestTime setText:@"0000-00-00 00:00:00"];
        [self.airQuality setText:@"未知"];
    }
    else
    {
        NSString *pm25 = data[@"x1"];
        [self.main setText:[NSString stringWithFormat:@"%@", data[@"x3"]]];
        [self.pm25Value setText:[NSString stringWithFormat:@"%@ug/m³", pm25]];
        [self.temperatureValue setText:[NSString stringWithFormat:@"%@℃", data[@"x11"]]];
        [self.humidityValue setText:[NSString stringWithFormat:@"%@%%", data[@"x10"]]];
        [self.formaldehydeValue setText:[NSString stringWithFormat:@"%@mg/m³", data[@"x9"]]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([data[@"created"] longLongValue] / 1000)]];
        [self.suggestTime setText:dateString];
        
        if([pm25 longLongValue] <= 35) {
            [self.airQuality setText:@"优"];
        } else if([pm25 longLongValue] <= 75) {
            [self.airQuality setText:@"良"];
        } else if([pm25 longLongValue] <= 75) {
            [self.airQuality setText:@"一般"];
        } else {
            [self.airQuality setText:@"差"];
        }
    }
    
    NSString *type = device[@"type"];
    if ([type longLongValue] == 1)
    {
        if ((NSNull *) data == [NSNull null] || ![data objectForKey:@"x13"])
        {
            [self.electric setImage:[UIImage imageNamed:@"ic_ele_1.png"]];
        }
        else
        {
            [self.electric setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_ele_%@.png", data[@"x13"]]]];
        }
    }
    else
    {
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
