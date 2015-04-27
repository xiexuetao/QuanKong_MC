//
//  MBProgressHUD+Add.h
//  网络处理1-异步get请求
//
//  Created by Rick on 14-7-30.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+(void)showError:(NSString *) error toView:(UIView *) view;

+(MBProgressHUD *)showMessage:(NSString *) error toView:(UIView *) view dimBackground:(BOOL)bol;

@end
