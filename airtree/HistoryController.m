//
//  HistoryController.m
//  airtree
//
//  Created by Bin Shen on 5/31/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "HistoryController.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"

@interface HistoryController ()


@end

@implementation HistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [self.DateSelect setTitle:dateString forState:UIControlStateNormal];
    [self initView:[NSDate date]];
}

-(void)pickerChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSLog(@"date: %@",[dateFormatter stringFromDate:[(UIDatePicker*)sender date]]);
    self.selectedDate = self.pickerView.picker.date;
}

-(void)donePressed {
    self.pickerView.hidden = YES;
    [self.pickerView removeFromSuperview];
    [self initView:self.selectedDate];
}

-(void)cancelPressed {
    self.pickerView.hidden = YES;
    [self.pickerView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickDateButton:(id)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.pickerView = [[DateTimePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 240, screenWidth, screenHeight/2 + 35)];
    [self.pickerView addTargetForDoneButton:self action:@selector(donePressed)];
    [self.pickerView addTargetForCancelButton:self action:@selector(cancelPressed)];
    [self.view addSubview:self.pickerView];
    self.pickerView.hidden = NO;
    [self.pickerView setMode:UIDatePickerModeDate];
    [self.pickerView.picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void) initView: (NSDate *) date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *day = [dateFormat stringFromDate:date];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary  *device = appDelegate.selectedDevice;

    self.navigationItem.title = device[@"name"] == nil ? device[@"mac"] : device[@"name"];
    
    NSString *path = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"/device/mac/%@/get_history?day=%@", device[@"mac"], day]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"GET"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSString *response = [completedRequest responseAsString];
        NSLog(@"History - day: %@ - mac: %@ - data: %@", day, device[@"mac"], response);
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        if(data == nil) {
            [self.mainValue setText:@"0"];
            [self.pm25Value setText:@"0"];
            [self.temperatureValue setText:@"0"];
            [self.humidityValue setText:@"0"];
            [self.formaldehydeValue setText:@"0"];
        } else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if([json count] < 1) {
                [self.mainValue setText:@"0"];
                [self.pm25Value setText:@"0"];
                [self.temperatureValue setText:@"0"];
                [self.humidityValue setText:@"0"];
                [self.formaldehydeValue setText:@"0"];
            } else {
                [self.mainValue setText:json[@"x3"] == nil ? @"0" : [NSString stringWithFormat:@"%.f", round([json[@"x3"] floatValue])]];
                [self.pm25Value setText:json[@"x1"] == nil ? @"0" : [NSString stringWithFormat:@"%.f", round([json[@"x1"] floatValue])]];
                [self.temperatureValue setText:json[@"x11"] == nil ? @"0" : [NSString stringWithFormat:@"%.f", round([json[@"x11"] floatValue])]];
                [self.humidityValue setText:json[@"x10"] == nil ? @"0" : [NSString stringWithFormat:@"%.f", round([json[@"x10"] floatValue])]];
                [self.formaldehydeValue setText:json[@"x9"] == nil ? @"0" : [NSString stringWithFormat:@"%.f", round([json[@"x9"] floatValue])]];
            }
        }
    }];
    [host startRequest:request];
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
