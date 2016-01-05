//
//  NSString+PinYin.h
//  TableViewIndexTest
//
//  Created by Shadow on 14-3-5.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactItem.h"
#import "ContactTools.h"


@interface ContactsPinyin :NSObject

+ (NSArray *)arrayWithPinYinFirstLetterFormat:(NSArray *)items;
@end
