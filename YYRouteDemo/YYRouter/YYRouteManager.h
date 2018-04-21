#import <Foundation/Foundation.h>
#import "YYRoute.h"

#define YYROUTE(p,h) [[YYRouteManager defaultManager] registerHander:h forPath:p]

typedef BOOL (^YYRouteHandlerBlock)(YYRoute *route);
typedef void (^YYRouteCompleteBlock)(YYRoute *route);

@interface YYRouteManager : NSObject

+ (instancetype)defaultManager;


/**
 * 是否能处理该url
 */
- (BOOL)canOpenURLstr:(NSString *)urlstr;
- (BOOL)canOpenURL:(NSURL *)url;

/**
 * 匹配到的注册URI
 */
- (NSString *)matchURL:(NSURL *)url;
- (NSString *)matchURLstr:(NSString *)urlstr;

/**
 * 匹配到注册的URI，并解析成YYRoute对象
 */
- (YYRoute *)parserURL:(NSURL *)url;
- (YYRoute *)parserURLstr:(NSString *)urlstr;

/**
 *  处理url调用
 *
 *  @return 是否成功执行对应回调
 */
- (BOOL)openURL:(NSURL *)url;
- (BOOL)openURL:(NSURL *)url complete:(YYRouteCompleteBlock)complete;
- (BOOL)openURL:(NSURL *)url callbackURL:(NSURL *)callbackURL complete:(YYRouteCompleteBlock)complete;
- (BOOL)openURL:(NSURL *)url parameters:(NSDictionary *)parameters callbackURL:(NSURL *)callbackURL complete:(YYRouteCompleteBlock)complete;
- (BOOL)new_openURL:(NSURL *)url parameters:(NSDictionary *)parameters callbackURL:(NSURL *)callbackURL complete:(YYRouteCompleteBlock)complete;


- (BOOL)openURLstr:(NSString *)urlstr;
- (BOOL)openURLstr:(NSString *)urlstr complete:(YYRouteCompleteBlock)complete;
- (BOOL)openURLstr:(NSString *)urlstr parameters:(NSDictionary *)parameters complete:(YYRouteCompleteBlock)complete;

- (UIViewController *)viewControllerWithURL:(NSURL *)url
                                 parameters:(NSDictionary *)parameters
                                callbackURL:(NSURL *)callbackURL
                                   complete:(YYRouteCompleteBlock)complete;

/**
 *  支持集合快捷操作
 */
- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key;
- (void)setObject:(id)obj forKeyedListSubscript:(NSArray<NSString *> *)keylist;
- (id)objectForKeyedSubscript:(NSString *)key;


/**
 *  Route路由管理
 */
- (void)registerHander:(YYRouteHandlerBlock)routeHandlerBlock forPath:(NSString *)path;
- (void)registerHander:(YYRouteHandlerBlock)routeHandlerBlock forPaths:(NSArray<NSString *> *)paths;
- (void)unregisterPath:(NSString *)path;

@end
