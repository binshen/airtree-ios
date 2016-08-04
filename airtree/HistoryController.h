//
//  HistoryController.h
//  airtree
//
//  Created by Bin Shen on 5/31/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePicker.h"

@interface HistoryController : UIViewController

@property (strong, nonatomic) DateTimePicker *pickerView;
@property (nonatomic, retain) NSDate *selectedDate;

@property (weak, nonatomic) IBOutlet UIButton *DateSelect;
@property (weak, nonatomic) IBOutlet UILabel *LabelDescription;

@property (weak, nonatomic) IBOutlet UILabel *mainValue;
@property (weak, nonatomic) IBOutlet UILabel *pm25Value;
@property (weak, nonatomic) IBOutlet UILabel *temperatureValue;
@property (weak, nonatomic) IBOutlet UILabel *humidityValue;
@property (weak, nonatomic) IBOutlet UILabel *formaldehydeValue;

@property (weak, nonatomic) IBOutlet UILabel *pm25Label;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *formaldehydeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *DividerLine;

@end
