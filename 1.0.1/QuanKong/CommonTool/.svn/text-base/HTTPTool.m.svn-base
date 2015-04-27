//
//  HTTPTool.m
//  QuanKong
//
//  Created by 谢雪滔 on 14-9-30.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "HTTPTool.h"
#import "AFHTTPRequestOperation.h"
@implementation HTTPTool


+ (void)getWithPath:(NSString *)path success:(HttpSuccessBlock)success fail:(HttpFailBlock)fail{
    
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *userInfoRequest = [NSMutableURLRequest requestWithURL:url];
    userInfoRequest.timeoutInterval = 10;
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:userInfoRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
    
    [operation start];
}

+(void)postWithPath:(NSString *)path params:(NSDictionary *)param success:(HttpSuccessBlock)success fail:(HttpFailBlock)fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
 
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;

//    [manager.requestSerializer setValue:@"*/*"forHTTPHeaderField:@"Accept"];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    //    NSDictionary *parameters =@{@"参数1":@"value1",@"参数2":@"value2"};
    
    [manager POST:path parameters:param
         success:^(AFHTTPRequestOperation *operation,id responseObject) {
             NSLog(@"Success: %@", responseObject);
             success(responseObject);
         }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
             NSLog(@"Error: %@", error);
             fail(error);
         }];
}

@end
