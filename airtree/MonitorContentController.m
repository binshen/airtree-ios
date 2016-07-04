//
//  MonitorContentController.m
//  airtree
//
//  Created by Bin Shen on 7/3/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "MonitorContentController.h"
#import "AppDelegate.h"

@interface MonitorContentController ()

@end

@implementation MonitorContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initViews:(NSUInteger) pageIndex withDevice:(NSDictionary *) device {
    //NSLog(@"%@", device);
    
    if(device[@"data"] == nil) {
        self.LabelCreatedTime.text = @"0000-00-00 00:00:00";
        self.LabelTop.text = @"";
        self.LabelMain.text = @"0";
        self.LabelBottom.text = @"";
        [self.ImgChart setImage:[UIImage imageNamed:@"bg_pm"]];
    } else {
        NSDictionary *data = device[@"data"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.LabelCreatedTime.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([data[@"created"] longLongValue] / 1000)]];
        
        if(pageIndex == 0) {
            self.LabelTop.text = @"PM2.5";
            self.LabelMain.text = [NSString stringWithFormat:@"%@", data[@"x1"]];
            self.LabelBottom.text = @"ug/m³";
            [self.ImgChart setImage:[UIImage imageNamed:@"bg_pm.png"]];
        } else if(pageIndex == 1) {
            self.LabelTop.text = @"温度";
            self.LabelMain.text = [NSString stringWithFormat:@"%@", data[@"x11"]];
            self.LabelBottom.text = @"当前温度";
            [self.ImgChart setImage:[UIImage imageNamed:@"bg_wendu.png"]];
        } else if(pageIndex == 2) {
            self.LabelTop.text = @"湿度";
            self.LabelMain.text = [NSString stringWithFormat:@"%@", data[@"x10"]];
            self.LabelBottom.text = @"";
            [self.ImgChart setImage:[UIImage imageNamed:@"bg_shidu.png"]];
        } else {
            self.LabelTop.text = @"甲醛";
            self.LabelMain.text = [NSString stringWithFormat:@"%@", data[@"x9"]];
            self.LabelBottom.text = @"mg/m³";
            [self.ImgChart setImage:[UIImage imageNamed:@"bg_jiaquan.png"]];
        }
        
        NSInteger pmData = [data[@"x1"] integerValue];
        if(pmData <= 35) {
            self.LabelStatus.text = @"咱家空气棒棒哒，连呼吸都是甜的呢~";
            [self.ImgStatus setImage:[UIImage imageNamed:@"good.gif"]];
        } else if(pmData <= 75) {
            self.LabelStatus.text = @"空气不错哦~只要再一丢丢的努力就完美啦~";
            [self.ImgStatus setImage:[UIImage imageNamed:@"very.gif"]];
        } else if(pmData <= 150) {
            self.LabelStatus.text = @"加把劲吧，咱家空气需要大大的改善~";
            [self.ImgStatus setImage:[UIImage imageNamed:@"general.gif"]];
        } else {
            self.LabelStatus.text = @"你家的空气太糟糕啦，我要离家出走了~";
            [self.ImgStatus setImage:[UIImage imageNamed:@"poor.gif"]];
        }
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
