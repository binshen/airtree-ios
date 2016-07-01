//
//  MainController.m
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "MainController.h"
#import "ShopController.h"
#import "DeviceViewController.h"
#import "DeviceManageController.h"
#import "Device.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"

@interface MainController ()
@property NSUInteger numberPages;
@property NSTimer *timer;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    [_BtnDevice setUserInteractionEnabled:YES];
    [_BtnDevice addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDeviceButton:)]];
    
    [_BtnOnlineShop setUserInteractionEnabled:YES];
    [_BtnOnlineShop addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnlineShopButton:)]];
    
    
    [self initHomePage];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(autoRefreshData) userInfo:nil repeats:YES];
    //[[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{[self heartbeat];}];
    
    
    // 初始化page control的内容
    self.contentList = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    
    
    // 一共有多少页
    self.numberPages = self.contentList.count;
    
    // 存储所有的controller
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < self.numberPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // 一个页面的宽度就是scrollview的宽度
    self.scrollView.pagingEnabled = YES;  // 自动滚动到subview的边界
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.numberPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.autoresizingMask = YES;
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTap];
    
    
    self.pageControl.numberOfPages = self.numberPages;
    self.pageControl.currentPage = 0;
    
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.userInteractionEnabled =YES;
//    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}


- (void) initHomePage {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary  *loginUser = appDelegate.loginUser;
    
    NSString *path = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"/user/%@/get_device", loginUser[@"_id"]]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"GET"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSString *response = [completedRequest responseAsString];
        NSLog(@"Response: %@", response);
        
        NSError *error = [completedRequest error];
        
        NSData *data = [completedRequest responseData];
        if (data == nil) {
            
        } else {
            NSArray *jsonList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //NSString *success = [json objectForKey:@"success"];
            for (id device in jsonList) {
                NSLog(@"%@", device[@"_id"]);
            }
        }
    }];
    [host startRequest:request];
}

- (void) autoRefreshData {
    NSLog(@"requestData");
}

//- (void) heartbeat {
//    NSLog(@"heartbeat");
//}

// 加载ScrollView中的不同SubViewController
- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.contentList.count)
        return;
    
    DeviceViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceViewController"];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [controller setLabel:[_contentList objectAtIndex:page]];
        
        [self.scrollView addSubview:controller.view];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.numberPages, CGRectGetHeight(self.scrollView.frame));
    [super viewDidAppear:animated];
}

//- (IBAction) changePage:(id)sender {
//
//    NSInteger page = self.pageControl.currentPage;
//    NSLog(@"当前页面 = %lu", (unsigned long)page);
//    
//    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];
//    
//    // update the scroll view to the appropriate page
//    CGRect bounds = self.scrollView.bounds;
//    bounds.origin.x = CGRectGetWidth(bounds) * page;
//    bounds.origin.y = 0;
//    [self.scrollView scrollRectToVisible:bounds animated: YES];
//}

// 滑动结束的事件监听
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    NSLog(@"最后页面 = %lu", (unsigned long)page);
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

//- (void)doDoubleTap:(UITapGestureRecognizer*)recognizer {
//    NSLog(@"Double Click");
//}

- (void) doDoubleTap:(UITapGestureRecognizer *)sender {
    NSLog(@"Double Click");
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Double Click123");
    }
}

//////////////////////////////////////////////////////////////////////////////


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickDeviceButton:(id)sender {
    DeviceManageController *deviceManage = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceManageController"];
    //[self presentViewController:deviceManage animated:YES completion:nil];
    [[self navigationController] pushViewController:deviceManage animated:YES];
}

- (IBAction)clickOnlineShopButton:(id)sender {
    ShopController *shop = [self.storyboard instantiateViewControllerWithIdentifier:@"ShopController"];
    [[self navigationController] pushViewController:shop animated:YES];

}


#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
