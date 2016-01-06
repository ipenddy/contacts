//
//  ContactDetailViewController.m
//  ContactsDemo2
//
//  Created by penddy on 16/1/3.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactTools.h"
#import "AvatarCell.h"
#import "OtherInfoCell.h"
#import "iToast.h"

@interface ContactDetailViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@end

@implementation ContactDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 通过addSubView的方式增加Toolbar，暂不用
//- (UIToolbar *)bottomBar{
//   
//    if(!_bottomBar){
//        CGRect frame = CGRectMake(0, self.tableView.frame.size.height-44,self.tableView.frame.size.width,44);
//        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:frame];
//        UIImage *dialImage = [UIImage imageNamed:(@"dial.png")];
//        CGSize iconSize = CGSizeMake(50.0, 50.0);
//        dialImage = [ContactTools OriginImage:dialImage scaleToSize:iconSize];
//        dialImage = [dialImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIBarButtonItem *dialItem = [[UIBarButtonItem alloc] initWithImage:dialImage style:UIBarButtonItemStylePlain target:self action:@selector(dialNumber:)];
//
//        UIImage *unStaredImage = [UIImage imageNamed:(@"unstared.png")];
//        unStaredImage = [ContactTools OriginImage:unStaredImage scaleToSize:iconSize];
//        unStaredImage = [unStaredImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//        UIImage *staredImage = [UIImage imageNamed:(@"stared.png")];
//        staredImage = [ContactTools OriginImage:staredImage scaleToSize:iconSize];
//        staredImage = [staredImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//        UIBarButtonItem *favItem;
//        if(self.item.isStared){
//            favItem = [[UIBarButtonItem alloc] initWithImage:staredImage style:UIBarButtonItemStyleDone target:self action:@selector(starContact)];
//        }else{
//            favItem = [[UIBarButtonItem alloc] initWithImage:unStaredImage style:UIBarButtonItemStyleDone target:self action:@selector(starContact)];
//        }
//        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//        NSArray *arrayItem = [NSArray arrayWithObjects:dialItem,flexible,favItem,nil];
//        [toolBar setItems:arrayItem];
//        _bottomBar = toolBar;
//    }
//    return _bottomBar;
//}
- (instancetype)init{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        UINib *avatarNib = [UINib nibWithNibName:@"AvatarCell" bundle:nil];
        [self.tableView registerNib:avatarNib forCellReuseIdentifier:@"avatar"];
        UINib *otherInfoNib = [UINib nibWithNibName:@"OtherInfoCell" bundle:nil];
        [self.tableView registerNib:otherInfoNib forCellReuseIdentifier:@"otherInfo"];

        // 不显示分割线
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        //不显示多余的空行
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

        // 隐藏tabBar
        self.hidesBottomBarWhenPushed = YES;

        // 初始化Toolbar的图标
        self.dialImage = [UIImage imageNamed:(@"dial.png")];
        self.dialImage = [self.dialImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.unStaredImage = [UIImage imageNamed:(@"unstared.png")];
        self.unStaredImage = [self.unStaredImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.staredImage = [UIImage imageNamed:(@"stared.png")];
        self.staredImage = [self.staredImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    }
    return self;

}
- (void)starContact{
    self.item.isStared = !self.item.isStared;
    [self renewToolbar];
    [[ContactsStore sharedStore] renewStarContact:self.item];
    if(self.item.isStared){
        [[[[iToast makeText:NSLocalizedString(@"  收藏成功！ ", @"")]
      setGravity:iToastGravityBottom] setDuration:iToastDurationShort] show];
    }else{
        [[[[iToast makeText:NSLocalizedString(@"  取消收藏成功! ", @"")]
          setGravity:iToastGravityBottom] setDuration:iToastDurationShort] show];
        
    }
}
- (void)dialNumber:(BOOL) isNow{
    if(isNow){
        NSString *dialURL = [NSString stringWithFormat:@"tel://%@",self.item.phone];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:dialURL]];
    }else{
    // 用tel不确认就拨出，使用telprompt确认后才拨出
        NSString *dialURL = [NSString stringWithFormat:@"telprompt://%@",self.item.phone];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:dialURL]];
    }
}

