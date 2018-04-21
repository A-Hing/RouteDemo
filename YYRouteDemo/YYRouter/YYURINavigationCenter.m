//
//  YYURINavigationCenter.m
//  YYMobile
//
//  Created by 马英伦 on 2017/6/2.
//  Copyright © 2017年 YY.inc. All rights reserved.
//

#import "YYURINavigationCenter.h"
//#import "IViewControllerPort.h"
#import <objc/runtime.h>
#import "HttpUtility.h"

@interface YYURINavigationCenter()
@property (nonatomic, copy) NSString *uriScheme;
@end
#define TICK   CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

#define TOCK   NSLog(@"YYURINavigationCenter: %f", CFAbsoluteTimeGetCurrent() - start);

@implementation YYURINavigationCenter

+ (instancetype)sharedObject
{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self _resign];
    }
    return self;
}


- (void)dealloc
{
    /* comment first
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     */
}

- (void)setURIScheme:(NSString *)urischeme
{
    self.uriScheme = [urischeme copy];
}

- (void)_resign
{
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList([self class], &methodCount);
    for (int i=0; i<methodCount; i++) {
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(methods[i])) encoding:NSUTF8StringEncoding];
        NSRange subfixRange = [methodName rangeOfString:resignPrefixIndentifier];
        if (subfixRange.location == NSNotFound) {
            continue;
        }
        SEL selector = NSSelectorFromString(methodName);
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
    free(methods);
}

- (BOOL)handleURI:(NSString*)URI
{
   return [self handleURI:URI complete:nil];
}

- (BOOL)handleURI:(NSString*)URI complete:(YYRouteCompleteBlock)complete {

    return nil;  // **

    /* comment first
    return [self handleURI:URI fromViewController:[GetCoreI(IViewControllerPort) currentViewController] animated:YES complete:complete];
     */
}

- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController {
    return [self handleURI:URI fromViewController:viewController animated:YES complete:NULL];
}

- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [self handleURI:URI fromViewController:viewController animated:animated complete:NULL];
}

- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated complete:(YYRouteCompleteBlock)complete {
    return [self handleURI:URI fromViewController:viewController animated:animated extendInfo:nil complete:complete];
}

- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated extendInfo:(NSDictionary *)info
{
    return [self handleURI:URI fromViewController:viewController animated:animated extendInfo:info complete:nil];
}

- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated extendInfo:(NSDictionary *)info complete:(YYRouteCompleteBlock)complete
{
    return [self handleURI:URI fromViewController:viewController animated:animated extendInfo:info complete:complete hasCompatible:NO];
}

- (BOOL)handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated extendInfo:(NSDictionary *)info  complete:(YYRouteCompleteBlock)complete hasCompatible:(BOOL)hascompatible {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:info];
    if (viewController) {
        [parameters setObject:viewController forKey:YYURIViewControllerKey];
        [parameters setObject:@(animated) forKey:YYURIAnimationKey];
    }
    if (info) {
        [parameters setObject:info forKey:YYURIExternInfoKey];
    }
    
    @try {
        
        URI = [URI stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL*url = [NSURL URLWithString:URI];//[URI stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        if (url == nil) {
            NSString *uriUTF8 = [URI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            url = [NSURL URLWithString:uriUTF8];
        }
        
        if( URI != nil && url == nil ){
        }
        
        BOOL isHandle = [[YYRouteManager defaultManager] openURL:url parameters:[NSDictionary dictionaryWithDictionary:parameters] callbackURL:nil complete:complete];
        
        return isHandle;

    } @catch (NSException *exception) {
        return NO;
    }
}

- (BOOL)new_handleURI:(NSString *)URI fromViewController:(UIViewController *)viewController animated:(BOOL)animated complete:(YYRouteCompleteBlock)complete {
    
    NSDictionary *info = nil;
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:info];
    if (viewController) {
        [parameters setObject:viewController forKey:YYURIViewControllerKey];
        [parameters setObject:@(animated) forKey:YYURIAnimationKey];
    }
    if (info) {
        [parameters setObject:info forKey:YYURIExternInfoKey];
    }
    
    @try {
        
        URI = [URI stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL*url = [NSURL URLWithString:URI];//[URI stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        if (url == nil) {
            NSString *uriUTF8 = [URI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            url = [NSURL URLWithString:uriUTF8];
        }
        
        if( URI != nil && url == nil ){
        }
        
        BOOL isHandle = [[YYRouteManager defaultManager] new_openURL:url parameters:[NSDictionary dictionaryWithDictionary:parameters] callbackURL:nil complete:complete];
        
        return isHandle;
        
    } @catch (NSException *exception) {
        return NO;
    }
}

