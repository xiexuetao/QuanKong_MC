//
//  SettingViewController.h
//  Kaiquan
//
//  Created by rockcent on 14-8-6.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property UITableView * mtableView;

@property NSArray * titleArray;
@property UIButton * exitBtn;
@end
