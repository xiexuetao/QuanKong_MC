//
//  QuanKongGroup.m
//  QuanKong
//
//  Created by 谢雪滔 on 14/10/27.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongClass.h"

@implementation QuanKongClass


+(QuanKongClass *)initWihtData:(NSDictionary *)dic{
    QuanKongClass *class = [[QuanKongClass alloc] init];
    [class setValuesForKeysWithDictionary:dic];
    NSNumber *i = (NSNumber *)[dic objectForKey:@"id"];
    class.Id = i.integerValue;
    return class;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    MyLog(@"undefine:key=%@,value=%@",key,value);
}
@end
