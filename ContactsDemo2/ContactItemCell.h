//
//  ContactItemCell.h
//  ContactsDemo2
//
//  Created by penddy on 16/1/2.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactItemCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *ldapLabel;
@property (nonatomic,weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic,weak) IBOutlet UILabel *managerLabel;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UIImageView *avatarImage;
@end
