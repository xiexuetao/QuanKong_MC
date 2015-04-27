//
//  UserBankInfoController.m
//  QuanKong
//
//  Created by POWER on 1/6/15.
//  Copyright (c) 2015 Rockcent. All rights reserved.
//

#import "AddUserBankController.h"

#import "BankInfoListController.h"
#import "WithdrawViewController.h"

@interface AddUserBankController ()<bankInfoListDelegate>

@end

@implementation AddUserBankController
{
    NSArray *titleArray;
    NSArray *placeholderArray;
    NSMutableArray *bankinfoTextArray;
    
    NSString *bankNumStr;
    
    BOOL bankNameSelect;
}

@synthesize bankInfoTextField;
@synthesize buttonTitleLabel;

@synthesize selectBankId;
@synthesize bankLogoUrlStr;

- (void)initMainView
{
    titleArray = @[@"姓名",@"卡号"];
    placeholderArray = @[@"持卡人姓名",@"银行卡号"];
    
    bankinfoTextArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    #endif
    
    //加入返回
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    [self.navigationItem setLeftBarButtonItem:backItemButton];
    
    //UINavigationItem标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.text = @"绑定银行卡";
    
    self.navigationItem.titleView = titleLabel;
    
    UILabel *warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 230, WIDTH-20, 50)];
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.textAlignment = NSTextAlignmentLeft;
    warningLabel.textColor = [UIColor grayColor];
    warningLabel.numberOfLines = 0;
    warningLabel.font = [UIFont systemFontOfSize:13.0f];
    warningLabel.text = @"说明：请输入与真实姓名同名的银行卡，并确保信息准确，否则会导致提现失败";
    
    bankNumStr = @"";
    
    [self.view addSubview:warningLabel];
    
}

- (void)pushBack:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [self initMainView];
    
    [self setUpForDismissKeyboard];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    bankNumStr = [(UITextField *)[bankinfoTextArray objectAtIndex:1] text];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section==1) {
        
        return 2;
        
    } else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 50;
        
    } else {
        
        return 40;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    
    switch (indexPath.section) {
        case 0:
        {
            if (bankNameSelect) {
                
                UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 130, 42)];
                
                [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,bankLogoUrlStr]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
                
                [cell.contentView addSubview:iconView];
                
            } else {
            
                titleLabel.frame = CGRectMake(10, 10, 80, 30);
                titleLabel.text = @"选择银行";
                
            }
            
            UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 12)];
            arrowImageView.image = [UIImage imageNamed:@"arrow_gray"];
            cell.accessoryView = arrowImageView;
        }
            break;
        case 1:
        {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 39.75, WIDTH-10, 0.5)];
            lineView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
            
            [cell.contentView addSubview:lineView];
            
            bankInfoTextField = [[UITextField alloc]initWithFrame:CGRectMake(55, 5, WIDTH-65, 30)];
            bankInfoTextField.delegate = self;
            bankInfoTextField.backgroundColor = [UIColor clearColor];
            bankInfoTextField.textAlignment = NSTextAlignmentLeft;
            bankInfoTextField.textColor = [UIColor blackColor];
            bankInfoTextField.font = [UIFont systemFontOfSize:16.0f];
            bankInfoTextField.tag = indexPath.row;
            bankInfoTextField.placeholder = [placeholderArray objectAtIndex:indexPath.row];
            
            indexPath.row==0?bankInfoTextField.text = [UserInfo shareUserInfo].realName:nil;
            indexPath.row==0?bankInfoTextField.textColor = [UIColor lightGrayColor]:nil;
            indexPath.row==0?[bankInfoTextField setUserInteractionEnabled:NO]:nil;
            
            indexPath.row==1?[bankInfoTextField setKeyboardType:UIKeyboardTypeNumberPad]:nil;
            indexPath.row==1?bankInfoTextField.text = bankNumStr:nil;
            
            [cell.contentView addSubview:bankInfoTextField];
            
            [bankinfoTextArray insertObject:bankInfoTextField atIndex:indexPath.row];
            
            titleLabel.text = [titleArray objectAtIndex:indexPath.row];
        }
            break;
        case 2:
        {
            buttonTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            buttonTitleLabel.textColor = [UIColor lightGrayColor];
            buttonTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            buttonTitleLabel.textAlignment = NSTextAlignmentCenter;
            buttonTitleLabel.text = @"绑定";
            
            if(bankNameSelect && [(UITextField *)[bankinfoTextArray objectAtIndex:0]text].length > 0 && [(UITextField *)[bankinfoTextArray objectAtIndex:1]text].length > 12 && bankNumStr.length < 20)
            {
                buttonTitleLabel.textColor = [UIColor whiteColor];
                buttonTitleLabel.backgroundColor = [UIColor orangeColor];
            }
            
            [cell.contentView addSubview:buttonTitleLabel];
        }
            break;
        default:
            break;
    }
    
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        BankInfoListController *bankInfoListController = [[BankInfoListController alloc]initWithStyle:UITableViewStyleGrouped];
        bankInfoListController.delegate = self;
        [self.navigationController pushViewController:bankInfoListController animated:YES];
        
    } else if (indexPath.section == 2) {
        
        if (bankNameSelect && [(UITextField *)[bankinfoTextArray objectAtIndex:0]text].length > 0 && [(UITextField *)[bankinfoTextArray objectAtIndex:1]text].length > 12 && [(UITextField *)[bankinfoTextArray objectAtIndex:1]text].length < 20) {
            
            NSString *accountName = [(UITextField *)[bankinfoTextArray objectAtIndex:0]text];
            NSString *accountNum = [(UITextField *)[bankinfoTextArray objectAtIndex:1]text];
            
            if([accountName isEqualToString:[UserInfo shareUserInfo].realName]) {
                
                NSLog(@"Fuck");
                
                NSString *addBankInfoUrlStr = [[NSString stringWithFormat:@"%@%@&loginName=%@&accountNo=%@&accountName=%@&bankDefId=%@&appKey=%@",NEW_HEAD_LINK,ADD_BANK,[UserInfo shareUserInfo].userName,accountNum,accountName,selectBankId,APP_KEY]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [HTTPTool getWithPath:addBankInfoUrlStr success:^(id success) {
                    
                    NSString *msg = [success objectForKey:@"msg"];
                    
                    if ([msg isEqualToString:@"success"]) {
                        
                        [self.view.window showHUDWithText:@"绑定银行卡成功" Enabled:YES];
                        
                        [[UserInfo shareUserInfo]setBankSelect:YES];
                        
                        [self performSelector:@selector(pushIn:) withObject:nil afterDelay:2.0];
                        
                    } else {
                        
                        [self.view.window showHUDWithText:@"绑定银行卡失败" Enabled:YES];
                    }
                    
                } fail:^(NSError *error) {
                    
                    NSLog(@"NetWork Fail");
                    
                }];
                
            } else {
                
                [self.view.window showHUDWithText:@"你的账户姓名与真实姓名不符" Enabled:YES];
            }
            
        } else if(!bankNameSelect){
            
            [self.view.window showHUDWithText:@"请选择银行卡所属银行" Enabled:YES];
        }
    }
}

