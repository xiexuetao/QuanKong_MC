//
//  QuanKongCommentController.m
//  QuanKong
//
//  Created by POWER on 14-10-16.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "NSString+DisposeStr.h"
#import "NSDate+Help.h"

#import "QuanKongCommentController.h"

@interface QuanKongCommentController ()

@end

@implementation QuanKongCommentController{
    
    NSMutableArray *commentIdArray;
    NSMutableArray *commentNameArray;
    NSMutableArray *commentScoreArray;
    NSMutableArray *commentContentArray;
    NSMutableArray *commentTimeStrArray;
    
    NSString *logoUrl;
    NSString *couponName;
    NSString *avgRating;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = LIGHT_GRAY;
        
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
        titleLabel.text = @"评价";
        
        self.navigationItem.titleView = titleLabel;
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
    }
    
    return self;
}

/**
 *  获取票券评论列表
 *
 *  @param couponId   券ID
 *  @param rating     评分
 *  @param name       券名称
 *  @param logoUrlStr 券图片URL
 */
- (void)initCommentListViewWithId:(NSString *)couponId And:(NSString *)rating And:(NSString *)name And:(NSString *)logoUrlStr
{
    NSString *commentListUrlStr = [NSString stringWithFormat:@"%@%@&couponModelId=%@&currentPage=0&pageSize=20&appKey=%@",NEW_HEAD_LINK,LIST_COMMENT,couponId,APP_KEY];
    
    avgRating = rating;
    couponName = name;
    logoUrl = [NSString stringWithFormat:@"%@%@",NEW_IMAGE_HEAD_LINK,logoUrlStr];
    
    [HTTPTool getWithPath:commentListUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            commentIdArray = [[NSMutableArray alloc]initWithCapacity:0];
            commentNameArray = [[NSMutableArray alloc]initWithCapacity:0];
            commentScoreArray = [[NSMutableArray alloc]initWithCapacity:0];
            commentContentArray = [[NSMutableArray alloc]initWithCapacity:0];
            commentTimeStrArray = [[NSMutableArray alloc]initWithCapacity:0];
            
            NSMutableArray *objList = [success objectForKey:@"objList"];
            
            for (int i = 0; i < objList.count; i++) {
                
                NSString *commentId = [[objList objectAtIndex:i]objectForKey:@"id"];
                NSString *commentName = [[objList objectAtIndex:i]objectForKey:@"nickname"];
                NSString *commentScore = [[objList objectAtIndex:i]objectForKey:@"score"];
                NSString *commentContent = [[objList objectAtIndex:i]objectForKey:@"content"];
                
                NSString *commentTimer = [NSDate getTimeStrWithString:[[objList objectAtIndex:i]objectForKey:@"createTime"]];
                
                //判断commentName是否为nil，是则赋值一个@"匿名"给它
                commentName == nil?commentName=@"匿名":nil;
                
                [commentIdArray addObject:commentId];
                [commentNameArray addObject:commentName];
                [commentScoreArray addObject:commentScore];
                [commentContentArray addObject:commentContent];
                [commentTimeStrArray addObject:commentTimer];
            }
            
            /**
             评论列表
             */
            UITableView *commentListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
            commentListTableView.delegate = self;
            commentListTableView.dataSource = self;
            commentListTableView.backgroundColor = [UIColor clearColor];
            commentListTableView.separatorColor = LIGHT_GRAY;
            
            commentListTableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
            
            [self.view insertSubview:commentListTableView atIndex:1];
            
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"Fail");
        
    }];
    
}

#pragma mark - tableView delegate

//方法类型：系统方法
//编   写：peter
//方法功能：返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

