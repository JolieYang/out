//
//  DateHelper.h
//  Out
//
//  Created by Jolie_Yang on 16/9/7.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject
+ (NSString *)customeDateStr:(NSString *)timeStr;

+ (NSString *)chineseWithArabString:(NSString *)arabStr;
+ (NSString *)chineseFromArab:(NSString *)arabStr; // 根据系统语言
@end