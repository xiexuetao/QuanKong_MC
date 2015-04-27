//
//  QuanKongVoucher.m
//  QuanKong
//
//  Created by 谢雪滔 on 14/10/20.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongVoucher.h"

@implementation QuanKongVoucher

+(QuanKongVoucher *)initWihtData:(NSDictionary *)dic{
    
    QuanKongVoucher *voucher = [[QuanKongVoucher alloc] init];
    [voucher setValuesForKeysWithDictionary:dic];
    NSNumber *i = (NSNumber *)[dic objectForKey:@"id"];
    NSString *useTime = [dic objectForKey:@"useTime"];

    voucher.vocherId = i.integerValue;
    
    voucher.useTime = useTime;
    
    return voucher;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"undefine:key=%@,value=%@",key,value);
}

@end
