//
//  HistoryController.m
//  airtree
//
//  Created by Bin Shen on 5/31/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "HistoryController.h"

@interface HistoryController ()

@end

@implementation HistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickDateButton:(id)sender {
    UIDatePicker *datePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 216)];
    datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:datePicker];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
}

-(void)dateChanged:(id)sender{
    UIDatePicker  *datePicker = (UIDatePicker*)sender;
    NSDate *selectedDate = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:selectedDate];
    [_DateSelect setTitle:dateString forState:UIControlStateNormal];
    [datePicker removeFromSuperview];
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