// 刷新toolbar，目前用于改变收藏图标
- (void)renewToolbar{
    
    UIBarButtonItem *dialItem = [[UIBarButtonItem alloc] initWithImage:self.dialImage style:UIBarButtonItemStylePlain target:self action:@selector(dialNumber:)];
    
    UIBarButtonItem *favItem;
    if(self.item.isStared){
        favItem = [[UIBarButtonItem alloc] initWithImage:self.staredImage style:UIBarButtonItemStyleDone target:self action:@selector(starContact)];
    }else{
        favItem = [[UIBarButtonItem alloc] initWithImage:self.unStaredImage style:UIBarButtonItemStyleDone target:self action:@selector(starContact)];
    }
    NSArray *arrayItem = [NSArray arrayWithObjects:dialItem,self.flexible,favItem,nil];
//    [self.navigationController.toolbar setItems:arrayItem];
    [self setToolbarItems:arrayItem];
    [self.navigationController.toolbar setNeedsLayout];
    return;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationItem.title = self.item.name;
    self.navigationController.toolbarHidden = NO;
    [self renewToolbar];
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    // 隐藏toolbar，避免返回后仍然显示
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    // 通过addSubView的方式增加toolbar
//    [self.view.superview addSubview:self.bottomBar];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactItem *item = self.item;

    switch (indexPath.row) {
        case 0:{
            AvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatar" forIndexPath:indexPath];
            cell.avatarImage.image = item.avatar;
            [ContactTools roundImageView:cell.avatarImage];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 1:{
            OtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherInfo" forIndexPath:indexPath];
            cell.itemName.text = @"手机：";
            cell.itemValue.text = item.phone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }
            
        case 2:{
            OtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherInfo" forIndexPath:indexPath];
            cell.itemName.text = @"popo：";
            cell.itemValue.text = item.popo;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
            
        }
        case 3:{
            OtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherInfo" forIndexPath:indexPath];
            cell.itemName.text = @"邮箱：";
            cell.itemValue.text = item.email;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }
        case 4:{
            OtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherInfo" forIndexPath:indexPath];
            cell.itemName.text = @"qq：";
            cell.itemValue.text = item.qq;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }
        case 5:{
            OtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherInfo" forIndexPath:indexPath];
            cell.itemName.text = @"分机：";
            cell.itemValue.text = item.extNumber;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        case 6:{
            OtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherInfo" forIndexPath:indexPath];
            cell.itemName.text = @"直接主管：";
            cell.itemValue.text = item.manager;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;            
            return cell;
            
        }
        default:
            break;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // 避免一直保持在选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 1:{
            NSString *dialString = [NSString stringWithFormat:@"拔打：%@",self.item.phone];
            self.phoneActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:dialString,@"复制电话号码",nil];
            self.phoneActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [self.phoneActionSheet showInView:self.view];
            return;
        }
//            popo
        case 2:{
            self.popoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制popo账号",nil];
            self.popoActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [self.popoActionSheet showInView:self.view];
            
            return;
        }
//            email
        case 3:{
            NSString *emailString = [NSString stringWithFormat:@"发邮件：%@",self.item.email];
            self.emailActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:emailString,@"复制邮箱地址",nil];
            self.emailActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [self.emailActionSheet showInView:self.view];
            return ;
        }
//            qq
        case 4:{
            self.qqActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制qq号码",nil];
            self.qqActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [self.qqActionSheet showInView:self.view];
            
            return;
            
        }
        default:
            break;
    }
    return;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([actionSheet isEqual:self.phoneActionSheet]){
        if (buttonIndex == 0) {
            [self dialNumber:YES];
        }else if (buttonIndex == 1) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.item.phone;

        }
    }else if([actionSheet isEqual:self.popoActionSheet]){
        if (buttonIndex == 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.item.popo;
        }
    }else if([actionSheet isEqual:self.emailActionSheet]){
        if (buttonIndex == 0) {
            [self launchMailApp:self.item.email];
        }else if (buttonIndex == 1) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.item.email;
            
        }
    }else if([actionSheet isEqual:self.qqActionSheet]){
        if (buttonIndex == 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.item.qq;
        }
        
    }
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    // This will create a "invisible" footer
    return 0.01f;
}


#pragma mark - 使用系统邮件客户端发送邮件
-(void)launchMailApp:(NSString *)email{
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    [mailUrl appendFormat:@"mailto:%@",email];
    NSString* mail = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:mail]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