- (UIViewController *)viewControllerWithURI:(NSString *)URI
                         fromViewController:(UIViewController *)viewController
                                 extendInfo:(NSDictionary *)info
                                   complete:(YYRouteCompleteBlock)complete {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:info];
    if (viewController) {
        [parameters setObject:viewController forKey:YYURIViewControllerKey];
    }
    if (info) {
        [parameters setObject:info forKey:YYURIExternInfoKey];
    }
    [parameters setObject:@YES forKey:YYURIActionForGetViewControllerKey];
    
    URI = [URI stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL*url = [NSURL URLWithString:URI];//[URI stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    if (url == nil) {
        NSString *uriUTF8 = [URI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:uriUTF8];
    }
    
    if( URI != nil && url == nil ){
//        [YYLogger error:@"YYURINavigationCenter" message:@"Invalid URL %@ ,convert URL Fail!!! ",URI];
    }
    
    @try {
        UIViewController *tmpViewController = [[YYRouteManager defaultManager] viewControllerWithURL:url parameters:parameters callbackURL:nil complete:complete];
        return tmpViewController;
    }
    @catch (NSException *exception) {
//        [YYLogger warn:@"YYURINavigationCenter" message:@"YYRouteManager get viewController 异常 %@",exception];
        return nil;
    }
    
    return nil;
}

- (BOOL)canRouteURI:(NSString *)uri {
    return [[YYRouteManager defaultManager] canOpenURLstr:uri];
}

- (NSString *)matchRouteURI:(NSString *)uri {
    return [[YYRouteManager defaultManager] matchURLstr:uri];
}

- (YYRoute *)parseURI:(NSString *)uri {
    return [[YYRouteManager defaultManager] parserURLstr:uri];
}

#pragma mark - Private method
- (NSURL *)transformToURLWithURI:(NSString *)uri {
//    [YYLogger info:@"TNavigate" message:@"before transformToURLWithURI:%@", uri];

    //去掉头尾的空格
    NSString *resultURI = [uri stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange urlRange = [resultURI rangeOfString:@"http"];
    if (urlRange.location != NSNotFound && urlRange.location != 0) {
        NSArray *paths = [resultURI componentsSeparatedByString:@"http"];
        if (paths.count == 2) {
            NSString *link = [NSString stringWithFormat:@"http%@", paths[1]];
            
            NSArray *components = [link componentsSeparatedByString:@"/"];
            NSMutableArray *tmpComponents = [NSMutableArray array];
            
            for (NSString *component in components) {
                if ([component hasPrefix:@"http"]) {
                    NSString *encodeLink = [self reEncode:component];
                    [tmpComponents addObject:encodeLink];
                }else {
                    [tmpComponents addObject:component];
                }
            }
            
            NSString *encodePath = paths[0];
            if ([encodePath hasPrefix:@"/"]) {
                encodePath = [encodePath substringFromIndex:(encodePath.length - 1)];
            }
            for (NSString *component in tmpComponents) {
                encodePath = [NSString stringWithFormat:@"%@/%@", encodePath, component];
            }
            resultURI = encodePath;
        }
    }
    NSURL *url = [NSURL URLWithString:resultURI];
    if (uri == nil) {
        NSString *uriUTF8 = [resultURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:uriUTF8];
    }

    /* comment first
    [YYLogger info:TNavigate message:@"After transformToURLWithURI:%@", url];
    */

    return url;
}

- (NSString *)reEncode:(NSString *)string {
    NSString *firstEncode;
    NSInteger MaxCount = 10;
    
    while (![[NSURL URLWithString:string] host]) {
        if ([string isEqualToString:[HttpUtility urlDecode:string]] || !MaxCount) {
            break;
        }
        string = [HttpUtility urlDecode:string];
        MaxCount--;
    }
    firstEncode = string;
    
    return [HttpUtility urlEncode:[HttpUtility urlEncode:firstEncode]];
    
}

@end
