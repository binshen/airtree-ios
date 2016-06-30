//
//  DeviceViewController.h
//  airtree
//
//  Created by Bin Shen on 6/30/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTest;

- (void) setLabel:(NSString *) indexStr;

@end
