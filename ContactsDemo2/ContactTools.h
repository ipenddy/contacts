//
//  ContactTools.h
//  ContactsDemo2
//
//  Created by penddy on 16/1/2.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactTools : NSObject

+ (NSString *)firstCharactor:(NSString *)aString;
+ (NSString *)pinyinOfString:(NSString *)aString;
+ (NSString *)abbOfName:(NSString *)aString;
+ (void)roundImageView:(UIImageView *)imageView;
+ (UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
@end
