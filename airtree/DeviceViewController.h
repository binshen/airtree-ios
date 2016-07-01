//
//  DeviceViewController.h
//  airtree
//
//  Created by Bin Shen on 6/30/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *electric;
@property (weak, nonatomic) IBOutlet UILabel *airQuality;
@property (weak, nonatomic) IBOutlet UILabel *main;
@property (weak, nonatomic) IBOutlet UILabel *mainLable;
@property (weak, nonatomic) IBOutlet UILabel *suggest;
@property (weak, nonatomic) IBOutlet UILabel *suggestTime;
@property (weak, nonatomic) IBOutlet UILabel *pm25Value;
@property (weak, nonatomic) IBOutlet UILabel *temperatureValue;
@property (weak, nonatomic) IBOutlet UILabel *humidityValue;
@property (weak, nonatomic) IBOutlet UILabel *formaldehydeValue;

- (void) initViews: (NSDictionary *) device;

@end
