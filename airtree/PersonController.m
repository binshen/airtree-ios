//
//  PersonController.m
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "PersonController.h"
#import "PersonNicknameController.h"
#import "PersonPasswordController.h"
#import "PersonFeedbackController.h"
#import "AppDelegate.h"
#import "MKNetworkKit.h"
#import "Global.h"

@interface PersonController ()

@property NSTimer *timer;
@property NSNumber *avg_number;

@end

@implementation PersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];

//    NSString *nickname = loginUser[@"nickname"] == nil ? _loginUser[@"username"] : _loginUser[@"nickname"];
//    NSLog(@"Nickname: %@", nickname);
//    cell.detailTextLabel.text = nickname;

    [self autoRefreshData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(autoRefreshData) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];

    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) autoRefreshData {
    NSString *path = [NSString stringWithFormat:@"/user/%@/get_avg_data", _loginUser[@"_id"]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"GET"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        if (data != nil) {
            NSDictionary *avgData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            self.avg_number = [avgData valueForKey:@"avg"];
            [self.tableView reloadData];
        }
    }];
    [host startRequest:request];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"SegueToLogout"]) {
        NSString *path = [NSString stringWithFormat:@"/user/%@/offline", _loginUser[@"_id"]];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
        MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"POST"];
        [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
            NSString *response = [completedRequest responseAsString];
            NSLog(@"SegueToLogout: %@", response);
        }];
        [host startRequest:request];

        [MyUserDefault setObject:nil forKey:@"user_id"];

        _loginUser = nil;
    }
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger index = [indexPath row];
    NSString *nickname = _loginUser[@"nickname"] == nil ? _loginUser[@"username"] : _loginUser[@"nickname"];
    switch (index) {
        case 0:
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = nickname;
            break;
        case 1:
            cell.textLabel.text = @"改密码";
            cell.detailTextLabel.text = @"";
            break;
        case 2:
            cell.textLabel.text = @"综合指数";
            cell.detailTextLabel.text = self.avg_number.stringValue;
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 3:
            cell.textLabel.text = @"用户反馈";
            cell.detailTextLabel.text = @"";
            break;
        case 4:
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row] == 4) {
        return 0;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = [indexPath row];
    if(index == 0) {
        PersonNicknameController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonNicknameController"];
        [[self navigationController] pushViewController:controller animated:YES];
    } else if(index == 1) {
        PersonPasswordController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonPasswordController"];
        [[self navigationController] pushViewController:controller animated:YES];
    } else if(index == 3) {
        PersonFeedbackController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonFeedbackController"];
        [[self navigationController] pushViewController:controller animated:YES];
    } else {
        //TODO
    }
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
