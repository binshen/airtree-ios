//
//  MonitorContentController.h
//  airtree
//
//  Created by Bin Shen on 7/3/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitorContentController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *LabelCreatedTime;
@property (weak, nonatomic) IBOutlet UIImageView *ImgChart;
@property (weak, nonatomic) IBOutlet UILabel *LabelTop;
@property (weak, nonatomic) IBOutlet UILabel *LabelMain;
@property (weak, nonatomic) IBOutlet UILabel *LabelBottom;

@property (weak, nonatomic) IBOutlet UIImageView *ImgStatus;
@property (weak, nonatomic) IBOutlet UILabel *LabelStatus;

- (void) initViews:(NSUInteger) pageIndex withDevice:(NSDictionary *) device;

@end
