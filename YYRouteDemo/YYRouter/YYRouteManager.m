#import "YYRouteManager.h"
#import "YYRouteMatcher.h"
#import "YYRoute.h"

@interface YYRouteManager ()

@property (nonatomic, strong) NSMutableDictionary *handlers;
@property (nonatomic, strong) NSMutableDictionary *matchers;  // 缓存：YYRouteMatcher

@end


@implementation YYRouteManager

+ (instancetype)defaultManager{
    static id _shareInstance = nil;
    static dispatch_once_t onePredicate;
    dispatch_once(&onePredicate, ^{
        _shareInstance = [[self alloc] init];
    });
    return _shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.handlers  = [NSMutableDictionary dictionary];
        self.matchers  = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Routes Manager

- (void)registerHander:(YYRouteHandlerBlock)routeHandlerBlock forPath:(NSString *)path
{
    
    if (routeHandlerBlock && [path length]) {
        self.handlers[path] = [routeHandlerBlock copy];
    }
}

- (void)registerHander:(YYRouteHandlerBlock)routeHandlerBlock forPaths:(NSArray<NSString *> *)paths
{
    for (NSString *path in paths) {
        [self registerHander:routeHandlerBlock forPath:path];
    }
}


- (void)unregisterPath:(NSString *)path
{
    [self.handlers removeObjectForKey:path];
    [self.matchers removeObjectForKey:path];
}

#pragma mark - Object Subscripting

- (id)objectForKeyedSubscript:(NSString *)key
{
    NSString *route = (NSString *)key;
    id obj = nil;
    
    if ([route isKindOfClass:[NSString class]] && route.length) {
        obj = self.handlers[route];
    }
    
    return obj;
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key
{
    
    NSString *route = (NSString *)key;
    if (!([route isKindOfClass:[NSString class]] && route.length)) {
        return;
    }
    
    if (!obj) {
        [self.handlers removeObjectForKey:route];
    }
    else if ([obj isKindOfClass:NSClassFromString(@"NSBlock")]) {
        [self registerHander:obj forPath:route];
    }
}

- (void)setObject:(id)obj forKeyedListSubscript:(NSArray<NSString *> *)keylist
{
    for (NSString *key in keylist) {
        [self setObject:obj forKeyedSubscript:key];
    }
}


#pragma mark - Shortcut 

- (BOOL)openURLstr:(NSString *)urlstr
{
    return [self openURLstr:urlstr complete:NULL];
}

- (BOOL)openURLstr:(NSString *)urlstr complete:(YYRouteCompleteBlock)complete
{
    return [self openURLstr:urlstr parameters:nil complete:complete];
}

- (BOOL)openURLstr:(NSString *)urlstr parameters:(NSDictionary *)parameters complete:(YYRouteCompleteBlock)complete
{
    NSURL *url = [NSURL URLWithString:urlstr];
    
    if (url) {
        return [self openURL:url parameters:parameters callbackURL:nil complete:complete];
    } else {
        return NO;
    }
}

#pragma mark - check match
- (BOOL)canOpenURLstr:(NSString *)urlstr {
    NSURL *url = [NSURL URLWithString:urlstr];
    if (url) {
        return [self canOpenURL:url];
    }
    return NO;
}

- (BOOL)canOpenURL:(NSURL *)url {
    if (!url) {
        return NO;
    }
    BOOL canOpen = NO;
    YYRoute  *route = [[YYRoute alloc] initWithURL:[url standardizedURL]];
    for (NSString *path in self.handlers.allKeys) {
        YYRouteMatcher *matcher = [self.matchers objectForKey:path];
        
        if (!matcher) {
            matcher = [YYRouteMatcher matcherWithPath:path];
            [self.matchers setObject:matcher forKey:path];
        }
        
        canOpen = [matcher matchRoute:route];
        if (canOpen) break;
    }
    return canOpen;
}

- (NSString *)matchURLstr:(NSString *)urlstr {
    NSURL *url = [NSURL URLWithString:urlstr];
    if (url) {
        return [self matchURL:url];
    }
    return nil;
}

- (NSString *)matchURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    NSString *uri = nil;
    YYRoute  *route = [[YYRoute alloc] initWithURL:[url standardizedURL]];
    for (NSString *path in self.handlers.allKeys) {
        YYRouteMatcher *matcher = [self.matchers objectForKey:path];
        
        if (!matcher) {
            matcher = [YYRouteMatcher matcherWithPath:path];
            [self.matchers setObject:matcher forKey:path];
        }
        
        BOOL isMatch = [matcher matchRoute:route];
        if (isMatch) {
            uri = matcher.route;
            break;
        }
    }
    return uri;
}

- (YYRoute *)parserURLstr:(NSString *)urlstr {
    NSURL *url = [NSURL URLWithString:urlstr];
    if (url) {
        return [self parserURL:url];
    }
    return nil;
}

- (YYRoute *)parserURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    YYRoute  *route = [[YYRoute alloc] initWithURL:[url standardizedURL]];
    for (NSString *path in self.handlers.allKeys) {
        YYRouteMatcher *matcher = [self.matchers objectForKey:path];
        
        if (!matcher) {
            matcher = [YYRouteMatcher matcherWithPath:path];
            [self.matchers setObject:matcher forKey:path];
        }
        
        BOOL isMatch = [matcher matchRoute:route];
        if (isMatch) {
            return route;
        }
    }
    return nil;
}