#pragma mark - bankInfo delegate

- (void)selectBankIdWithId:(NSString *)bankId AndImageUrl:(NSString *)url
{
    if (bankId == NULL || url == NULL) {
        
        bankNameSelect = NO;
        
    } else {
        
        bankNameSelect = YES;
        
        selectBankId = bankId;
        bankLogoUrlStr = url;
        
        [self.tableView reloadData];
    }
}

#pragma mark - textField delegate

/**
 *  键盘收起监听
 */
- (void)setUpForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
    
    [nc addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:bankInfoTextField];
}

/**
 *  键盘手势监听操作
 *
 *  @param gestureRecognizer 手势
 */
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    
    [self.view endEditing:YES];
}

/**
 *  textFilld
 *
 *  @param sender textField检测
 */
- (void)textFieldChanged:(id)sender
{
    NSLog(@"%@",bankInfoTextField.text);
}

- (void)pushIn:(UIButton *)sender
{
    [self.navigationController pushViewController:[[WithdrawViewController alloc]init] animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    
    if ([string length]>0)
    {
        
        if ([(UITextField *)[bankinfoTextArray objectAtIndex:0]text].length > 0 && [(UITextField *)[bankinfoTextArray objectAtIndex:1]text].length > 11 && [(UITextField *)[bankinfoTextArray objectAtIndex:1]text].length < 19) {
            
            buttonTitleLabel.textColor = [UIColor whiteColor];
            buttonTitleLabel.backgroundColor = [UIColor orangeColor];
            
            return YES;
        
        } else if ([(UITextField *)[bankinfoTextArray objectAtIndex:1]text].length > 18) {
            
            return NO;
            
        } else {
            
            buttonTitleLabel.textColor = [UIColor lightGrayColor];
            buttonTitleLabel.backgroundColor = [UIColor whiteColor];
            
            return YES;
        }
        
    } else {
        
        if([(UITextField *)[bankinfoTextArray objectAtIndex:0]text].length == 0 || [(UITextField *)[bankinfoTextArray objectAtIndex:1]text].length < 14){
            
            buttonTitleLabel.textColor = [UIColor lightGrayColor];
            buttonTitleLabel.backgroundColor = [UIColor whiteColor];
    
            return YES;
            
        }
        
        return YES;
    }
    
}

/**
 *  银行卡号判断正则
 *
 *  @param bankCardNumber 输入卡号
 *
 *  @return 正确判断
 */
+ (BOOL)validateBankCardNumber:(NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}

@end
