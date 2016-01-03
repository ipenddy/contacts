//
//  ContactsStore.h
//  ContactsDemo2
//
//  Created by penddy on 16/1/2.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsStore : NSObject

+ (instancetype)sharedStore;

@property (nonatomic,strong) NSArray *allItems;


@end
