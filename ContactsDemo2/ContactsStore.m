//
//  ContactsStore.m
//  ContactsDemo2
//
//  Created by penddy on 16/1/2.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import "ContactsStore.h"
#import "ContactItem.h"
@interface ContactsStore()
@end
@implementation ContactsStore

+ (instancetype)sharedStore{
    
    static ContactsStore * sharedStore = nil;
    // 判断是否需要创建一个sharedStore对象
    if(!sharedStore){
        sharedStore = [[self alloc]initPrivate];
    }
    return sharedStore;
}



- (instancetype)initPrivate{

    self= [super init];
    if(self){
        ContactItem *item1 = [[ContactItem alloc]init];
        item1.ldap = @"zhangsan";
        item1.name = @"张三";
        item1.pinyin =  [ContactTools pinyinOfString:item1.name];
        item1.firstchar = [ContactTools firstCharactor:item1.name];
        item1.email = @"zhangsan@gmail.com";
        item1.phone = @"13800138000";
        item1.manager = @"river";
        item1.avatar = [UIImage imageNamed:@"wangpd.jpg"];
        item1.level = @"27";
        item1.popo = @"zhangsan@corp.netease.com";
        item1.qq = @"12121";
        item1.extNumber = @"89241";
        item1.isStared = YES;
        item1.abbName = [ContactTools abbOfName:item1.name];

        ContactItem *item2 = [[ContactItem alloc]init];
        item2.ldap = @"lisi";
        item2.name = @"李四";
        item2.pinyin =  [ContactTools pinyinOfString:item2.name];
        item2.firstchar = [ContactTools firstCharactor:item2.name];
        item2.email = @"lisi@gmail.com";
        item2.phone = @"13800138000";
        item2.manager = @"sky";
        item2.avatar = [UIImage imageNamed:@"tianzhen.jpg"];
        item2.level = @"26";
        item2.popo = @"lisi@corp.netease.com";
        item2.qq = @"12122";
        item2.extNumber = @"89242";
        item2.isStared = NO;
        item2.abbName = [ContactTools abbOfName:item2.name];

        if(!self.allContactsDictionary){
            self.allContactsDictionary = [[NSMutableDictionary alloc]init];
        }
        [self.allContactsDictionary setObject:item1 forKey:item1.ldap];
        [self.allContactsDictionary setObject:item2 forKey:item2.ldap];
    
        if(!self.allContactsArray){
            self.allContactsArray = [[NSMutableArray alloc]init];
        }
        
        if(!self.allStaredContactsArray){
            self.allStaredContactsArray = [[NSMutableArray alloc]init];
        }
        NSArray *keys = [self.allContactsDictionary allKeys];
        for(NSString *key in keys){
            ContactItem *item = self.allContactsDictionary[key];
            [self.allContactsArray addObject:item];
            if(item.isStared){
                [self.allStaredContactsArray addObject:item];
            }
        }
        
        // 将Contact转为grouped的Array
        if(!self.groupedContactsArray){
            self.groupedContactsArray = [[NSMutableArray alloc]init];
        }

        self.groupedContactsArray = [ContactsPinyin arrayWithPinYinFirstLetterFormat:self.allContactsArray];
        


    }
    return self;
}

// 更新数组
//- (void)reloadArray{
//    if(!self.allContactsArray){
//        self.allContactsArray = [[NSMutableArray alloc]init];
//    }
//    
//    if(!self.allStaredContactsArray){
//        self.allStaredContactsArray = [[NSMutableArray alloc]init];
//    }
//    NSArray *keys = [self.allContactsDictionary allKeys];
//    for(NSString *key in keys){
//        ContactItem *item = self.allContactsDictionary[key];
//        [self.allContactsArray addObject:item];
//        if(item.isStared){
//            [self.allStaredContactsArray addObject:item];
//        }
//    }
//    
//    // 将Contact转为grouped的Array
//    if(!self.groupedContactsArray){
//        self.groupedContactsArray = [[NSMutableArray alloc]init];
//    }
//    
//    self.groupedContactsArray = [ContactsPinyin arrayWithPinYinFirstLetterFormat:self.allContactsArray];
//    
//
//}

- (void)renewStarContact:(ContactItem *)renewContact{
    ContactItem * item = self.allContactsDictionary[renewContact.ldap];
    item.isStared = renewContact.isStared;
    if(item.isStared){
        [self.allStaredContactsArray addObject:renewContact];
        
    }else{
        NSArray *array = [[NSArray alloc]initWithObjects:renewContact, nil];
        [self.allStaredContactsArray removeObjectsInArray:array];
    }
}

- (NSArray *)allContacts{
    return(self.groupedContactsArray);
}

- (NSArray *)contactsArray{
    return(self.allContactsArray);
}
- (NSArray *)staredContacts{
    return(self.allStaredContactsArray);
}

@end
