//
//  PasswrodMangerViewController.h
//  Kaiquan
//
//  Created by rockcent on 14-8-18.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@interface PasswrodMangerViewController : UIViewController
@property UITextField* originalTF;
@property UITextField* theNewPasswordTF;
@property UITextField * confirmPasswordTF;
@property UITextField *loginPsw;

@property UIButton * okBtn;
@property NSInteger passwordType;
-(id)initWithPasswrodType:(NSInteger)type;
@end
