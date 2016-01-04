//
//  ContactDetailViewController.h
//  ContactsDemo2
//
//  Created by penddy on 16/1/3.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactItem.h"

@interface ContactDetailViewController : UITableViewController

@property (nonatomic,strong) ContactItem *item;

@property (nonatomic,strong) UIActionSheet *phoneActionSheet;
@property (nonatomic,strong) UIActionSheet *popoActionSheet;
@property (nonatomic,strong) UIActionSheet *emailActionSheet;
@property (nonatomic,strong) UIActionSheet *qqActionSheet;

@end
