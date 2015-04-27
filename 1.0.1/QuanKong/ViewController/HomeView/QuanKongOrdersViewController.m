//
//  QuanKongOrdersViewController.m
//  QuanKong
//
//  Created by POWER on 14-10-8.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongOrdersViewController.h"

#import "QuanKongPayViewController.h"
#import "QuanKongCouponDetailViewController.h"
#import "AddictionInfoControllVIew.h"
#import "UITableView+Help.h"

@interface QuanKongOrdersViewController ()

@end

@implementation QuanKongOrdersViewController{

    NSMutableArray *couponIdArray;
    NSMutableArray *couponTypeArray;
    NSMutableArray *couponNameArray;
    NSMutableArray *couponLogoUrlArray;
    NSMutableArray *couponPicUrlArray;
    NSMutableArray *couponEstimateAmountArray;
    NSMutableArray *couponCountArray;
    NSMutableArray *couponCanBuyCountArray;
    NSMutableArray *couponRemainCountArray;
    NSMutableArray *couponStateArray;
    
    NSMutableArray *couponListArray;
    
    QuanKongVoucher *couponListModel;
    
    UIButton *allSelectButton;
    
    NSMutableArray *orderCountArray;
        NSMutableArray *orderIdArray;
    NSMutableArray *orderTagArray;
    
    BOOL isEditor;
    BOOL allSelect;
    
    float totalCount;
    int selectCount;
    
    NSString *warnningStr;
    
}

@synthesize ordersTableView;
@synthesize payButton;
@synthesize totalLabel;
@synthesize orderOperation;
@synthesize bottomView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        
        //根据iOS版本判断界面起始位置
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        #endif
        
        //UINavigationItem标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.text = @"购物车";
        
        self.navigationItem.titleView = titleLabel;
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
        UIButton *editorButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 22)];
        [editorButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editorButton setTitle:@"完成" forState:UIControlStateSelected];
        [editorButton addTarget:self action:@selector(editorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *editorItemButton = [[UIBarButtonItem alloc]initWithCustomView:editorButton];
        
        [self.navigationItem setRightBarButtonItem:editorItemButton];
        
    }
    
    return self;
}

/**
 *  购物车刷新操作
 *
 *  @param animated nil
 */
- (void)viewWillAppear:(BOOL)animated
{
    warnningStr = @"";
    
    orderOperation = [[OrderOperation alloc]init];
    
    [self initOrdersDetail];
}

/**
 *  获取购物车数据
 */
