//
//  MonitorController.h
//  airtree
//
//  Created by Bin Shen on 7/3/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitorController : UIViewController <UIScrollViewDelegate>

@property NSUInteger pageIndex;
@property NSDictionary *pageDevice;


@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
