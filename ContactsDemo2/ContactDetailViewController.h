//
//  ContactDetailViewController.h
//  ContactsDemo2
//
//  Created by penddy on 16/1/3.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactItem.h"

@interface ContactDetailViewController : UIViewController


@property (nonatomic,weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic,weak) IBOutlet UILabel *managerLabel;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *popoLabel;
@property (nonatomic,weak) IBOutlet UILabel *extNumberLabel;
//@property (nonatomic,weak) IBOutlet UILabel *levelLabel;
@property (nonatomic,weak) IBOutlet UILabel *qqLabel;
@property (nonatomic,weak) IBOutlet UIImageView *avatarImage;

@property (nonatomic,strong) ContactItem *item;

@end
