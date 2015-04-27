//
//  QuanKongVerficationCode.m
//  QuanKong
//
//  Created by Rick on 14/12/10.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongVerficationCode.h"
#import "HTTPTool.h"
#import "UIWindow+AlertHud.h"

@implementation QuanKongVerficationCode


+(void)sendVerficationCodeWithUrl:(NSString *)url method:(NSString *)method phone:(NSString *) number appKey:(NSString *) key disableVerficationButton:(UIButton *) but messageShowView:(UIView *) view operation:(SuccessOperation) operation{
    
    url = [NSString stringWithFormat:@"%@method=%@&phoneNum=%@&appKey=%@",url,method,number,key] ;
    
    
    [HTTPTool getWithPath:url success:^(id success) {
        
        NSNumber *i = [success objectForKey:@"code"];
        operation(i.intValue);

    } fail:^(NSError *error) {
        if (view) {
            [view.window showHUDWithText:@"链接失败"  Enabled:YES];
        }
    }];

}


/**
 *  使获取验证码按钮失效15秒
 */
+(void)disableVerificationBtnFor15s:(UIButton *) but
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [but setUserInteractionEnabled:NO];
        });
        for (int i=0; i<60; i++) {
            [NSThread sleepForTimeInterval:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [but setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
                
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [but setTitle:@"获取验证码" forState:UIControlStateNormal];
            
            [but setUserInteractionEnabled:YES];
        });
        
        
        
    });
}

@end
