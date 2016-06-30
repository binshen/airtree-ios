//
//  MainController.h
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *BtnHistory;
@property (weak, nonatomic) IBOutlet UIButton *BtnDevice;

@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
