//
//  QuanKongStore.m
//  QuanKong
//
//  Created by POWER on 12/11/14.
//  Copyright (c) 2014 Rockcent. All rights reserved.
//

#import "QuanKongStore.h"

@implementation QuanKongStore

+(QuanKongStore *)initWihtData:(NSDictionary *)dic
{
    
    QuanKongStore *storeModel = [[QuanKongStore alloc] init];
    [storeModel setValuesForKeysWithDictionary:dic];
    NSNumber *i = (NSNumber *)[dic objectForKey:@"id"];
    
    storeModel.storeId = i.integerValue;
    
    return storeModel;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"undefine:key=%@,value=%@",key,value);
}


@end
