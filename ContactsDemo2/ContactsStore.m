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

        // 初始化收藏联系人的名单
        if(!self.staredUserDictionary){
            self.staredUserDictionary = [[NSMutableDictionary alloc]init];
        }
        
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        self.dataFile = [documentPath stringByAppendingPathComponent:@"conntacts.dat"];
        if([[NSFileManager defaultManager] fileExistsAtPath:self.dataFile]){
            self.staredUserDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:self.dataFile];
        }else{
            NSLog(@"file don't exist");
        }
        NSLog(@"the path is :%@",self.dataFile);
        NSArray *sourceArray = [self dataFromFile];
        NSLog(@"initial file is ok");
        
        // 初始化所有联系人的Array
        if(!self.allContactsArray){
            self.allContactsArray = [[NSMutableArray alloc]init];
        }
        // 初始化所有收藏联系人的Array
        if(!self.allStaredContactsArray){
            self.allStaredContactsArray = [[NSMutableArray alloc]init];
        }
        // 初始化将Contact转为grouped的Array
        if(!self.groupedContactsArray){
            self.groupedContactsArray = [[NSMutableArray alloc]init];
        }

        // 格式化grouped的Array
        
        [ContactsPinyin initPinYinArray:self.groupedContactsArray];
        // 获取全局的并发队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        // 添加任务到队列
        dispatch_async(queue, ^{

        [self dataFromFile];
            int i=0;
        for(NSString *line in sourceArray){

            NSArray *itemArray = [line componentsSeparatedByString:@","];
            ContactItem *item = [[ContactItem alloc]init];
            item.ldap = itemArray[0];
            item.phone = itemArray[1];
            item.manager = itemArray[2];
            item.email = itemArray[3];
            item.name = itemArray[4];
            item.pinyin = [ContactTools pinyinOfString:item.name];
            item.firstchar = [ContactTools firstCharactor:item.name];
            item.abbName = [ContactTools abbOfName:item.name];
            NSString *avatarName = [item.ldap stringByAppendingString:@".jpg"];
            item.avatar = [UIImage imageNamed:avatarName];
            item.level = itemArray[5];
            item.popo = itemArray[6];
            item.qq = itemArray[7];
            item.extNumber = itemArray[8];
            if(self.staredUserDictionary[item.ldap]){
                item.isStared = YES;
            }else{
                item.isStared = NO;
            }


            [self.allContactsArray addObject:item];
            if(item.isStared){
                [self.allStaredContactsArray addObject:item];
            }
            [ContactsPinyin addObject:item InPinyinArray:self.groupedContactsArray];
            i++;
            if((i % 20) == 0){
//                NSLog(@"refresh data!");
                // 必须在主线程更新UI
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.delegate refreshData];
                }); // 主线程更新UI完毕
                
                
            }
        }
//        self.groupedContactsArray = [ContactsPinyin arrayWithPinYinFirstLetterFormat:self.allContactsArray];
            
            
    
            NSLog(@"try refresh UI");
            if([self.delegate respondsToSelector:@selector(refreshData)]){
                // 必须在主线程更新UI
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.delegate refreshData];
                }); // 主线程更新UI完毕

            }

        NSLog(@"data load ok");

            
    }); // end of dispatch

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
    ContactItem * item = renewContact;
    item.isStared = renewContact.isStared;
    NSString *isStared = @"Stared";
    if(item.isStared){
        [self.allStaredContactsArray addObject:renewContact];
        [self.staredUserDictionary setObject:isStared forKey:item.ldap];
        
    }else{
        NSArray *array = [[NSArray alloc]initWithObjects:renewContact, nil];
        [self.allStaredContactsArray removeObjectsInArray:array];
        [self.staredUserDictionary removeObjectForKey:item.ldap];
    }
    [self.staredUserDictionary writeToFile:self.dataFile atomically:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (NSArray *)dataFromFile{
    NSArray *fileData;
    NSError *error;
    
    NSString *path = [[NSBundle mainBundle]bundlePath];
    NSString *file = [path stringByAppendingString:@"/address.txt"];

    fileData =[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error]componentsSeparatedByString:@"\n"];
    return fileData;
}

@end
