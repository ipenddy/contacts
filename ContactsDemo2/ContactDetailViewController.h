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

// 通过addSubView的方式增加toolbar，暂不用
//@property (nonatomic,strong) UIToolbar *bottomBar;

// Toolbar上的图标
@property (nonatomic,strong) UIImage *dialImage;
@property (nonatomic,strong) UIImage *staredImage;
@property (nonatomic,strong) UIImage *unStaredImage;
@property (nonatomic,strong) UIBarButtonItem *flexible;
@end
