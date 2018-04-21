//
//  YYURINavigationCenter.h
//  YYMobile
//
//  Created by 马英伦 on 2017/6/2.
//  Copyright © 2017年 YY.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYRouteManager.h"
#import "YYURINavigationCenterDefine.h"

//NS_ASSUME_NONNULL_BEGIN

static NSString * const YYURIScheme = @"yymobile";

@interface YYURINavigationCenter : NSObject
@property (nullable, readonly, copy) NSString *uriScheme;

+ (instancetype)sharedObject;
/**
 * 设置URIScheme
 *
 **/
- (void)setURIScheme:(NSString *)urischeme;

- (BOOL)new_handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated complete:(YYRouteCompleteBlock)complete;

- (BOOL)handleURI:(NSString*)URI;
- (BOOL)handleURI:(NSString*)URI complete:(YYRouteCompleteBlock)complete;
- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController;
- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated extendInfo:(NSDictionary *)info;
- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated complete:(YYRouteCompleteBlock)complete;
- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated extendInfo:(NSDictionary *)info complete:(YYRouteCompleteBlock)complete;

- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated extendInfo:(NSDictionary *)info complete:(YYRouteCompleteBlock)complete hasCompatible:(BOOL)hascompatible;

- (UIViewController *)viewControllerWithURI:(NSString *)URI fromViewController:(UIViewController *)viewController extendInfo:(NSDictionary *)info complete:(YYRouteCompleteBlock)complete;

/**
 是否能route该uri
 */
- (BOOL)canRouteURI:(NSString *)uri;

/**
 通过uri匹配到注册的uri

 @return 匹配到的注册uri，如果没匹配到，那么返回nil
 */
- (NSString *)matchRouteURI:(NSString *)uri;

/**
 通过uri匹配到注册的uri,并解析uri，生产YYRoute对象
 
 @return YYRoute对象，如果没匹配到，那么返回nil
 */
- (YYRoute *)parseURI:(NSString *)uri;

+ (UINavigationController*) currentVisiableRootViewController;

@end
//NS_ASSUME_NONNULL_END





