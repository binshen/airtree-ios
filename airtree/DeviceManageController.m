//
//  DeviceManageController.m
//  airtree
//
//  Created by Bin Shen on 5/30/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "DeviceManageController.h"
#import "AppDelegate.h"
#import "Device.h"

@interface DeviceManageController ()

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
    
    NSMutableArray *deviceList = [[NSMutableArray alloc] initWithCapacity:20];
    Device *device = [[Device alloc] init];
    device.mac = @"MAC1023C852";
    device.ip = @"192.168.2.123";
    device.status = 4;
    [deviceList addObject:device];
    
    device = [[Device alloc] init];
    device.mac = @"MAC1023C853";
    device.ip = @"192.168.2.124";
    device.status = 3;
    [deviceList addObject:device];
    
    device = [[Device alloc] init];
    device.mac = @"MAC1023C851";
    device.ip = @"192.168.2.125";
    device.status = 3;
    [deviceList addObject:device];
    
    self.devices = deviceList;
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    self.devices = appDelegate.globalDeviceList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return _devices.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DeviceMngCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    Device *device = [self.devices objectAtIndex:row];
    cell.textLabel.text = [[[[device mac] stringByAppendingString:@" ("] stringByAppendingString:@"不在线"] stringByAppendingString:@")"];
    cell.detailTextLabel.text = [device ip];
    
//    UIImage *image = [UIImage imageNamed:@"ic_device"];
//    cell.imageView.image = image;
//    UIImage *highLighedImage = [UIImage imageNamed:@"ic_device"];
//    cell.imageView.highlightedImage = highLighedImage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *rowString = [[self.devices objectAtIndex:[indexPath row]] mac];
//    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的行信息" message:rowString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alter show];
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
