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
@property (nonatomic,strong) NSMutableArray *privateItems;
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
        item1.phone = @"18012345677";
        item1.manager = @"river";
        item1.avatar = [UIImage imageNamed:@"wangpd.jpg"];
        item1.level = @"27";
        item1.popo = @"zhangsan@corp.netease.com";
        item1.qq = @"12121";
        item1.extNumber = @"89241";

        ContactItem *item2 = [[ContactItem alloc]init];
        item2.ldap = @"lisi";
        item2.name = @"李四";
        item2.email = @"lisi@gmail.com";
        item2.phone = @"18012345678";
        item2.manager = @"sky";
        item2.avatar = [UIImage imageNamed:@"tianzhen.jpg"];
        item2.level = @"26";
        item2.popo = @"lisi@corp.netease.com";
        item2.qq = @"12122";
        item2.extNumber = @"89242";
        
        

        if(!self.privateItems){
            self.privateItems = [[NSMutableArray alloc]init];
        }
        [self.privateItems addObject:item1];
        [self.privateItems addObject:item2];
        NSLog(@"shareStore init,the array length is %d",[self.privateItems count]);
        
    }
    return self;
}

- (NSArray *)allItems{
    return self.privateItems;
}


@end
