#import "YYRouteMatcher.h"

static NSString * const YYRouteParameterPattern = @":[a-zA-Z0-9-_%]+";  // ':'开始的字符 --> 分割参数
static NSString * const YYURLParameterPattern = @"([^/]+)";  // 以一个或者多个'/'开始 ： --> 参数占位符

@interface YYRouteMatcher ()

@property (nonatomic, copy)   NSString  *route;
@property (nonatomic, strong) NSRegularExpression *regex;
@property (nonatomic, strong) NSMutableArray *routeParamaterNames;
@property (nonatomic, strong) NSString *pathComponent;
@end

@implementation YYRouteMatcher

+ (instancetype)matcherWithPath:(NSString *)path {
    return [[self alloc] initWithPath:path];
}


- (instancetype)initWithPath:(NSString *)route {
    if (![route length]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _route = route;
    }
    
    return self;
}
// 截取NSURL路径，用与新路由pi'pei
- (NSString *)pathComponent {
    if (_pathComponent == nil) {
        NSString *pattern = self.route;
        if ([self.route characterAtIndex:0] == '/') {
            pattern = [pattern substringFromIndex:1];
        }
        NSRange range = [pattern rangeOfString:@"/:"];
        if (range.location != NSNotFound) {
            pattern = [pattern substringToIndex:range.location];
        }
        _pathComponent = pattern;
    }
    return _pathComponent;
}

- (NSRegularExpression *)regex {
    if (!_regex) {
        _routeParamaterNames = [NSMutableArray array];
        NSRegularExpression *parameterRegex = [NSRegularExpression regularExpressionWithPattern:YYRouteParameterPattern
                                                                                        options:0
                                                                                          error:nil];
        
        NSString *modifiedRoute = [self.route copy];
        NSArray *matches = [parameterRegex matchesInString:self.route
                                                   options:0
                                                     range:NSMakeRange(0, self.route.length)];
        
        for (NSTextCheckingResult *result in matches) {
            
            NSString *stringToReplace   = [self.route substringWithRange:result.range];
            NSString *variableName      = [stringToReplace stringByReplacingOccurrencesOfString:@":"
                                                                                     withString:@""];
            [self.routeParamaterNames addObject:variableName];
            
            modifiedRoute = [modifiedRoute stringByReplacingOccurrencesOfString:stringToReplace
                                                                     withString:YYURLParameterPattern];
        }
        
        modifiedRoute = [modifiedRoute stringByAppendingString:@"$"];
        _regex = [NSRegularExpression regularExpressionWithPattern:modifiedRoute
                                                           options:NSRegularExpressionCaseInsensitive   //注意匹配不区分大小写，因为openURL有时会把url的host部分大写转成小写
                                                             error:nil];
    }
    
    return _regex;
}


- (BOOL)matchRoute:(YYRoute *)route {
    if (route.destURL.query) {
        // 标准URI走新匹配方式 yymobile://MainHome/Tab?category=1&subCategory=2，
        @try {
            BOOL isMatchSucceed = [self matchStandardURIWithRoute:route];
            if (isMatchSucceed == NO) {
                //但是对于yymobile://Channel/Live/45294452/452294452?tpl=16777217则需要走老匹配方式
                isMatchSucceed = [self matchOldURIWithRoute:route];
            }
            return isMatchSucceed;
        }
        @catch (NSException *exception){
            return NO;
        }
    }else {
        return [self matchOldURIWithRoute:route];
    }
}

#pragma mark -- 标准URI匹配方式   如：yymobile://MainHome/Tab?category=1&subCategory=2
- (BOOL)matchStandardURIWithRoute:(YYRoute *)route {
    NSString *routeString = route.destURL.standardizedURL.absoluteString;
    
    NSString *pathCompoment = route.destURL.host;
    pathCompoment = [pathCompoment stringByAppendingPathComponent:route.destURL.path];
    //TODO：openUrl打开app时，有时会把host部分的大写换成小写
    if (([pathCompoment compare:self.pathComponent options:NSCaseInsensitiveSearch] == NSOrderedSame) && pathCompoment) {
        NSURLComponents *components = [NSURLComponents componentsWithString:routeString];
        NSMutableDictionary *routeParameters = [NSMutableDictionary dictionary];
        for (NSURLQueryItem *queryItem in components.queryItems) {
            if (queryItem.value && queryItem.name) {
                [routeParameters setValue:queryItem.value forKey:queryItem.name];
            }
        }
        route.parameters = routeParameters;
        return YES;
    }
    return NO;
}

#pragma mark -- 标准URI匹配方式   如：yymobile://MainHome/Tab/1/2或yymobile://MainHome/Tab/1/2?params=3 对应注册URI：MainHome/Tab/:category/:subCategory
- (BOOL)matchOldURIWithRoute:(YYRoute *)route {
    NSString *routeString = route.destURL.standardizedURL.absoluteString;
    if (route.destURL.query) {
//        NSString *pathCompoment = route.destURL.host;
//        routeString = [pathCompoment stringByAppendingPathComponent:route.destURL.path];
        // 去头去尾
        routeString = [routeString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://",route.destURL.scheme]
                                                             withString:@""];
        routeString = [routeString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"?%@",route.destURL.query]
                                                             withString:@""];
    }
    
    NSArray *matches      = [self.regex matchesInString:routeString
                                                options:0
                                                  range:NSMakeRange(0, routeString.length)];
    
    if (!matches.count) {
        return NO;
    }
    
    NSMutableDictionary *routeParameters = [NSMutableDictionary dictionary];
    for (NSTextCheckingResult *result in matches) {
        
        for (int i = 1; i < result.numberOfRanges && i <= self.routeParamaterNames.count; i++) {
            NSString *parameterName         = self.routeParamaterNames[i - 1];
            NSString *parameterValue        = [routeString substringWithRange:[result rangeAtIndex:i]];
//            routeParameters[parameterName]  = [parameterValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            routeParameters[parameterName]  = [parameterValue stringByRemovingPercentEncoding];
        }
    }
    
    if (route.destURL.query) {
        NSURLComponents *components = [NSURLComponents componentsWithString:route.destURL.standardizedURL.absoluteString];
        NSMutableDictionary *routeParameters = [NSMutableDictionary dictionary];
        for (NSURLQueryItem *queryItem in components.queryItems) {
            if (queryItem.value && queryItem.name) {
                [routeParameters setValue:queryItem.value forKey:queryItem.name];
            }
        }
    }
    
    route.parameters = routeParameters;
    
    return YES;
}

@end
