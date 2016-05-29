//
//  ShopController.m
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "ShopController.h"

@interface ShopController ()

@end

@implementation ShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //_WebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 370)];
    _WebView.opaque = NO;
    _WebView.backgroundColor = [UIColor clearColor];
    _WebView.scalesPageToFit = YES;
    [self.view addSubview:_WebView];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://moral.tmall.com"];
    [_WebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