- (void)initOrdersDetail
{
    [LoadingHUDView showLoadinginView:self.view];
    
    allSelect = YES;
    
    NSString *cartDetailUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&appKey=%@",NEW_HEAD_LINK,LIST_MY_CART,[UserInfo shareUserInfo].userName,APP_KEY];
    
    [HTTPTool getWithPath:cartDetailUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        totalCount = 0.00;
        selectCount = 0;
        
        if ([msg isEqualToString:@"success"]) {
            
            couponIdArray = [[NSMutableArray alloc]initWithCapacity:0];
            couponTypeArray = [[NSMutableArray alloc]initWithCapacity:0];
            couponNameArray = [[NSMutableArray alloc]initWithCapacity:0];
            couponLogoUrlArray = [[NSMutableArray alloc]initWithCapacity:0];
            couponPicUrlArray = [[NSMutableArray alloc]initWithCapacity:0];
            couponEstimateAmountArray = [[NSMutableArray alloc]initWithCapacity:0];
            couponCountArray = [[NSMutableArray alloc]initWithCapacity:0];
            couponCanBuyCountArray = [[NSMutableArray alloc]initWithCapacity:0];
            couponStateArray = [[NSMutableArray alloc]initWithCapacity:0];
            couponRemainCountArray = [[NSMutableArray alloc]initWithCapacity:0];
            orderIdArray = [[NSMutableArray alloc]initWithCapacity:0];
            orderCountArray = [[NSMutableArray alloc]initWithCapacity:0];
            orderTagArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            NSMutableArray *objList = [success objectForKey:@"objList"];
            
            if (objList.count > 0) {
                
                for (int i = 0; i < objList.count; i++) {
                    
                    NSString *couponId = [[objList objectAtIndex:i]objectForKey:@"id"];
                    NSString *couponType = [[objList objectAtIndex:i]objectForKey:@"type"];
                    NSString *couponName = [[objList objectAtIndex:i]objectForKey:@"name"];
                    NSString *couponLogoUrl = [NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[[objList objectAtIndex:i]objectForKey:@"logoUrl"]];
                    NSString *couponPicUrl = [[objList objectAtIndex:i]objectForKey:@"picUrl"];
                    NSString *couponEstimateAmount = [[objList objectAtIndex:i]objectForKey:@"estimateAmount"];
                    NSString *couponCount = [[objList objectAtIndex:i]objectForKey:@"count"];
                    NSString *couponCanBuyCount = [[objList objectAtIndex:i]objectForKey:@"canBuyCount"];
                    NSString *couponSaleCount = [[objList objectAtIndex:i]objectForKey:@"saleCount"];
                    NSString *couponIssueCount = [[objList objectAtIndex:i]objectForKey:@"issueCount"];
                    NSString *couponBizState = [[objList objectAtIndex:i]objectForKey:@"bizState"];
                    
                    NSString *couponRemainCount = [NSString stringWithFormat:@"%d",[couponIssueCount intValue] - [couponSaleCount intValue]];
                    
                    [couponIdArray addObject:couponId];
                    [couponTypeArray addObject:couponType];
                    [couponNameArray addObject:couponName];
                    [couponLogoUrlArray addObject:couponLogoUrl];
                    [couponPicUrlArray addObject:couponPicUrl];
                    [couponEstimateAmountArray addObject:couponEstimateAmount];
                    [couponCountArray addObject:couponCount];
                    [couponCanBuyCountArray addObject:couponCanBuyCount];
                    [couponRemainCountArray addObject:couponRemainCount];
                    [couponStateArray addObject:couponBizState];
                    
                    [orderIdArray addObject:couponId];
                    [orderCountArray addObject:couponCount];
                    [orderTagArray addObject:@"0"];
                    
                }
                
                totalCount = [orderOperation getTotalWithTagArray:orderTagArray AndCountArray:couponCountArray andEstimateAmountArray:couponEstimateAmountArray];
                
                selectCount = [orderOperation getCountWithTagArray:orderTagArray];
                
                if (isEditor == YES) {
                    
                    [ordersTableView reloadData];
                    
                } else {
                    
                    [self initCartTableView];
                    
                    [self.view setNeedsLayout];
                    
                    [payButton setTitle:[NSString stringWithFormat:@"结算(%d)",selectCount] forState:UIControlStateNormal];
                    payButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:49.0/255.0 alpha:1.0];
                    
                    totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",totalCount];
                    
                }
                
            }   else {
                
                [self initEmptyeView];
                
                self.navigationItem.rightBarButtonItem = nil;
                
                totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",totalCount];
                
            }
            
            [LoadingHUDView hideLoadingView];
            
        }
        
    } fail:^(NSError *error) {
        
         NSLog(@"fail");
        
    }];
    
}

/**
 *  删除购物车里券的操作
 *
 *  @param couponStrArray 需要删除的券的数组
 */
- (void)deleteCouponFormCart:(NSArray *)couponStrArray
{
    //选择的券大于0
    if (selectCount > 0) {
        
        //拼接所删除券的字符串
        NSString *modelIdsStr = @"";
        
        for (int i = 0; i < couponStrArray.count; i++) {
            
            NSString *modelIdStr = [NSString stringWithFormat:@"%@,",[couponStrArray objectAtIndex:i]];
            
            if (i == couponIdArray.count - 1) {
                
                modelIdStr = [NSString stringWithFormat:@"%@",[couponStrArray objectAtIndex:i]];
                
            }
            
            modelIdsStr = [modelIdsStr stringByAppendingString:modelIdStr];
        }
        
        
        NSString *cartDeleteUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&couponModelIds=%@&appKey=%@",NEW_HEAD_LINK,DELETE_IN_MY_CART,[UserInfo shareUserInfo].userName,modelIdsStr,APP_KEY];
        
        [HTTPTool getWithPath:cartDeleteUrlStr success:^(id success) {
            
            NSString *msg = [success objectForKey:@"msg"];
            
            if ([msg isEqualToString:@"success"]) {
                
                [self.view.window showHUDWithText:[NSString stringWithFormat:@"购物车删除成功"] Enabled:YES];
                
                //2秒后从新刷新页面
                [self performSelector:@selector(initOrdersDetail) withObject:nil afterDelay:2.0];
                
            } else {
                
                //留空
                
                [self.view.window showHUDWithText:[NSString stringWithFormat:@"删除失败:%@",msg] Enabled:YES];
            }
            
        } fail:^(NSError *error) {
            
             NSLog(@"Fail");
            
        }];
    }
}

