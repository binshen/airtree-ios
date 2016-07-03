//
//  MonitorContentController.m
//  airtree
//
//  Created by Bin Shen on 7/3/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "MonitorContentController.h"
#import "AppDelegate.h"

@interface MonitorContentController ()

@end

@implementation MonitorContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initViews:(NSUInteger *) pageIndex {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *device = appDelegate.selectedDevice;
    NSLog(@"%@", device);
    if((int) pageIndex == 1) {
        self.LabelMain.text = @"11";
    } else if((int) pageIndex == 2) {
        self.LabelMain.text = @"22";
    } else if((int) pageIndex == 3) {
        self.LabelMain.text = @"33";
    } else {
        self.LabelMain.text = @"44";
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
