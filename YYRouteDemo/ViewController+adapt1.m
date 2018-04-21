//
//  ViewController+adapt1.m
//  YYRouteDemo
//
//  Created by A-Hing on 2018/4/21.
//  Copyright © 2018年 A-Hing. All rights reserved.
//

#import "ViewController+adapt1.h"

NSString *const webRoute = @"Web/Features";
NSString* const musicRoute = @"Shenqu/VT/D";
NSString* const videoRoute = @"Shenqu/TinyVideo/Detail";
NSString* const persionalRoute = @"PersonalCenter";
NSString* const foucusRoute = @"PersonalCenter/focus";
NSString* const fansRoute = @"PersonalCenter/fans";
NSString* const segemntbRoute = @"TinyVideo/segmentIndex";
NSString* const msgRoute = @"TinyVideo/MessageCenter";
NSString* const recordRoute = @"TinyVideo/Record";

@implementation ViewController (adapt1)

- (NSString *)ada_converOldURIToStandardURI:(NSString *)originalUrl {
    
    NSURL *url = [NSURL URLWithString:[originalUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    if (url == nil) {
        return originalUrl;
    }
    
    if ([originalUrl hasPrefix:[NSString stringWithFormat:@"%@://%@/",url.scheme,webRoute]]) {
        
        return [self routeForWebUrl:url];
    }
    else if ([originalUrl hasPrefix:[NSString stringWithFormat:@"%@://%@/",url.scheme,videoRoute]]) {
        
        return [self routeForTinyVideoDetailUrl:url];
    }
    else if ([originalUrl hasPrefix:[NSString stringWithFormat:@"%@://%@/",url.scheme,musicRoute]]) {
        
        return [self routeForMusicDetailUrl:url routeKey:musicRoute];
    }
    else if ([originalUrl hasPrefix:[NSString stringWithFormat:@"%@://%@/",url.scheme,foucusRoute]]) {
        
        return [self routeForCommonlUrl:url routeKey:foucusRoute paramkey:@"uid"];
    }
    else if ([originalUrl hasPrefix:[NSString stringWithFormat:@"%@://%@/",url.scheme,fansRoute]]) {
        
        return  [self routeForCommonlUrl:url routeKey:fansRoute paramkey:@"uid"];
    }
    else if ([originalUrl hasPrefix:[NSString stringWithFormat:@"%@://%@/",url.scheme,persionalRoute]]) {
        
        return [self routeForCommonlUrl:url routeKey:persionalRoute paramkey:@"uid"];
    }
    else if ([originalUrl hasPrefix:[NSString stringWithFormat:@"%@://%@/",url.scheme,segemntbRoute]]) {
        
        return [self routeForCommonlUrl:url routeKey:segemntbRoute paramkey:@"index"];
    }
    else if ([originalUrl hasPrefix:[NSString stringWithFormat:@"%@://%@/",url.scheme,msgRoute]]) {
        
        return [self routeForCommonlUrl:url routeKey:msgRoute paramkey:@"msgPageType"];
    }
    else if ([originalUrl hasPrefix:[NSString stringWithFormat:@"%@://%@/",url.scheme,recordRoute]]) {
        
        return [self routeForRecordUrl:url routeKey:recordRoute];
    }
    else {
        return originalUrl;
    }
    return originalUrl;
}
// h5
- (NSString *)routeForWebUrl:(NSURL *)routeURL {
    
    NSString *paramStr = [self regxOrginalString:routeURL.absoluteString regExpString:[NSString stringWithFormat:@"(%@://%@/)|(Url/)",routeURL.scheme,webRoute]];
    
    NSDictionary *paramsDic = [self getRouteParamDic:[paramStr componentsSeparatedByString:@"/"]
                                 oldRouteParamKeyArr:@[@"features",@"encodedURL"]];
    
    NSString *donerouteStr = [NSString stringWithFormat:@"sodamobile://Web/Features?%@",[self urlQueryString:paramsDic]];
    return donerouteStr;
}
// 视频播放页
- (NSString *)routeForTinyVideoDetailUrl:(NSURL *)routeURL {
    

    NSString *paramStr = [self regxOrginalString:routeURL.absoluteString regExpString:[NSString stringWithFormat:@"%@://%@/",routeURL.scheme,videoRoute]];
    
    NSDictionary *paramsDic = [self getRouteParamDic:[paramStr componentsSeparatedByString:@"/"]
                                 oldRouteParamKeyArr:@[@"resid",@"encodeVideoUrl",@"videoDPI",@"encodeSnapshotUrl"]];
    
    NSString *donerouteStr = [NSString stringWithFormat:@"sodamobile://ShortVideo/Detail?%@",[self urlQueryString:paramsDic]];
    return donerouteStr;
}

// 音乐集合页
- (NSString *)routeForMusicDetailUrl:(NSURL *)routeURL
                            routeKey:(NSString *)routeKey {
    
    NSString *paramStr = [self regxOrginalString:routeURL.absoluteString regExpString: [NSString stringWithFormat:@"(%@://%@/?)|(\\?.*)",routeURL.scheme,musicRoute]];
    NSString *donerouteStr = [NSString stringWithFormat:@"sodamobile://Shenqu/VT/D?topic=%@%@",paramStr,
                                                                                               (routeURL.query?[NSString stringWithFormat:@"&%@",routeURL.query]:@"")];
    return donerouteStr;
}

// 录制页
- (NSString *)routeForRecordUrl:(NSURL *)routeURL
                       routeKey:(NSString *)routeKey {
    
    NSString *paramStr = [self regxOrginalString:routeURL.absoluteString regExpString:[NSString stringWithFormat:@"(%@://%@/?)|(\\?.*)",routeURL.scheme,recordRoute]];
    
    if (!paramStr || [paramStr length] == 0) {
        
        return routeURL.absoluteString;
    }
    NSString *donerouteStr = [NSString stringWithFormat:@"sodamobile://TinyVideo/Record?topicName=%@%@",paramStr,
                                                                                                     (routeURL.query?[NSString stringWithFormat:@"&%@",routeURL.query]:@"")];
    return donerouteStr;
}

// 其它页
- (NSString *)routeForCommonlUrl:(NSURL *)routeURL
                        routeKey:(NSString *)routeKey
                        paramkey:(NSString *)paramkey {
    
    NSString *paramStr = [self regxOrginalString:routeURL.absoluteString
                                    regExpString:[NSString stringWithFormat:@"%@://%@/",routeURL.scheme,routeKey]];
    NSString *donerouteStr = [NSString stringWithFormat:@"%@://%@?%@=%@",routeURL.scheme,routeKey,paramkey,paramStr];
    return donerouteStr;
}

// 替换字符串
- (NSString *)regxOrginalString:(NSString *)orginalString
                   regExpString:(NSString *)regExpString {
    
    NSError *error ;

    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regExpString
                                                                                       options:0 error:&error];
    if (!error) {
        
        NSString *result  = [regularExpression stringByReplacingMatchesInString:orginalString
                                                                        options:0
                                                                          range:NSMakeRange(0, orginalString.length)
                                                                   withTemplate:@""];
        return result;
    }
    return nil;
}

// 拼接参数
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


@end
