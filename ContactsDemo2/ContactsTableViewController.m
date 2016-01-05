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

@interface ContactsTableViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic,strong) UISearchController *searchController;

@property (nonatomic,strong)NSMutableArray * searchResult;
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

}


- (void)viewWillAppear:(BOOL)animated{
    // 增加searchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.placeholder = @"搜索联系人...";
    [_searchController.searchBar sizeToFit];

    // 把searchBar放到tableview上方
    self.tableView.tableHeaderView = _searchController.searchBar;
    self.definesPresentationContext = YES;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.active){
        NSLog(@"row is %d",[self.searchResult count] );
        return [self.searchResult count];
    }else{
       NSDictionary *dict = [[ContactsStore sharedStore]allContacts][section];
       NSMutableArray *array = dict[@"content"];
       return [array count];
   }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.searchController.active){
        NSLog(@"enter section");
        return 1;
    }else{
       return [[[ContactsStore sharedStore] allContacts] count];
   }

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactItemCell" forIndexPath:indexPath];
    
    if(self.searchController.active){
        
        ContactItem *item = self.searchResult[indexPath.row];
        
        cell.nameLabel.text = item.name;
        cell.phoneLabel.text = item.phone;
        [ContactTools roundImageView:cell.avatarImage];
        cell.avatarImage.image = item.avatar;
    }else{

    NSDictionary *dict =[[ContactsStore sharedStore] allContacts][indexPath.section];
    NSMutableArray *array = dict[@"content"];
    ContactItem *item = array[indexPath.row];
    
    
    cell.nameLabel.text = item.name;
    cell.phoneLabel.text = item.phone;
    [ContactTools roundImageView:cell.avatarImage];
    cell.avatarImage.image = item.avatar;


      
  }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ContactDetailViewController *detailViewController = [[ContactDetailViewController alloc]init];

    if(self.searchController.active){
        ContactItem *selectedItem = self.searchResult[indexPath.row];
        
        // 将选中的BNRItem对象付给DetailViewController的对象
        detailViewController.item = selectedItem;
        
        // 将创建的BNRDetailViewController对象压入UINavigationController对象的栈
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        // 避免一直保持在选中状态
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else{

    NSDictionary *dict =[[ContactsStore sharedStore] allContacts][indexPath.section];
    NSMutableArray *array = dict[@"content"];
    ContactItem *selectedItem = array[indexPath.row];
    
    // 将选中的BNRItem对象付给DetailViewController的对象
    detailViewController.item = selectedItem;
    
    // 将创建的BNRDetailViewController对象压入UINavigationController对象的栈
    [self.navigationController pushViewController:detailViewController animated:YES];

    // 避免一直保持在选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = [[ContactsStore sharedStore]allContacts][section];
    NSString *title = dict[@"firstLetter"];
    return title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in [[ContactsStore sharedStore]allContacts]) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchText = searchController.searchBar.text;
    searchText = [searchText uppercaseString];
    if([searchText isEqualToString:@""]){
        return;
    }
    if(!self.searchResult){
        self.searchResult = [[NSMutableArray alloc]init];
    }
    if([self.searchResult count]){
        [self.searchResult removeAllObjects];
    }
    
    NSPredicate *preBegin= [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",searchText];
    for(ContactItem *item in [[ContactsStore sharedStore] contactsArray] ){
        NSLog(@"The search is %@,the name is %@,the pinyin is %@",searchText,item.name,item.pinyin);
        // ldap、中文名、缩写、拼音匹配上都可以
        if([preBegin evaluateWithObject:item.name] || [preBegin evaluateWithObject:item.pinyin] || [preBegin evaluateWithObject:item.abbName] || [preBegin evaluateWithObject:item.ldap]){
            NSLog(@"Match %@",item.name);
            [self.searchResult addObject:item];
        }

    }
    [self.tableView reloadData];
}


@end
