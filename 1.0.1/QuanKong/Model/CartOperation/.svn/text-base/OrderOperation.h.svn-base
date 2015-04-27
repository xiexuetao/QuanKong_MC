//
//  OrderOperation.h
//  QuanKong
//
//  Created by POWER on 14/11/19.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfo.h"
#import "HTTPTool.h"

@interface OrderOperation : NSObject

/**
 *  根据tagArray及count获得现实购物车内选择商品数
 *
 *  @param array       订单选择数组
 *  @param row         当前选择商品Row
 *  @param selectCount 当前选择商品数量
 *
 *  @return 购物车商品选择的数量
 */
- (int)setCountWithOrderArray:(NSArray *)array AndRow:(int)row AndSelectCount:(int)selectCount;

/**
 *  根据tagArray获取当前购物车内选择商品数
 *
 *  @param array 订单选择标识数组
 *
 *  @return 购物车商品选择的数量
 */
- (int)getCountWithTagArray:(NSArray *)array;

/**
 *  根据tagArray获得现实购物车内总价
 *
 *  @param array       订单选择标识数组
 *  @param count       当前选择商品Row
 *  @param totalCount  当时选择商品的总价
 *  @param countArray  购物车商品价钱数组
 *  @param amountArray 购物车商品价钱数组
 *
 *  @return 购物车内总价
 */
- (CGFloat)setTotalWtihOrderArray:(NSArray *)array AndRow:(int)Row AndTotalCount:(float)totalCount AndCountArray:(NSArray *)countArray andEstimateAmountArray:(NSArray *)amountArray;

/**
 *  根据tagArray获取当前购物车内选择商品的总价
 *
 *  @param array       订单选择标识数组
 *  @param countArray  购物车商品数量数组
 *  @param amountArray 购物车商品价钱数组
 *
 *  @return 购物车商品选择的商品的总价
 */
- (CGFloat)getTotalWithTagArray:(NSArray *)array AndCountArray:(NSArray *)countArray andEstimateAmountArray:(NSArray *)amountArray;

/**
 *  购物车内券修改操作，加->+(1)，减->+(-1)
 *
 *  @param couponId 券ID
 *  @param Count    数目
 *  @param result   结果的结构block（由于block嵌套block，不能简单使用返回值)
 */
- (void)addCountWithId:(NSString *)couponId AndCount:(int)Count ByTag:(void (^)(bool result))result;

@end
