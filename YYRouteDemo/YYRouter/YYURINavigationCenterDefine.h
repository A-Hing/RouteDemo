//
//  YYURINavigationCenterDefine.h
//  YYMobile
//
//  Created by 马英伦 on 2017/6/6.
//  Copyright © 2017年 YY.inc. All rights reserved.
//

#ifndef YYURINavigationCenterDefine_h
#define YYURINavigationCenterDefine_h

#import "YYRouteManager.h"
#import "YYURINavigationCenter.h"

#define KEY(key) @#key

#define YYURIViewControllerKey @"YYURIViewControllerKey"
#define YYURIAnimationKey @"YYURIAnimationKey"
#define YYURIExternInfoKey @"YYURIExternInfoKey"
#define YYURIActionForGetViewControllerKey  @"YYURIActionForGetViewControllerKey"

#define resignPrefixIndentifier @"_UriNavigationCenterResign"

#define resignURI(t) -(void)_UriNavigationCenterResign##t
#define goto(t) -(BOOL)goto##t:(NSDictionary *)userInfo fromViewController:(UIViewController*)viewController animation:(BOOL)animated

#define resignAction(t, uriList)                            \
resignURI(t)                                                \
{                                                           \
    YYRouteHandlerBlock block = ^BOOL (YYRoute *route){                                       \
        UIViewController* vc = route.parameters[YYURIViewControllerKey];                  \
        NSNumber* isGetter = route.parameters[YYURIActionForGetViewControllerKey];        \
        if (isGetter.boolValue) {\
                NSAssert(0, @"未实现viewController的获取方法, 请用resignURIAction注册");      \
                return NO;    \
        }              \
        NSNumber* animation = route.parameters[YYURIAnimationKey];                        \
        return [self goto##t:route.parameters fromViewController:vc animation:animation.boolValue];                                                   \
    };                                                                          \
    [[YYRouteManager defaultManager] setObject:block forKeyedListSubscript:uriList];    \
}                                                                               \
goto(t)

#define registerURI(name)  \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
[[YYURINavigationCenter sharedObject] performSelector:@selector(_UriNavigationCenterResign##name)]; \
_Pragma("clang diagnostic pop")

#endif /* YYURINavigationCenterDefine_h */