/**
 *  创建购物车列表
 */
- (void)initCartTableView
{
    if (!ordersTableView) {
        
        ordersTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        ordersTableView.delegate = self;
        ordersTableView.dataSource = self;
        ordersTableView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        ordersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        ordersTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        
        [UITableView setExtraCellLineHidden:ordersTableView];
        
    }
    
    [ordersTableView reloadData];
    
    [self.view insertSubview:ordersTableView atIndex:1];
    
}

/**
 *  创建购物车空提示语
 */
- (void)initEmptyeView
{
    
    if (ordersTableView) {
        
        [ordersTableView removeFromSuperview];
    }
    
    UIImageView *cartView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-36, HEIGHT/2-64-55-15, 72, 55)];
    cartView.image = [UIImage imageNamed:@"empty_cart_icon"];
    
    UILabel *emtype = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT/2-64-5, WIDTH, 20)];
    emtype.backgroundColor = [UIColor clearColor];
    emtype.font = [UIFont systemFontOfSize:15.0f];
    emtype.textAlignment = NSTextAlignmentCenter;
    emtype.numberOfLines = 0;
    emtype.textColor = [UIColor lightGrayColor];
    emtype.text = @"购物车还是空的, 快快挑选喜欢的券吧!";
    
    [self.view insertSubview:cartView atIndex:1];
    [self.view insertSubview:emtype atIndex:1];
}

/**
 *  创建低栏
 */
