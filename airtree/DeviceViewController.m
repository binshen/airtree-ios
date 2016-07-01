//
//  DeviceViewController.m
//  airtree
//
//  Created by Bin Shen on 6/30/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "DeviceViewController.h"

@interface DeviceViewController ()
//#define ARC4RANDOM_MAX      0x100000000
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[_lblTest setText: [NSString stringWithFormat:@"%f", floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) initViews:(NSDictionary *)device {
    //NSLog(@"%@", device);
    
    NSString *status = device[@"status"];
    if ([status longLongValue] == 1) {
        [self.mainLable setText:@"云端在线"];
    } else {
        [self.mainLable setText:@"不在线"];
    }
    
    NSDictionary *data = device[@"data"];
    if ((NSNull *) data == [NSNull null])
    {
        [self.main setText:@"0"];
        [self.pm25Value setText:@"0ug/m³"];
        [self.temperatureValue setText:@"0℃"];
        [self.humidityValue setText:@"0%%"];
        [self.formaldehydeValue setText:@"0mg/m³"];
    }
    else
    {
        [self.main setText:[NSString stringWithFormat:@"%@", data[@"x3"]]];
        [self.pm25Value setText:[NSString stringWithFormat:@"%@ug/m³", data[@"x1"]]];
        [self.temperatureValue setText:[NSString stringWithFormat:@"%@℃", data[@"x11"]]];
        [self.humidityValue setText:[NSString stringWithFormat:@"%@%%", data[@"x10"]]];
        [self.formaldehydeValue setText:[NSString stringWithFormat:@"%@mg/m³", data[@"x9"]]];
    }
    
    NSString *type = device[@"type"];
    if ([type longLongValue] == 1)
    {
        NSString *electric = device[@"data"][@"x13"];
        [self.electric setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_ele_%@.png", electric]]];
    }
    else
    {
        [self.electric setImage:[UIImage imageNamed:@"ic_ele_5.png"]];
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
