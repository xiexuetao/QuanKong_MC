//
//  QuanKongGroup.h
//  QuanKong
//
//  Created by 谢雪滔 on 14/10/27.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuanKongClass : NSObject
@property(nonatomic,assign)NSInteger groupId;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,copy)NSString *name1;

+(QuanKongClass *)initWihtData:(NSDictionary *)dic;
@end