- (void)initBottomView
{
    if (!bottomView) {
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64-45, WIDTH, 45)];
        bottomView.backgroundColor = [UIColor blackColor];
        bottomView.alpha = 0.9;
    }

    if (!allSelectButton) {
        
        allSelectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 45)];
        [allSelectButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_enable_all"] forState:UIControlStateNormal];
        [allSelectButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_disable_all"] forState:UIControlStateSelected];
        allSelectButton.selected = allSelect;
        [allSelectButton addTarget:self action:@selector(allSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    allSelectButton.selected = allSelect;

    if (!totalLabel) {
        
        totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12.5, WIDTH-150, 20)];
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.textAlignment = NSTextAlignmentLeft;
        totalLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        totalLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
        totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",totalCount];
    }
    
    if (!payButton) {
        
        payButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-97.5, 7.5, 90, 30)];
        payButton.layer.cornerRadius = 5.0;
        payButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:49.0/255.0 alpha:1.0];
        [payButton setTitle:[NSString stringWithFormat:@"结算(%d)",selectCount] forState:UIControlStateNormal];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [payButton addTarget:self action:@selector(createOrderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [bottomView addSubview:allSelectButton];
    [bottomView addSubview:totalLabel];
    [bottomView addSubview:payButton];
    
    [self.view insertSubview:bottomView aboveSubview:ordersTableView];
}

#pragma mark - tableView delegate

//方法类型：系统方法
//编   写：peter
//方法功能：返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//方法类型：系统方法
//编   写：peter
//方法功能：返回tableViewCell 的个数 = 问题的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [couponIdArray count];
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableVlewCell 的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
    } else {
        
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 15, 74, 65)];
    
    NSArray *picArray = [[couponPicUrlArray objectAtIndex:indexPath.row] componentsSeparatedByString:@";"];
    
    //券的的图片
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,[picArray objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:nil];
    
    //券的名称
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 10, WIDTH-185, 35)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = [couponNameArray objectAtIndex:indexPath.row];
    
    UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-120, 10, 110, 20)];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont systemFontOfSize:14.0f];
    valueLabel.textColor = [UIColor darkGrayColor];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.text = [NSString stringWithFormat:@"¥%.2f",[[couponEstimateAmountArray objectAtIndex:indexPath.row]floatValue]];
    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 60, 140, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont systemFontOfSize:14.0f];
    countLabel.textColor = [UIColor grayColor];
    countLabel.textAlignment = NSTextAlignmentLeft;
    countLabel.text = [NSString stringWithFormat:@"数量：%@",[couponCountArray objectAtIndex:indexPath.row]];
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-70, 95, 60, 25)];
    stateLabel.backgroundColor = [UIColor clearColor];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    stateLabel.text = warnningStr;
    
    UILabel *subTotalLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 95, WIDTH-50, 30)];
    subTotalLabel.backgroundColor = [UIColor clearColor];
    subTotalLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    subTotalLabel.textColor = [UIColor orangeColor];
    subTotalLabel.textAlignment = NSTextAlignmentLeft;
    subTotalLabel.text = [NSString stringWithFormat:@"小计：¥%.2f",[[couponEstimateAmountArray objectAtIndex:indexPath.row]floatValue] * [[couponCountArray objectAtIndex:indexPath.row] intValue]];
    
    if ([[couponRemainCountArray objectAtIndex:indexPath.row] intValue] == 0) {
        
        stateLabel.layer.cornerRadius = 4.0f;
        stateLabel.layer.borderWidth = 1.0f;
        stateLabel.layer.borderColor = [UIColor redColor].CGColor;
        
        stateLabel.textColor = [UIColor redColor];
        stateLabel.text = @"已售完";
        
    } else if ([[couponStateArray objectAtIndex:indexPath.row] intValue] == 0) {
        
        stateLabel.layer.cornerRadius = 4.0f;
        stateLabel.layer.borderWidth = 1.0f;
        stateLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        stateLabel.textColor = [UIColor lightGrayColor];
        stateLabel.text = @"已下架";
    }
    
    CountSelector *countSelector = [[CountSelector alloc]initWithFrame:CGRectMake(135, 52, 90, 30)];
    [countSelector initViewWithCount:[[couponCountArray objectAtIndex:indexPath.row] intValue] And:[[couponCanBuyCountArray objectAtIndex:indexPath.row] intValue] AndTag:indexPath.row];
    
    countSelector.delegate = self;
    
    if (isEditor == NO) {
        
        countLabel.hidden = NO;
        countSelector.hidden = YES;
        
    } else {
        
        countLabel.hidden = YES;
        countSelector.hidden = NO;
    }
    
    UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 40, 85)];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_enable"] forState:UIControlStateNormal];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_disable"] forState:UIControlStateSelected];
    [selectButton setTag:indexPath.row+100];
    
    [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[orderTagArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        
        selectButton.selected = NO;
        
    } else {
        
        selectButton.selected = YES;
    }
    
    if (indexPath.row != couponIdArray.count-1) {
        
        UIView *separatorView = [[UIView alloc]initWithFrame:CGRectMake(40, 129.5, WIDTH-40, 0.5)];
        separatorView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
        
        [cell.contentView addSubview:separatorView];
        
    }
    
    [cell.contentView addSubview:logoImageView];
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:valueLabel];
    [cell.contentView addSubview:countLabel];
    [cell.contentView addSubview:countSelector];
    [cell.contentView addSubview:selectButton];
    [cell.contentView addSubview:stateLabel];
    [cell.contentView addSubview:subTotalLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuanKongCouponDetailViewController *detailViewCOntroller = [[QuanKongCouponDetailViewController alloc]init];
    
//    [detailViewCOntroller getCouponDetailWithCouponID:[couponIdArray objectAtIndex:indexPath.row]And:@"223"];
    
//    [self.navigationController pushViewController:detailViewCOntroller animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@&businessAccount=%@&appKey=%@",NEW_HEAD_LINK,BUSINESS_CHANNEL_METHOD,BUSINESS,APP_KEY];
    [HTTPTool getWithPath:url success:^(id success) {
        NSString * i = [success objectForKey:@"event"];
        NSArray *arr = [success objectForKey:@"objList"];
        NSDictionary *business =  arr[0];
        NSString *ID = [business objectForKey:@"id"];
        if ([i isEqualToString:@"0"]) {
            [detailViewCOntroller getCouponDetailWithCouponID:[NSString stringWithFormat:@"%@",[couponIdArray objectAtIndex:indexPath.row]] And:ID];
            [self.navigationController pushViewController:detailViewCOntroller animated:YES];
        }else{
            [self.view.window showHUDWithText:[success objectForKey:@"msg"]  Enabled:YES];
        }
    } fail:^(NSError *error) {
        [self.view.window showHUDWithText:@"网络连接失败"  Enabled:YES];
    }];
}

#pragma mark - button selector

/**
 *  编辑按钮
 *
 *  @param sender 编辑按钮操作
 */
- (void)editorButtonClick:(UIButton *)sender
{
    if (!isEditor) {
        
        sender.selected = YES;
        isEditor = YES;
        
        payButton.backgroundColor = [UIColor grayColor];
        [payButton setTitle:@"删除" forState:UIControlStateNormal];
        
        totalLabel.text = [NSString stringWithFormat:@"全选"];
        
        [ordersTableView reloadData];
        
        
    } else {
        
        sender.selected = NO;
        isEditor = NO;
        
        payButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:49.0/255.0 alpha:1.0];
        [payButton setTitle:[NSString stringWithFormat:@"结算(%d)",selectCount] forState:UIControlStateNormal];
        
        totalCount = [orderOperation getTotalWithTagArray:orderTagArray AndCountArray:couponCountArray andEstimateAmountArray:couponEstimateAmountArray];
        
        totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",totalCount];
        
        [ordersTableView reloadData];
        
    }
}

