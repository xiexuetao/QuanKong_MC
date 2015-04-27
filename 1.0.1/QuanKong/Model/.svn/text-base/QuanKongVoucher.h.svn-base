//
//  QuanKongVoucher.h
//  QuanKong
//
//  Created by 谢雪滔 on 14/10/20.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuanKongVoucher : NSObject

/**
 *  票券券列表接口参数
 */
@property(nonatomic,assign)NSInteger agencyId;              //代理ID
@property(nonatomic,assign)NSInteger businessId;            //商家ID
@property(nonatomic,assign)int vocherId;                    //票券ID
@property(nonatomic,assign)NSInteger type;                  //票券类型
@property(nonatomic,copy)NSString *name;                    //票券名称
@property(nonatomic,copy)NSString *introduce;               //介绍文字
@property(nonatomic,copy)NSString *introduceHTML;           //介绍HTML
@property(nonatomic,strong)NSNumber *useEndTime;            //有效期（开始）
@property(nonatomic,strong)NSNumber *useStartTime;          //有效期（结束）
@property(nonatomic,copy)NSString *picUrl;                  //票券图片Url
@property(nonatomic,copy)NSString *explanation;             //使用说明
@property(nonatomic,assign)NSInteger state;                 //票券状态
@property(nonatomic,assign)NSInteger isDeal;                //是否可交易
@property(nonatomic,assign)NSInteger issueCount;            //发行数量
@property(nonatomic,assign)NSInteger totalAmount;           //总价值
@property(nonatomic,copy)NSString *faceValue;               //原价面值
@property(nonatomic,copy)NSString *estimateAmount;          //售卖金额
@property(nonatomic,assign)NSInteger miniAmount;            //最少消费金额
@property(nonatomic,assign)NSInteger discount;              //折扣
@property(nonatomic,copy)NSString *debitAmount;             //抵用金额
@property(nonatomic,assign)NSInteger saleCount;             //卖出价格
@property(nonatomic,assign)NSInteger lockedCount;           //锁定数量
@property(nonatomic,copy)NSString *logoUrl;                 //图片logoUrl，已暂停使用
@property(nonatomic,assign)NSInteger bizState;              //票券发行状态 -- 上下架等
@property(nonatomic,assign)NSInteger commentCount;          //评论数量
@property(nonatomic,assign)float commentAvg;                //评论平均分
@property(nonatomic,assign)NSInteger isComment;             //是否已评论
@property(nonatomic,assign)NSInteger favoriteCount;         //收藏数量
@property(nonatomic,assign)NSInteger isFavorite;            //是否收藏
@property(nonatomic,assign)NSInteger review1Count;          //赞数量
@property(nonatomic,assign)NSInteger isReview1;             //是否已赞
@property(nonatomic,assign)NSInteger review2Count;          //踩数量
@property(nonatomic,assign)NSInteger isReview2;             //是否已踩
@property(nonatomic,assign)NSInteger isBuyed;               //当前账户是否已经买过这券
@property(nonatomic,assign)NSInteger isUsed;                //当前账户是否已经使用过这券
@property(nonatomic,assign)NSInteger count;                 //对于“我的券包”功能，此字段表示购买的数量


@property(nonatomic,assign)NSInteger canBuyCount;           //个人剩余可购数
@property(nonatomic,assign)NSInteger isOverdueRefund;       //是否过期退款
@property(nonatomic,strong)NSNumber *createTime;            //创建日期
@property(nonatomic,strong)NSNumber *tradeTime;             //付款时间

@property(nonatomic,copy)NSString *distance;                 //券的距离

@property(nonatomic,copy)NSString *useTime;
@property(nonatomic,assign)NSNumber *addTime;
@property(nonatomic,assign)NSInteger balancePercentage;
@property(nonatomic,assign)NSInteger groupIdList;
@property(nonatomic,copy)NSString *estimatePercentage;
@property(nonatomic,strong)NSNumber *examineTime;
@property(nonatomic,copy)NSString *examineUid;
@property(nonatomic,assign)NSInteger limitNumber;
@property(nonatomic,assign)NSInteger isLimit;
@property(nonatomic,assign)NSInteger price;
@property(nonatomic,assign)NSInteger realAmount;
@property(nonatomic,assign)NSInteger earlyAmount;
@property(nonatomic,assign)NSInteger storeIdList;
@property(nonatomic,copy)NSString *tagIdList;
@property(nonatomic,copy)NSString *total;
@property(nonatomic,assign)NSInteger industryId;
@property(nonatomic,assign)NSInteger isLimitUse;
@property(nonatomic,assign)NSInteger locationId;
@property(nonatomic,copy)NSString *qrCodeUrl;
@property(nonatomic,copy)NSString *limitUseNumber;
@property(nonatomic,copy)NSString * customerId;
@property(nonatomic,copy)NSString * isValid;
@property(nonatomic,copy)NSString *createUid;
@property(nonatomic,copy)NSString *verificationId;


+(QuanKongVoucher *)initWihtData:(NSDictionary *)dic;

@end
