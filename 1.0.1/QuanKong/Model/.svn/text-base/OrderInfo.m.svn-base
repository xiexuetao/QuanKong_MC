//
//  OrderInfo.m
//  QuanKong
//
//  Created by Rick on 14/11/14.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "OrderInfo.h"

@implementation OrderInfo

+(OrderInfo *)initWihtData:(NSDictionary *)dic{
    OrderInfo *orderInfo = [[OrderInfo alloc] init];
    [orderInfo setValuesForKeysWithDictionary:dic];
    NSString *i = [dic objectForKey:@"id"];
    orderInfo.Id = i;
    
    return orderInfo;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"undefine:key=%@,value=%@",key,value);
}
@end
