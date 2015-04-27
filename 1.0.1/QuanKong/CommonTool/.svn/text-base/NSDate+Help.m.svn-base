//
//  NSDate+Help.m
//  QuanKong
//
//  Created by Rick on 14/12/11.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "NSDate+Help.h"

@implementation NSDate (Help)

/**
 *  将毫秒值转化为时间字符串
 *
 *  @param totalSeconds 秒数
 *
 *  @return 时间字符串
 */
+ (NSString *)timeFormatted:(long long)totalSeconds model:(NSString *) model
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:model];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}


/**
 *  转换时间戳
 *
 *  @param timeStr
 *
 *  @return
 */
+ (NSString *)getTimeStrWithString:(NSString *)timeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr longLongValue]/1000];
    
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    
    if ([dateSMS isEqualToString:dateNow]) {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSLog(@"date = %@ , dataSMS = %@ , dateNow = %@",date,dateSMS,dateNow);
    
    dateSMS = [dateFormatter stringFromDate:date];
    
    return dateSMS;
}

@end
