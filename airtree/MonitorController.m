//
//  MonitorController.m
//  airtree
//
//  Created by Bin Shen on 7/3/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "MonitorController.h"
#import "MonitorContentController.h"
#import "UIImage+animatedGIF.h"

@interface MonitorController ()

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@end

@implementation MonitorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 一个页面的宽度就是scrollview的宽度
    self.scrollView.pagingEnabled = YES;  // 自动滚动到subview的边界
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.autoresizingMask = NO;
    self.scrollView.delegate = self;
    //self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * 4, CGRectGetHeight(self.scrollView.frame));
    //self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * 4, 0);
    
    CGRect rect = self.scrollView.frame;
    
    CGFloat width = SCREEN_WIDTH;
    if(IS_IPHONE_6 || IS_IPHONE_5) {
        width = SCREEN_WIDTH + 8;
    }
    
    self.scrollView.frame = CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
    self.scrollView.contentSize = CGSizeMake(width * 4, 0);
    
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.pageControl.numberOfPages = 4;
    
    // 初始化page control的内容
    self.contentList = [[NSArray alloc] init];
    
    [self.view bringSubviewToFront:self.pageControl];
    
    // 存储所有的controller
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < 4; i++) {
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
    self.pageControl.currentPage = self.pageIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 加载ScrollView中的不同SubViewController
- (void)loadScrollViewWithPage:(NSUInteger) page {
    if (page >= 4) return;
    
    MonitorContentController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MonitorContentController"];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        if((NSNull *) self.pageDevice[@"data"] != [NSNull null] && self.pageDevice[@"data"] != nil) {
            NSDictionary *data = self.pageDevice[@"data"];
            NSInteger p1 = [data[@"p1"] integerValue];
            if(p1 > 0) {
                NSInteger feiLevel = [data[@"fei"] integerValue];
                if(feiLevel == 1) {
                    self.LabelStatus.text = @"咱家空气棒棒哒，连呼吸都是甜的呢~";
                    [self.ImgStatus setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"good" withExtension:@"gif"]]];
                } else if(feiLevel == 2) {
                    self.LabelStatus.text = @"空气不错哦~只要再一丢丢的努力就完美啦~";
                    [self.ImgStatus setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"very" withExtension:@"gif"]]];
                } else if(feiLevel == 3) {
                    self.LabelStatus.text = @"加把劲吧，咱家空气需要大大的改善~";
                    [self.ImgStatus setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"general" withExtension:@"gif"]]];
                } else {
                    self.LabelStatus.text = @"你家的空气太糟糕啦，我要离家出走了~";
                    [self.ImgStatus setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"poor" withExtension:@"gif"]]];
                }
            } else {
                NSInteger pmData = [data[@"x1"] integerValue];
                if(pmData <= 35) {
                    self.LabelStatus.text = @"咱家空气棒棒哒，连呼吸都是甜的呢~";
                    [self.ImgStatus setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"good" withExtension:@"gif"]]];
                } else if(pmData <= 75) {
                    self.LabelStatus.text = @"空气不错哦~只要再一丢丢的努力就完美啦~";
                    [self.ImgStatus setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"very" withExtension:@"gif"]]];
                } else if(pmData <= 150) {
                    self.LabelStatus.text = @"加把劲吧，咱家空气需要大大的改善~";
                    [self.ImgStatus setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"general" withExtension:@"gif"]]];
                } else {
                    self.LabelStatus.text = @"你家的空气太糟糕啦，我要离家出走了~";
                    [self.ImgStatus setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"poor" withExtension:@"gif"]]];
                }
            }
        }
        
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