/**
 *  购物车分项选择按钮
 *
 *  @param sender 购物车选择按钮操作
 */
- (void)selectButtonClick:(UIButton *)sender
{
    NSUInteger row = sender.tag;
    
    void(^changeCartTag)(BOOL Tag, NSString *tagValue) = ^(BOOL Tag, NSString *tagValue)
    {
        sender.selected = !Tag;
        
        [orderTagArray replaceObjectAtIndex:row-100 withObject:tagValue];
    };
    
    !sender.selected?changeCartTag(NO,@"0"):changeCartTag(YES,@"1");
    
    selectCount = [orderOperation setCountWithOrderArray:orderTagArray AndRow:row-100 AndSelectCount:selectCount];
    
    selectCount==couponIdArray.count?[allSelectButton setSelected:NO]:[allSelectButton setSelected:YES];
    selectCount==couponIdArray.count?(allSelect = YES):(allSelect = NO);
    
    if (isEditor == NO) {
        
        [payButton setTitle:[NSString stringWithFormat:@"结算(%d)",selectCount] forState:UIControlStateNormal];
        
        totalCount = [orderOperation setTotalWtihOrderArray:orderTagArray AndRow:row-100 AndTotalCount:totalCount AndCountArray:couponCountArray andEstimateAmountArray:couponEstimateAmountArray];
        
        totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",totalCount];
        
    } else {
        
        totalLabel.text = [NSString stringWithFormat:@"全选"];
    }
    
}

/**
 *  全选按钮
 *
 *  @param sender 全选按钮操作
 */
- (void)allSelectButtonClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        
        sender.selected = YES;
        
        allSelect = NO;
        
        for (int i = 0; i < [couponIdArray count]; i++) {
            
            [orderTagArray replaceObjectAtIndex:i withObject:@"0"];
        }
        
        [ordersTableView reloadData];
        
        selectCount = 0;
        
        if (!isEditor) {
            
            [payButton setTitle:[NSString stringWithFormat:@"结算(%d)",selectCount] forState:UIControlStateNormal];
            
            totalCount = 0.0f;
            totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",totalCount];
            
        } else {
            
            totalLabel.text = [NSString stringWithFormat:@"全选"];
        }
        
        
    } else {
        
        sender.selected = NO;
        
        allSelect = YES;
        
        for (int i = 0; i < [couponIdArray count]; i++) {
            
            [orderTagArray replaceObjectAtIndex:i withObject:@"1"];
        }
        
        [ordersTableView reloadData];
        
        selectCount = couponIdArray.count;
        
        if (!isEditor) {
            
            [payButton setTitle:[NSString stringWithFormat:@"结算(%d)",selectCount] forState:UIControlStateNormal];
            
            totalCount = [orderOperation getTotalWithTagArray:orderTagArray AndCountArray:couponCountArray andEstimateAmountArray:couponEstimateAmountArray];
            
            totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",totalCount];
            
        } else {
            
            totalLabel.text = [NSString stringWithFormat:@"全选"];
        }
    }
}

/**
 *  结算按钮
 *
 *  @param sender 结算按钮操作
 */
