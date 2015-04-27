//
//  BankInfoListController.h
//  QuanKong
//
//  Created by POWER on 1/14/15.
//  Copyright (c) 2015 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HTTPTool.h"
#import "UIWindow+AlertHud.h"
#import "UIImageView+WebCache.h"

@protocol bankInfoListDelegate <NSObject>

- (void)selectBankIdWithId:(NSString *)bankId AndImageUrl:(NSString *)url;

@end

@interface BankInfoListController : UITableViewController

@property (nonatomic, unsafe_unretained) id<bankInfoListDelegate> delegate;

@end
