//
//  ContactsTableViewController.m
//  ContactsDemo2
//
//  Created by penddy on 16/1/2.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactsStore.h"
#import "ContactItem.h"
#import "ContactItemCell.h"
#import "ContactTools.h"
#import "ContactDetailViewController.h"

@interface ContactsTableViewController ()

@end

@implementation ContactsTableViewController


- (instancetype) init{
    self = [super initWithStyle:UITableViewStylePlain];
    //不显示多余的空行
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];    
    return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style{
    return [self init];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"ContactItemCell" bundle:nil];
    // 通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ContactItemCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ContactsStore sharedStore] allItems] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactItemCell" forIndexPath:indexPath];
    NSArray *items = [[ContactsStore sharedStore]allItems];
    ContactItem *item = items[indexPath.row];
    
//    NSString *fc = [[NSString alloc]init];
//    fc = [ContactTools firstCharactor:item.name];
//    NSLog(@"The item is %@",fc);

    
    cell.nameLabel.text = item.name;
    cell.phoneLabel.text = item.phone;
    [ContactTools roundImageView:cell.avatarImage];
    cell.avatarImage.image = item.avatar;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ContactDetailViewController *detailViewController = [[ContactDetailViewController alloc]initWithNibName:@"ContactDetailViewController" bundle:nil];
    ContactDetailViewController *detailViewController = [[ContactDetailViewController alloc]init];
    
    NSArray *items = [[ContactsStore sharedStore]allItems];
    ContactItem *selectedItem = items[indexPath.row];
    
    // 将选中的BNRItem对象付给DetailViewController的对象
    detailViewController.item = selectedItem;
    
    // 将创建的BNRDetailViewController对象压入UINavigationController对象的栈
    [self.navigationController pushViewController:detailViewController animated:YES];

    // 避免一直保持在选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    
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
