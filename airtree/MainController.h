//
//  MainController.h
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *devices;

@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UIButton *BtnHistory;
@property (weak, nonatomic) IBOutlet UIButton *BtnDevice;

@end
