//
//  DeviceInfoController.m
//  airtree
//
//  Created by Bin Shen on 6/1/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "DeviceInfoController.h"
#import "DeviceDetailReviseController.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"

@interface DeviceInfoController ()

@end

@implementation DeviceInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *device = appDelegate.selectedDevice;
    NSString *deviceName = device[@"name"] == nil ? device[@"mac"] : device[@"name"];
    NSLog(@"DeviceName: %@", deviceName);
    
    cell.detailTextLabel.text = deviceName;
}

- (IBAction)unBindDevice:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary  *loginUser = appDelegate.loginUser;
    NSDictionary *device = appDelegate.selectedDevice;
    
    NSString *path = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"/user/%@/device/%@/unbind", loginUser[@"_id"], device[@"_id"]]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:@"121.40.92.176:3000"];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        // NSString *response = [completedRequest responseAsString];
        // NSLog(@"Response: %@", response);
        
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *success = [json objectForKey:@"success"];
        NSLog(@"Success: %@", success);
        if([success boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误信息" message:[json objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    [host startRequest:request];
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceInfoCell" forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *device = appDelegate.selectedDevice;
    
    NSInteger index = [indexPath row];
    switch (index) {
        case 0:
            cell.textLabel.text = @"设备编码";
            cell.detailTextLabel.text = device[@"_id"];
            break;
        case 1:
            cell.textLabel.text = @"设备名称";
            cell.detailTextLabel.text = [device valueForKey:@"name"] == nil ? device[@"mac"] : device[@"name"];;
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell.textLabel.text = @"类型";
            cell.detailTextLabel.text = [device[@"type"] integerValue] == 1 ? @"主机" : @"从机";
            break;
        case 3:
            cell.textLabel.text = @"MAC";
            cell.detailTextLabel.text = [device[@"mac"] uppercaseString];
            break;
        case 4:
            cell.textLabel.text = @"历史数据";
            cell.detailTextLabel.text = @"";
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 5:
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = [indexPath row];
    if (index == 1) {
        DeviceDetailReviseController *deviceDetailRevise = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceDetailReviseController"];
        [[self navigationController] pushViewController:deviceDetailRevise animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
