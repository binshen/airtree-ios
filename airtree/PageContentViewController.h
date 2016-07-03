//
//  PageContentViewController.h
//  airtree
//
//  Created by Bin Shen on 7/3/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property NSUInteger pageIndex;
@property NSUInteger monitorType;
//@property NSDictionary *device;

@property (weak, nonatomic) IBOutlet UILabel *LabelCreatedTime;
@property (weak, nonatomic) IBOutlet UIImageView *ImgChart;
@property (weak, nonatomic) IBOutlet UILabel *LabelTop;
@property (weak, nonatomic) IBOutlet UILabel *LabelMain;
@property (weak, nonatomic) IBOutlet UILabel *LabelBottom;

@end
