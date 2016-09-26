//
//  DeviceManageController.m
//  airtree
//
//  Created by Bin Shen on 5/30/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "DeviceManageController.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"
#import "Reachability.h"
#import "Global.h"

@interface DeviceManageController ()

@property NSTimer *timer;

@end

@implementation DeviceManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self autoRefreshData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(autoRefreshData) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    [self.timer invalidate];
}

- (void) autoRefreshData {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSDictionary  *loginUser = appDelegate.loginUser;
    
    NSString *path = [NSString stringWithFormat:@"/user/%@/get_device_info", loginUser[@"_id"]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"GET"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        //NSString *response = [completedRequest responseAsString];
        //NSLog(@"Response: %@", response);
        
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        
        if (data == nil) {
            
        } else {
            self.devices = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        [self.tableView reloadData];
    }];
    [host startRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"addNewDevice" ]) {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        NetworkStatus status = [reachability currentReachabilityStatus];
        if(status != ReachableViaWiFi) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:@"请先连接WIFI网络." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return self.devices.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DeviceMngCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *device = [self.devices objectAtIndex:row];
    cell.textLabel.text = [device valueForKey:@"name"] == nil ? device[@"mac"] : device[@"name"];
    cell.detailTextLabel.text = [device[@"status"] integerValue] == 1 ? @"云端在线" : @"不在线";
    
//    UIImage *image = [UIImage imageNamed:@"ic_device"];
//    cell.imageView.image = image;
//    cell.imageView.highlightedImage = image;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.selectedDevice = [[self.devices objectAtIndex:[indexPath row]] mutableCopy];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

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