#pragma mark - Routing

- (BOOL)openURL:(NSURL *)url {
    
    return [self openURL:url complete:NULL];
}

- (BOOL)openURL:(NSURL *)url complete:(YYRouteCompleteBlock)complete
{
    return [self openURL:url callbackURL:nil complete:complete];
}

- (BOOL)openURL:(NSURL *)url callbackURL:(NSURL *)callbackURL complete:(YYRouteCompleteBlock)complete
{
    return [self openURL:url parameters:nil callbackURL:callbackURL complete:complete];
}

#define TICK   CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

#define TOCK   printf("Time: %f\n", CFAbsoluteTimeGetCurrent() - start);
- (BOOL)new_openURL:(NSURL *)url parameters:(NSDictionary *)parameters callbackURL:(NSURL *)callbackURL complete:(YYRouteCompleteBlock)complete {

    if (!url) {
        return NO;
    }
    //    TICK
    NSString *routekey = [NSString stringWithFormat:@"%@%@",url.host,url.path];

    __autoreleasing YYRoute  *route = [[YYRoute alloc] initWithURL:[url standardizedURL]];

    route.callbackURL = callbackURL;

    // 3、添加自定的参数
    if (parameters) {
        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:route.parameters];
        [mDict addEntriesFromDictionary:parameters];
        route.parameters = [mDict copy];
    }

    __block BOOL isHandled = NO;
    isHandled = [self handlePath:routekey withRoute:route];
    //    TOCK
    if (complete) {
        complete(route);
        complete = nil;
    }
    return isHandled;
}

- (BOOL)openURL:(NSURL *)url parameters:(NSDictionary *)parameters callbackURL:(NSURL *)callbackURL complete:(YYRouteCompleteBlock)complete
{
    if (!url) {
        return NO;
    }
    __autoreleasing YYRoute  *route = [[YYRoute alloc] initWithURL:[url standardizedURL]];

    __block BOOL isHandled = NO;

    for (NSString *path in self.handlers.allKeys) {

        // 1、self.matchers 缓存 YYRouteMatcher 对象
        YYRouteMatcher *matcher = [self.matchers objectForKey:path];

        if (!matcher) {
            matcher = [YYRouteMatcher matcherWithPath:path];
            [self.matchers setObject:matcher forKey:path];
        }

        // 2、匹配 路由   YYRouteMatcher(注册的路由path) 根据 YYRoute (url) 做匹配
        BOOL isMatch = [matcher matchRoute:route];
        if (!isMatch) {
            continue;
        }

        route.callbackURL = callbackURL;

        // 3、添加自定的参数
        if (parameters) {
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:route.parameters];
            [mDict addEntriesFromDictionary:parameters];
            route.parameters = [mDict copy];
        }

        // 4、调用
        isHandled = [self handlePath:path withRoute:route];
        if (complete) {
            complete(route);
            complete = nil;
        }
        break;
    }
    return isHandled;
}

// 实现block调用
- (BOOL)handlePath:(NSString *)path withRoute:(YYRoute *)route {
    id handler = self[path];
    
    if ([handler isKindOfClass:NSClassFromString(@"NSBlock")]) {
        YYRouteHandlerBlock routeHandlerBlock = handler;
        BOOL isHandle = routeHandlerBlock(route);
        return isHandle;

    }
    return NO;
}


#pragma mark -- get router viewController method
- (UIViewController *)viewControllerWithURL:(NSURL *)url
                                 parameters:(NSDictionary *)parameters
                                callbackURL:(NSURL *)callbackURL
                                   complete:(YYRouteCompleteBlock)complete {
    if (!url) {
        return nil;
    }
    
    YYRoute *route = [[YYRoute alloc] initWithURL:[url standardizedURL]];
    for (NSString *path in self.handlers.allKeys) {
        YYRouteMatcher *matcher = [self.matchers objectForKey:path];
        if (!matcher) {
            matcher = [YYRouteMatcher matcherWithPath:path];
            [self.matchers setObject:matcher forKey:path];
        }
        BOOL isMatch = [matcher matchRoute:route];
        if (!isMatch) {
            continue;
        }
        route.callbackURL = callbackURL;
        if (parameters) {
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:route.parameters];
            [mDict addEntriesFromDictionary:parameters];
            route.parameters = mDict;
        }
        
        BOOL isHandled = [self handlePath:path withRoute:route];
        if (complete && isHandled) {
            complete(route);
            complete = nil;
        }
    }
    
    return route.viewController;
}
@end
