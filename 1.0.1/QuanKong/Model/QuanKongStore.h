//
//  QuanKongStore.h
//  QuanKong
//
//  Created by POWER on 12/11/14.
//  Copyright (c) 2014 Rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuanKongStore : NSObject

@property (nonatomic,assign) NSInteger storeId;
@property (nonatomic,assign) NSInteger businessid;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *contactName;
@property (nonatomic,copy) NSString *contactPosition;
@property (nonatomic,copy) NSString *telephone;
@property (nonatomic,assign) NSInteger baiduMapId;
@property (nonatomic,assign) NSInteger relatedCoupon;
@property (nonatomic,assign) NSInteger distance;
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lng;

//@property (nonatomic,copy) NSString *qrCodeUrl;

+(QuanKongStore *)initWihtData:(NSDictionary *)dic;

@end
