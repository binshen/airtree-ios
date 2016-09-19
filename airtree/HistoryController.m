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
#import "Constants.h"

@interface HistoryController ()

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

@implementation HistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [self.DateSelect setTitle:dateString forState:UIControlStateNormal];
    
    [self initView:[NSDate date]];
    
    self.LabelDescription.layer.cornerRadius = 18;
    self.LabelDescription.layer.masksToBounds = TRUE;
}

- (void)viewDidLayoutSubviews {

    if(IS_IPHONE_5) {
        self.DateSelect.center = CGPointMake(self.DateSelect.center.x, self.DateSelect.center.y - 20);
        self.mainValue.center = CGPointMake(self.mainValue.center.x, self.mainValue.center.y - 50);
        self.LabelDescription.center = CGPointMake(self.LabelDescription.center.x, self.LabelDescription.center.y + 40);
        self.DividerLine.center = CGPointMake(self.DividerLine.center.x, self.DividerLine.center.y + 20);

        self.LabelDescription.font = [UIFont systemFontOfSize: 15];

        self.pm25Value.font = [UIFont systemFontOfSize: 14];
        self.pm25Label.font = [UIFont systemFontOfSize: 14];
        self.temperatureValue.font = [UIFont systemFontOfSize: 14];
        self.temperatureLabel.font = [UIFont systemFontOfSize: 14];
        self.humidityValue.font = [UIFont systemFontOfSize: 14];
        self.humidityLabel.font = [UIFont systemFontOfSize: 14];
        self.formaldehydeValue.font = [UIFont systemFontOfSize: 14];
        self.formaldehydeLabel.font = [UIFont systemFontOfSize: 14];

    } else if(IS_IPHONE_6) {
        self.mainValue.center = CGPointMake(self.mainValue.center.x, self.mainValue.center.y - 15);
    } else if(IS_IPHONE_6P) {
        self.DateSelect.center = CGPointMake(self.DateSelect.center.x, self.DateSelect.center.y + 25);
        self.mainValue.center = CGPointMake(self.mainValue.center.x, self.mainValue.center.y + 30);
        self.LabelDescription.font = [UIFont systemFontOfSize: 20];
    }

    float unit = [[UIScreen mainScreen] bounds].size.width / 8;
    self.pm25Value.center = CGPointMake(unit, self.pm25Value.center.y);
    self.pm25Label.center = CGPointMake(unit, self.pm25Label.center.y);
    
    self.temperatureValue.center = CGPointMake(3*unit, self.temperatureValue.center.y);
    self.temperatureLabel.center = CGPointMake(3*unit, self.temperatureLabel.center.y);
    
    self.humidityValue.center = CGPointMake(5*unit, self.humidityValue.center.y);
    self.humidityLabel.center = CGPointMake(5*unit, self.humidityLabel.center.y);
    
    self.formaldehydeValue.center = CGPointMake(7*unit, self.formaldehydeValue.center.y);
    self.formaldehydeLabel.center = CGPointMake(7*unit, self.formaldehydeLabel.center.y);
}

-(void)pickerChanged:(id)sender {
    self.selectedDate = self.pickerView.picker.date;
}

-(void)donePressed {
    self.pickerView.hidden = YES;
    [self.pickerView removeFromSuperview];
    
    [self initView:self.pickerView.picker.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:self.pickerView.picker.date];
    [self.DateSelect setTitle:dateString forState:UIControlStateNormal];
}

-(void)cancelPressed {
    self.pickerView.hidden = YES;
    [self.pickerView removeFromSuperview];
}

- (IBAction)clickDateButton:(id)sender {
    [self.pickerView removeFromSuperview];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.pickerView = [[DateTimePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300, screenWidth, screenHeight/2)];
    [self.pickerView addTargetForDoneButton:self action:@selector(donePressed)];
    [self.pickerView addTargetForCancelButton:self action:@selector(cancelPressed)];
    
    [self.pickerView setHidden:NO];
    [self.pickerView setMode:UIDatePickerModeDate];
    
    [self.view addSubview:self.pickerView];

    //[self.pickerView.picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void) initView: (NSDate *) date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *day = [dateFormat stringFromDate:date];
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSDictionary  *device = appDelegate.selectedDevice;

    self.navigationItem.title = device[@"name"] == nil ? device[@"mac"] : device[@"name"];
    
    NSString *path = [NSString stringWithFormat:@"/device/mac/%@/get_history?day=%@", device[@"mac"], day];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"GET"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSString *response = [completedRequest responseAsString];
        NSLog(@"History - day: %@ - mac: %@ - data: %@", day, device[@"mac"], response);
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        if(data == nil) {
            [self.mainValue setText:@"0"];
            [self.pm25Value setText:@"0ug/m³"];
            [self.temperatureValue setText:@"0℃"];
            [self.humidityValue setText:@"0%"];
            [self.formaldehydeValue setText:@"0mg/m³"];
        } else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if([json count] < 1) {
                [self.mainValue setText:@"0"];
                [self.pm25Value setText:@"0ug/m³"];
                [self.temperatureValue setText:@"0℃"];
                [self.humidityValue setText:@"0%"];
                [self.formaldehydeValue setText:@"0mg/m³"];
            } else {
                [self.mainValue setText:json[@"x3"] == nil || (NSNull *)json[@"x3"] == [NSNull null] ? @"0" : [NSString stringWithFormat:@"%.f", round([json[@"x3"] floatValue])]];
                [self.pm25Value setText:json[@"x1"] == nil || (NSNull *)json[@"x1"] == [NSNull null] ? @"0ug/m³" : [NSString stringWithFormat:@"%.fug/m³", round([json[@"x1"] floatValue])]];
                [self.temperatureValue setText:json[@"x11"] == nil || (NSNull *)json[@"x11"] == [NSNull null] ? @"0℃" : [NSString stringWithFormat:@"%.f℃", round([json[@"x11"] floatValue])]];
                [self.humidityValue setText:json[@"x10"] == nil || (NSNull *)json[@"x10"] == [NSNull null] ? @"0%" : [NSString stringWithFormat:@"%.f%%", round([json[@"x10"] floatValue])]];
                [self.formaldehydeValue setText:json[@"x9"] == nil || (NSNull *)json[@"x9"] == [NSNull null] ? @"0mg/m³" : [NSString stringWithFormat:@"%.fmg/m³", round([json[@"x9"] floatValue])]];
            }
        }
    }];
    [host startRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
