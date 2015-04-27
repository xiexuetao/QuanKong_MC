//
//  newAPILink.h
//  QuanKong
//
//  Created by POWER on 14/12/10.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#ifndef QuanKong_newAPILink_h
#define QuanKong_newAPILink_h

//#define NEW_HEAD_LINK @"http://b.quancome.com/platform/api?method="           //生产
#define NEW_HEAD_LINK @"http://uat.b.quancome.com/platform/api?method="       //测试
//#define NEW_HEAD_LINK @"http://203.195.192.178/platform/api?method="          //开发

//#define NEW_IMAGE_HEAD_LINK @"http://static.quancome.com/images/"       //生产->图片
#define NEW_IMAGE_HEAD_LINK @"http://uat.static.quancome.com/images/"   //测试->图片
//#define NEW_IMAGE_HEAD_LINK @"http://203.195.192.178:9010/images/"      //开发->图片

//名传接口
//#define MC_HEAD_LINK @"http://vp.iweiwei.cn/vipboxi" //生产
#define MC_HEAD_LINK @"http://vp.iweiwei.cn/vipboxi_test" //测试

#define APP_KEY @"IOS_MC"                                             //操作系统标识符
//#define APP_KEY @"IOS_KCOUPON"
#define GET_IOS_VERSION @"admin.getIOSVersion"                          //获取IOS版本

/**
 *  商家账户
 */

#define BUSINESS @"Vipboxi"

/**
 *  首页 -> 接口
 */

#define LIST_NEW_COUPON @"issue.listNewCoupon"                          //最新的券
#define LIST_HOT_COUPON @"issue.listHotCoupon"                          //最热的券
#define LIST_PREFERENTIAL_COUPON @"issue.listPreferentialCoupon"        //最优惠的券

#define LIST_MY_MESSAGE @"customer.queryInmessage"                      //站内信列表
#define READ_MY_MESSAGE @"customer.readMessage"                         //阅读站内信

/**
 *  附近的券 -> 接口
 */

#define LIST_NEAR_COUPON @"issue.listNearbyCoupon"                      //附近的券

/**
 *  券详情
 */

#define COUPON_MODEL @"issue.viewCouponModel"                           //券详情

#define LIST_COMMENT @"custQuery.listComment"                           //券评论列表
#define LIST_STORE   @"issue.listCouponStore"                           //券店铺信息

#define ADD_FAVORITE @"customer.addFavorite"                            //增加我的收藏
#define DELETE_FAVORITE @"customer.deleteFavorite"                      //删除我的收藏

/**
 *  购物车
 */

#define LIST_MY_CART @"customer.listCartCoupon"                         //我的购物车
#define ADD_TO_MY_CART  @"customer.addCouponToCart"                     //增加到我的购物车
#define DELETE_IN_MY_CART @"customer.deleteCouponInCarts"               //删除我的购物车

/**
 *  购买（创建订单)
 */

#define ADD_FREE_COUPON @"customer.addFreeCoupon"                       //直接创建订单（优惠券）
#define CREATE_ORDER_NOW @"customer.createCouponOrderNow"               //直接创建订单（现金券）
#define CREATE_ORDER @"customer.createOrder"                            //创建订单（多张）

#define PAY_BY_WALLET @"payment.payByWallet"                            //钱包支付
#define GET_MY_WALLET @"customer.getCustomerWallet"                     //获取我的钱包

/**
 *  付款
 */

#define ORDER_DETAIL @"customer.viewOrderDetail"                        //订单明细

/**
 *  订单
 */

#define ADD_COMMENT @"customer.addComment"                              //增加评论



/**
 *  充值与提现
 */

#define BANK_LIST @"admin.queryBankDefList"                             //银行定义

#define USER_BANK_INFO @"custBank.viewByCustId"                         //获取绑定银行卡（用户标识）
#define BANK_INFO @"custBank.view"                                      //获取绑定银行卡（主键）

#define ADD_BANK @"custBank.add"                                        //新增绑定银行卡（只能一张）
#define UPDATE_BANK @"custBank.update"                                  //修改绑定银行卡
#define DELETE_BANK @"custBank.delete"                                  //删除绑定银行卡

#define WITHDARW @"customer.saveWithdrawal"                             //提现申请
#define WITHDARW_TOTAL @"customer.myWithdrawalTotal"                    //提现申请记录汇总
#define WITHDARW_HISTORY @"customer.listWithdrawal"                     //提现申请记录详情

#define SET_UP_CUSTOMER @"customer.setupCustomer"                       //客户提现名字设置


#endif
