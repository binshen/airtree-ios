//
//  MonitorController.m
//  airtree
//
//  Created by Bin Shen on 7/3/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "MonitorController.h"
#import "MonitorContentController.h"

@interface MonitorController ()

@end

@implementation MonitorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 一个页面的宽度就是scrollview的宽度
    self.scrollView.pagingEnabled = YES;  // 自动滚动到subview的边界
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.autoresizingMask = NO;
    self.scrollView.delegate = self;
    //self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * 4, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * 4, 0);
    
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.userInteractionEnabled =YES;
    self.pageControl.currentPage = self.pageIndex;
    self.pageControl.numberOfPages = 4;
    
    // 初始化page control的内容
    self.contentList = [[NSArray alloc] init];
    
    [self.view bringSubviewToFront:self.pageControl];
    
    // 存储所有的controller
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < 4; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [self.pageControl setHidden:NO];
    
    [self loadScrollViewWithPage: 0];
    [self loadScrollViewWithPage: 1];
    [self loadScrollViewWithPage: 2];
    [self loadScrollViewWithPage: 3];
    
    if(self.pageIndex == 0) {
        self.navigationItem.title = @"PM2.5";
    } else if(self.pageIndex == 1) {
        self.navigationItem.title = @"温度";
    } else if(self.pageIndex == 2) {
        self.navigationItem.title = @"湿度";
    } else {
        self.navigationItem.title = @"甲醛";
    }
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * self.pageIndex, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 加载ScrollView中的不同SubViewController
- (void)loadScrollViewWithPage:(NSUInteger) page {
    if (page >= 4) return;
    
    MonitorContentController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MonitorContentController"];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [controller initViews: page withDevice:self.pageDevice];
        [self.scrollView addSubview:controller.view];
    }
}

// 滑动结束的事件监听
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
//    [self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];

    if (page == 0) {
        self.navigationItem.title = @"PM2.5";
    } else if (page == 1) {
        self.navigationItem.title = @"温度";
    } else if (page == 2) {
        self.navigationItem.title = @"湿度";
    } else {
        self.navigationItem.title = @"甲醛";
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