//方法类型：系统方法
//编   写：peter
//方法功能：返回tableViewCell 的个数 = 问题的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        
        return 1;
        
    } else {
        
        return [commentIdArray count];
        
    }
    
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {
        
        return 95;
        
    } else {
        
        return 92;
    }
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
    
    if(indexPath.section == 0) {
        
        //券图片
        UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 85, 75)];
        [logoView sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
        
        //券名称
        UILabel *couponNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 7, WIDTH-115, 35)];
        couponNameLabel.backgroundColor = [UIColor clearColor];
        couponNameLabel.font = [UIFont systemFontOfSize:16.0f];
        couponNameLabel.textAlignment = NSTextAlignmentLeft;
        couponNameLabel.textColor = [UIColor blackColor];
        couponNameLabel.numberOfLines = 0;
        couponNameLabel.text = couponName;
        
        //评分
        RatingView *ratingView = [[RatingView alloc]initWithFrame:CGRectMake(105, 65, 160, 20)];
        [ratingView setImagesDeselected:@"star_empty"
                         partlySelected:@"star_half"
                           fullSelected:@"star_select"
                            andDelegate:nil];
        
        [ratingView displayRating:[avgRating doubleValue]];
        
        ratingView.userInteractionEnabled = NO;
        
        //评分数字
        UILabel *ratingLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 65, 100, 17)];
        ratingLabel.backgroundColor = [UIColor clearColor];
        ratingLabel.textAlignment = NSTextAlignmentLeft;
        ratingLabel.textColor = [UIColor orangeColor];
        ratingLabel.font = [UIFont systemFontOfSize:15.0f];
        ratingLabel.text = [NSString stringWithFormat:@"（%.1f）",[avgRating floatValue]];

        [cell.contentView addSubview:logoView];
        [cell.contentView addSubview:couponNameLabel];
        [cell.contentView addSubview:ratingView];
        [cell.contentView addSubview:ratingLabel];
        
    } else {
        
        //评论人头像
        UIImageView *logoViwe = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        logoViwe.backgroundColor = [UIColor lightGrayColor];
        logoViwe.layer.masksToBounds = YES;
        logoViwe.layer.cornerRadius = logoViwe.bounds.size.height/2;
        
        [cell.contentView addSubview:logoViwe];
        
        float titleWidth = [NSString widthOfString:[commentNameArray objectAtIndex:indexPath.row] withFont:[UIFont systemFontOfSize:14.0f]];
        
        //评论标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, titleWidth+10, 15)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.text = [commentNameArray objectAtIndex:indexPath.row];
        
        [cell.contentView addSubview:titleLabel];
        
        //评论日期
        UILabel *dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 32, 140, 15)];
        dataLabel.backgroundColor = [UIColor clearColor];
        dataLabel.textAlignment = NSTextAlignmentLeft;
        dataLabel.textColor = [UIColor lightGrayColor];
        dataLabel.font = [UIFont systemFontOfSize:13.0f];
        dataLabel.text = [commentTimeStrArray objectAtIndex:indexPath.row];
        
        [cell.contentView addSubview:dataLabel];
        
        //评论内容
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, WIDTH-20,20)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont systemFontOfSize:13.0f];
        contentLabel.text = [commentContentArray objectAtIndex:indexPath.row];
        
        [cell.contentView addSubview:contentLabel];
        
        //评分
        RatingView *ratingView = [[RatingView alloc]initWithFrame:CGRectMake(WIDTH-100, 10, 140, 20)];
        [ratingView setImagesDeselected:@"star_empty"
                         partlySelected:@"star_half"
                           fullSelected:@"star_select"
                            andDelegate:nil];
        
        [ratingView displayRating:[[commentScoreArray objectAtIndex:indexPath.row] doubleValue]];
        
        ratingView.userInteractionEnabled = NO;

        [cell.contentView addSubview:ratingView];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1) {
        
        UIView *headBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        headBg.backgroundColor = [UIColor clearColor];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 20)];
        headerLabel.backgroundColor= [UIColor clearColor];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.textColor = [UIColor grayColor];
        headerLabel.font = [UIFont systemFontOfSize:14.0f];
        headerLabel.text = [NSString stringWithFormat:@"共%lu个消费评价",(unsigned long)[commentIdArray count]];
        
        [headBg addSubview:headerLabel];
        
        return headBg;
        
    } else {
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
