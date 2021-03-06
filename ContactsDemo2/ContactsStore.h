//
//  ContactsStore.h
//  ContactsDemo2
//
//  Created by penddy on 16/1/2.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactTools.h"
#import "ContactsPinyin.h"

@protocol RefreshDataDelegate <NSObject>

- (void)refreshData;

- (void)refreshSpotlight;
@end


@interface ContactsStore : NSObject

+ (instancetype)sharedStore;
- (NSArray *)allContacts;
- (NSArray *)staredContacts;
- (NSArray *)contactsArray;
- (void)renewStarContact:(ContactItem *)renewContact;

//@property (nonatomic,strong) NSMutableDictionary *allContactsDictionary;
@property (nonatomic,strong) NSMutableArray *allContactsArray;
@property (nonatomic,strong) NSMutableArray *allStaredContactsArray;
@property (nonatomic,strong) NSMutableArray *groupedContactsArray;
@property (weak, nonatomic) id <RefreshDataDelegate> delegate;
@property (nonatomic,strong) NSString *dataFile;
@property (nonatomic,strong) NSMutableDictionary *staredUserDictionary;



@end
