//
//  ContactItem.h
//  ContactsDemo2
//
//  Created by penddy on 16/1/2.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactItem : NSObject

@property (nonatomic,strong) NSString *ldap;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *manager;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) UIImage  *avatar;
@property (nonatomic,strong) NSString *level;
@property (nonatomic,strong) NSString *popo;
@property (nonatomic,strong) NSString *qq;
@property (nonatomic,strong) NSString *extNumber;

@end
