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
#import <CoreSpotlight/CoreSpotlight.h>


@interface ContactsTableViewController () <UISearchBarDelegate, UISearchResultsUpdating,RefreshDataDelegate>

@property (nonatomic,strong) UISearchController *searchController;

@property (nonatomic,strong)NSMutableArray * searchResult;
@end

@implementation ContactsTableViewController


- (instancetype) init{
    self = [super initWithStyle:UITableViewStylePlain];
    //不显示多余的空行
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [ContactsStore sharedStore].delegate = self;
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
    
    // 声明接收UpdateContact通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"UpdateContact" object:nil];
    
    
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

- (void)refreshData{
    [self.tableView reloadData];
}

- (void)refreshSpotlight{
    NSMutableArray *searchableItems = [NSMutableArray new];
    [[ContactsStore sharedStore].allContactsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc]initWithItemContentType:@"views"];
        ContactItem *contact = obj;
        attributeSet.title = contact.name;
        attributeSet.phoneNumbers = [NSArray arrayWithObjects:contact.phone, nil];
        attributeSet.contentDescription = contact.phone;
        attributeSet.supportsPhoneCall = [NSNumber numberWithInt:1];
        attributeSet.keywords = [NSArray arrayWithObjects:contact.name,contact.ldap,contact.abbName,contact.pinyin,nil];
        attributeSet.thumbnailData = UIImagePNGRepresentation(contact.avatar);
        CSSearchableItem *item = [[CSSearchableItem alloc]initWithUniqueIdentifier:contact.ldap domainIdentifier:@"com.penddy.ContactsDemo2" attributeSet:attributeSet];
        [searchableItems addObject:item];
        
    }];
    [[CSSearchableIndex defaultSearchableIndex]indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"Search Item faild to be indexed");
        }else{
            NSLog(@"Search item indexed");
        }
    }];
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
    if(self.searchController.active){
        return nil;
    }else{
        NSDictionary *dict = [[ContactsStore sharedStore]allContacts][section];
        NSString *title = dict[@"firstLetter"];
        NSArray *array = dict[@"content"];
        if([array count] != 0){
            return title;
        }else{
            return nil;
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.searchController.active){
        return nil;
    }else{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in [[ContactsStore sharedStore]allContacts]) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchText = searchController.searchBar.text;
    searchText = [searchText uppercaseString];

    if(!self.searchResult){
        self.searchResult = [[NSMutableArray alloc]init];
    }
    if([self.searchResult count]){
        [self.searchResult removeAllObjects];
    }
    
    if([searchText isEqualToString:@""]){
        for(ContactItem *item in [[ContactsStore sharedStore] contactsArray] ){
            [self.searchResult addObject:item];
        }
        [self.tableView reloadData];
        return;
    }
    

    
    NSPredicate *preBegin= [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",searchText];
    for(ContactItem *item in [[ContactsStore sharedStore] contactsArray] ){
        // ldap、中文名、缩写、拼音匹配上都可以
        if([preBegin evaluateWithObject:item.name] || [preBegin evaluateWithObject:item.pinyin] || [preBegin evaluateWithObject:item.abbName] || [preBegin evaluateWithObject:item.ldap]){
            NSLog(@"Match %@",item.name);
            [self.searchResult addObject:item];
        }

    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchController.active = FALSE;
    [self.tableView reloadData];
}



@end
