//
//  ViewController+adapt2.m
//  YYRouteDemo
//
//  Created by A-Hing on 2018/4/21.
//  Copyright © 2018年 A-Hing. All rights reserved.
//

#import "ViewController+adapt2.h"

@implementation ViewController (adapt2)

- (NSString *)ada_converOldURIToStandardURI_1:(NSString *)originalUrl {

    NSURL *url = [NSURL URLWithString:[originalUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    if (url == nil) {
        return originalUrl;
    }
    NSDictionary *oldRouteData = [self oldRouteData];
    NSDictionary *standardRouteData = [self standardRouteData];

    NSString *donerouteStr = nil;
    BOOL isMatchOldURI = NO;  //标记是否匹配到旧命令

    for (NSString *routeKey in oldRouteData.allKeys) {

        if ([originalUrl containsString:routeKey]) {

            NSString *domainStr = [NSString stringWithFormat:@"%@://%@",url.scheme,routeKey]; //sodamobile://Shenqu/TinyVideo/Detail

            // 获取参数  eg: /A/B/C/
            NSString *paramStr = [self getOldRouteParam:url routeKey:routeKey];

            // 没有参数直接返回
            if ([paramStr length] == 0) {
                return domainStr;
            }

            // 拼接参数 eg: key1=A&key2=B&key3=C
            NSDictionary *paramsDic = [self getRouteParamDic:[paramStr componentsSeparatedByString:@"/"]
                                         oldRouteParamKeyArr:[oldRouteData objectForKey:routeKey]];

            //旧命令转换成已经有的新命令
            if ([standardRouteData objectForKey:domainStr]) {
                domainStr = [standardRouteData objectForKey:domainStr];
            }

            //转成标准的命令
            donerouteStr = [NSString stringWithFormat:@"%@?%@&%@",domainStr,
                            [self urlQueryString:paramsDic],
                            url.query ?: @""];
            isMatchOldURI = YES;
            break;
        }
    }
    if (isMatchOldURI == NO) {
        return originalUrl;
    }
    return donerouteStr;
}

- (NSString *)getOldRouteParam:(NSURL *)url
                      routeKey:(NSString *)routeKey {
    
    NSString *paramStr = url.absoluteString;
    
    if (url.query) {
        
        paramStr = [paramStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://%@/",url.scheme,routeKey]
                                                       withString:@""];
        paramStr = [paramStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"?%@",url.query]
                                                       withString:@""];
        
    }else {
        paramStr = [paramStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://%@/",url.scheme,routeKey]
                                                       withString:@""];
        paramStr = [paramStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://%@",url.scheme,routeKey]
                                                       withString:@""];
    }
    return paramStr;
}

- (NSDictionary *)getRouteParamDic:(NSArray *)paramValueArr
               oldRouteParamKeyArr:(NSArray *)oldRouteParamKeyArr {
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < paramValueArr.count; i++) {
        
        NSString *key = nil;
        NSString *value =nil;
        if (oldRouteParamKeyArr.count > i) {
            key = [oldRouteParamKeyArr objectAtIndex:i];
        }
        if (paramValueArr.count > i) {
            value = [paramValueArr objectAtIndex:i];
        }
        if (key && value) {
            [paramsDic setObject:value forKey:key];
        }
    }
    return [paramsDic copy];
}


//播放页命令：有新旧两套，统一转成一套
- (NSDictionary *)standardRouteData {
    
    NSDictionary *dict = @{
                           @"sodamobile://Shenqu/TinyVideo/Detail":@"sodamobile://ShortVideo/Detail",
                           };
    return dict;
}

//旧路由命令
- (NSDictionary *)oldRouteData {
    
    NSDictionary *dict = @{
                           @"Shenqu/TinyVideo/Detail":@[@"resid",@"encodeVideoUrl",@"videoDPI",@"encodeSnapshotUrl"],
                           @"TinyVideo/VT/D":@[@"musicId",@"topic",@"singer"],
                           @"Shenqu/VT/D":@[@"topic"],
                           @"PersonalCenter":@[@"uid"],
                           @"PersonalCenter/focus":@[@"uid"],
                           @"PersonalCenter/fans":@[@"uid"],
                           @"TinyVideo/segmentIndex":@[@"index"],
                           @"Web/Features":@[@"features",@"encodedURL"],
                           @"TinyVideo/MessageCenter":@[@"msgPageType"],
                           @"TinyVideo/Record":@[@"topicName",@"materialId",@"materialType",@"resourceType"],
                           };
    return dict;
}


@end
