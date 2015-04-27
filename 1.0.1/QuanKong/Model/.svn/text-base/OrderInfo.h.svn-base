//
//  OrderInfo.h
//  QuanKong
//
//  Created by Rick on 14/11/14.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject
//"awardRecord2Id": 0,
//"createTime": 1415932444000,
//"customerId": 44,
//"giftRecord2Id": 0,
//"id": 3088,
//"name": "quan券",
//"number": "141114103404851229",
//"state": 2,
//"total": 1,
//"tradeTime": 1415932468000

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *customerId;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *number;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *total;
@property(nonatomic,copy)NSString *tradeTime;
@property(nonatomic,retain)NSMutableArray *couponList;

@property(nonatomic,copy)NSString *isValid;
@property(nonatomic,copy)NSString *logoUrl;

+(OrderInfo *)initWihtData:(NSDictionary *)dic;
@end
