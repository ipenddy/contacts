//
//  ContactTools.m
//  ContactsDemo2
//
//  Created by penddy on 16/1/2.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import "ContactTools.h"

@implementation ContactTools

+ (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    NSLog(@"%@", str);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSLog(@"%@", str);
    //先传化为拼音
    NSString *pinYin = [str capitalizedString];
    //获取首字母
    return [pinYin substringToIndex:1];
}

+ (void)roundImageView:(UIImageView *)imageView{
    
    imageView.layer.borderWidth = 0;  //设置的UIImageView的边框宽度
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;   //设置边框颜色
    imageView.layer.cornerRadius = CGRectGetHeight(imageView.bounds) / 2;   //这里才是实现圆形的地方
    imageView.clipsToBounds = YES;    //这里设置超出部分自动剪裁掉
    return;
}

+(UIImage*)  OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;  
}



@end
