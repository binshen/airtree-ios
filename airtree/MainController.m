//
//  MainController.m
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "MainController.h"
#import "Device.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    [_BtnDevice setUserInteractionEnabled:YES];
    [_BtnDevice addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDeviceButton:)]];
    
    [_BtnHistory setUserInteractionEnabled:YES];
    [_BtnHistory addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHistoryButton:)]];
    
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
    
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
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.devices = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickDeviceButton:(UITapGestureRecognizer *)gestureRecognizer
{
//    TestViewController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"TestViewController"];
//    [self presentViewController:main animated:YES completion:nil];
    
    NSLog(@"clickDeviceButton");
}

-(void)clickHistoryButton:(UITapGestureRecognizer *)gestureRecognizer
{
//    TestViewController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"TestViewController"];
//    [self presentViewController:main animated:YES completion:nil];
    
    NSLog(@"clickHistoryButton");
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
    
    static NSString *CellIdentifier = @"DeviceCell";
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *rowString = [[self.devices objectAtIndex:[indexPath row]] mac];
    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的行信息" message:rowString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
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
