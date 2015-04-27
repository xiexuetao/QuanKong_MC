//
//  MBProgressHUD+Add.m
//  网络处理1-异步get请求
//
//  Created by Rick on 14-7-30.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"
@implementation MBProgressHUD (Add)

+(void)showError:(NSString *) error toView:(UIView *) view{
    //快速显示错误信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = error;
    //进度模式
    //        hud.mode = MBProgressHUDModeDeterminate;
    //        hud.progress = 0.5;
    
    //        //显示图片模式
    //        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button-load"]];
    //        hud.mode = MBProgressHUDModeCustomView;
    
    hud.removeFromSuperViewOnHide = YES;//如果在父控件中隐藏的时候移除
    
    //1秒以后，隐藏
    [hud hide:YES afterDelay:2.0];

}

+(MBProgressHUD *)showMessage:(NSString *) message toView:(UIView *)view dimBackground:(BOOL) bol{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;//如果在父控件中隐藏的时候移除
    
    //显示蒙版效果
    hud.dimBackground = bol;
    return hud;
}
@end
