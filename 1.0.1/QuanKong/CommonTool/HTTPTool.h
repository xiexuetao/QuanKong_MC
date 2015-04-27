//
//  HTTPTool.h
//  QuanKong
//
//  Created by 谢雪滔 on 14-9-30.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpSuccessBlock)(id success);
typedef void (^HttpFailBlock)(NSError *error);

//默认就是异步的:
@interface HTTPTool : NSObject

@property(nonatomic,assign)NSInteger i;

+ (void)getWithPath:(NSString *)path success:(HttpSuccessBlock)success fail:(HttpFailBlock)fail;

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)param success:(HttpSuccessBlock)success fail:(HttpFailBlock)fail;

@end
