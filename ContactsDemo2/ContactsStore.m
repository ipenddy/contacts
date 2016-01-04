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
//@property (nonatomic,strong) NSMutableArray *privateItems;
@property (nonatomic,strong) NSMutableDictionary *privateDictionary;
@property (nonatomic,strong) NSMutableArray *privateArray;
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
        item1.email = @"zhangsan@gmail.com";
        item1.phone = @"13800138000";
        item1.manager = @"river";
        item1.avatar = [UIImage imageNamed:@"wangpd.jpg"];
        item1.level = @"27";
        item1.popo = @"zhangsan@corp.netease.com";
        item1.qq = @"12121";
        item1.extNumber = @"89241";
        item1.isStared = NO;

        ContactItem *item2 = [[ContactItem alloc]init];
        item2.ldap = @"lisi";
        item2.name = @"李四";
        item2.email = @"lisi@gmail.com";
        item2.phone = @"13800138000";
        item2.manager = @"sky";
        item2.avatar = [UIImage imageNamed:@"tianzhen.jpg"];
        item2.level = @"26";
        item2.popo = @"lisi@corp.netease.com";
        item2.qq = @"12122";
        item2.extNumber = @"89242";
        item1.isStared = NO;

        if(!self.privateDictionary){
            self.privateDictionary = [[NSMutableDictionary alloc]init];
        }
        [self.privateDictionary setObject:item1 forKey:item1.ldap];
        [self.privateDictionary setObject:item2 forKey:item2.ldap];
    
//        if(!self.privateItems){
//            self.privateItems = [[NSMutableArray alloc]init];
//        }
//        [self.privateItems addObject:item1];
//        [self.privateItems addObject:item2];
//        NSLog(@"shareStore init,the array length is %d",[self.privateItems count]);
        if(!self.privateArray){
            self.privateArray = [[NSMutableArray alloc]init];
        }
        NSArray *keys = [self.privateDictionary allKeys];
        NSLog(@"the count of key is %d",[keys count]);
        for(NSString *key in keys){
            [self.privateArray addObject:self.privateDictionary[key]];
        }

    }
    return self;
}

- (NSArray *)allItems{

    return self.privateArray;
//    return self.privateItems;
}


@end