- (void)createOrderButtonClick:(UIButton *)sender
{
    if (isEditor == NO) {
        
        if ([UserInfo shareUserInfo].phone == NULL) {
            
            [self.navigationController pushViewController:[[AddictionInfoControllVIew alloc]init] animated:YES];
            
        } else {
            
            NSMutableArray *order_Dic_Array = [[NSMutableArray alloc]initWithCapacity:0];
            
            for (int i = 0 ; i < [orderIdArray count]; i++) {
                
                NSMutableDictionary *order_Dic = [[NSMutableDictionary alloc]initWithCapacity:2];
                
                if ([[orderTagArray objectAtIndex:i] isEqualToString:@"1"]) {
                    
                    [order_Dic setValue:[NSString stringWithFormat:@"%@",[couponCountArray objectAtIndex:i]] forKey:@"count"];
                    [order_Dic setValue:[NSString stringWithFormat:@"%@",[couponIdArray objectAtIndex:i]] forKey:@"modelId"];
                    
                    [order_Dic_Array addObject:order_Dic];
                }
            }
            
            SBJsonWriter *writer = [[SBJsonWriter alloc]init];
            
            NSString *orderJsonStr = [writer stringWithObject:order_Dic_Array];
            
            NSString *url = [NSString stringWithFormat:@"%@%@&businessAccount=%@&appKey=%@",NEW_HEAD_LINK,BUSINESS_CHANNEL_METHOD,BUSINESS,APP_KEY];
            [HTTPTool getWithPath:url success:^(id success) {
                NSString * i = [success objectForKey:@"event"];
                NSArray *arr = [success objectForKey:@"objList"];
                NSDictionary *business =  arr[0];
                NSString *ID = [business objectForKey:@"id"];
                if ([i isEqualToString:@"0"]) {
                    NSString *creatOrderUrlStr = [[NSString stringWithFormat:@"%@%@&loginName=%@&cartListJson=%@&appKey=%@&channelId=%@",NEW_HEAD_LINK,CREATE_ORDER,[UserInfo shareUserInfo].userName,orderJsonStr,APP_KEY,ID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [HTTPTool getWithPath:creatOrderUrlStr success:^(id success) {
                        
                        NSString *msg = [success objectForKey:@"msg"];
                        
                        NSString *orderNumber = [[success objectForKey:@"obj"]objectForKey:@"number"];
                        
                        if ([msg isEqualToString:@"success"]) {
                            
                            QuanKongPayViewController *payViewController = [[QuanKongPayViewController alloc]init];
                            
                            [payViewController getOrderDetailWith:orderNumber];
                            
                            [self.navigationController pushViewController:payViewController animated:YES];
                            
                        } else {
                            
                            [self.view.window showHUDWithText:@"部分券已下架或已售完，请重新创建订单" Enabled:YES];
                        }
                        
                    } fail:^(NSError *error) {
                        
                        NSLog(@"Fail");
                    }];
                }else{
                    [self.view.window showHUDWithText:[success objectForKey:@"msg"]  Enabled:YES];
                }
            } fail:^(NSError *error) {
                [self.view.window showHUDWithText:@"网络连接失败"  Enabled:YES];
            }];
        }
        
    } else {
        
        if (selectCount == 0) {
            
            [self.view.window showHUDWithText:@"你还没有选择券" Enabled:YES];
            
        } else {
            
            UIActionSheet *deleteActionSheet = [[UIActionSheet alloc]initWithTitle:@"你确定要删除选中的券" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            
            [deleteActionSheet showInView:self.view.window];
            
        }
    }
}

#pragma mark - actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSMutableArray *delCouponIdarray = [[NSMutableArray alloc]initWithCapacity:0];
        
        for (int i = 0 ; i < [orderIdArray count]; i++) {
            
            if ([[orderTagArray objectAtIndex:i] isEqualToString:@"1"]) {
                
                [delCouponIdarray addObject:[couponIdArray objectAtIndex:i]];
                
            }
        }
        
        [self deleteCouponFormCart:delCouponIdarray];
        
    } else if (buttonIndex == 1) {
        
        NSLog(@"取消");
    }
}

#pragma mark - countSelector delegate

- (void)changeCount:(NSString *)count AndState:(BOOL)state AndTag:(int)tag
{
    OrderOperation *changCountOperation = [[OrderOperation alloc]init];
    
    if (state == YES) {
        
        [changCountOperation addCountWithId:[couponIdArray objectAtIndex:tag] AndCount:1 ByTag:^(bool result) {
            
            if (result) {
                
                [couponCountArray replaceObjectAtIndex:tag withObject:count];
                
                [ordersTableView reloadData];
                
            } else {
                
                [self.view.window showHUDWithText:@"很抱歉，购买数量超出限制" Enabled:YES];
            }
        }];
        
    } else {
        
        [changCountOperation addCountWithId:[couponIdArray objectAtIndex:tag] AndCount:-1 ByTag:^(bool result) {
            
            if (result) {
                
                [couponCountArray replaceObjectAtIndex:tag withObject:count];
                
                [ordersTableView reloadData];
                
            } else {
                
                [self.view.window showHUDWithText:@"修改购物车失败了" Enabled:YES];
            }
        }];
    }
}

- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  界面重布局
 */
- (void)viewDidLayoutSubviews
{
    couponIdArray.count > 0?[self initBottomView]:[bottomView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self initOrdersDetail];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end