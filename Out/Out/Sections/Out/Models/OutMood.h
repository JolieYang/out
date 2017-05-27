//
//  OutMood.h
//  Out
//
//  Created by Jolie on 2017/5/27.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <GYDataCenter/GYDataCenter.h>

@interface OutMood : GYModelObject

@property (nonatomic, assign) NSInteger moodId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) UIImage *backgroundImage;

@end