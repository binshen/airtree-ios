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
#import "Person.h"

@interface PersonController ()

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
    
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:5];
    Person *person = [[Person alloc] init];
    person.index = 1;
    person.title = @"昵称";
    person.detail = @"13999999999";
    [itemList addObject:person];
    
    person = [[Person alloc] init];
    person.index = 2;
    person.title = @"修改密码";
    person.detail = @"";
    [itemList addObject:person];
    
    person = [[Person alloc] init];
    person.index = 3;
    person.title = @"";
    person.detail = @"";
    [itemList addObject:person];
    
    person = [[Person alloc] init];
    person.index = 4;
    person.title = @"滤网检查";
    person.detail = @"";
    [itemList addObject:person];
    
    person = [[Person alloc] init];
    person.index = 5;
    person.title = @"用户反馈";
    person.detail = @"";
    [itemList addObject:person];
    
    self.items = itemList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickLogout:(id)sender {
    NSLog(@"Logout");
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
    
    NSUInteger row = [indexPath row];
    Person *person = [self.items objectAtIndex:row];
    cell.textLabel.text = [person title];
    cell.detailTextLabel.text = [person detail];
    
    if (person.index == 3) {
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = [[self.items objectAtIndex:[indexPath row]] index];
    //UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的行信息" message:[NSString stringWithFormat:@"%d", index] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alter show];
    
    if(index == 1) {
        PersonNicknameController *personNickname = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonNicknameController"];
        [[self navigationController] pushViewController:personNickname animated:YES];
    } else if(index == 2) {
        PersonPasswordController *personNickname = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonPasswordController"];
        [[self navigationController] pushViewController:personNickname animated:YES];
    } else if(index == 4) {
        
    } else if(index == 5) {
        PersonFeedbackController *personNickname = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonFeedbackController"];
        [[self navigationController] pushViewController:personNickname animated:YES];

    } else {
        
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
