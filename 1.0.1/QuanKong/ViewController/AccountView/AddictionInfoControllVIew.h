//
//  AddictionInfoControllVIew.h
//  Kaiquan
//
//  Created by rockcent on 14-8-6.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddictionInfoControllVIew : UIViewController<UITextFieldDelegate>
@property (strong,nonatomic)UIButton * verificaitonBtn;
@property (strong,nonatomic)UIButton * saveBtn;
@property (strong,nonatomic)UITextField * phonenumTF;
@property (strong,nonatomic)UITextField * verificaitonTF;
@property(nonatomic,assign)BOOL type;
@end
