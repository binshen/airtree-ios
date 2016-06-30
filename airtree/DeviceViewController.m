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

- (void) setLabel:(NSString *) indexStr {
    [_lblTest setText: indexStr];
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
