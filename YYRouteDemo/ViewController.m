//
//  ViewController.m
//  YYRouteDemo
//
//  Created by A-Hing on 2018/1/29.
//  Copyright © 2018年 A-Hing. All rights reserved.
//

#import "ViewController.h"
#import "YYURINavigationCenter.h"
#import "ViewController+adapt1.h"
#import "ViewController+adapt2.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *oldrouteLabel1;
@property (weak, nonatomic) IBOutlet UILabel *oldrouteLabel2;
@property (weak, nonatomic) IBOutlet UILabel *oldrouteLabel3;

@property (weak, nonatomic) IBOutlet UILabel *newrouteLabel1;
@property (weak, nonatomic) IBOutlet UILabel *newrouteLabel2;
@property (weak, nonatomic) IBOutlet UILabel *newrouteLabel3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test];
//    [self regexMore];
//    [self regx];
    
}

- (void)regx {
   
    NSArray *arr = @[@"sodamobile://TinyVideo/Record",
                     @"sodamobile://TinyVideo/Record/拉春联?materialId=123&materialType=expression&resourceType=13",
                     @"sodamobile://TinyVideo/Record/作揖拜年?materialId=456&materialType=expression&resourceType=12",
                     @"sodamobile://TinyVideo/Record/今天谁买单?materialId=1368&materialType=expression&resourceType=11",
                     @"sodamobile://TinyVideo/Record?musicId=646&op=1&recordMode=0",
                     @"sodamobile://TinyVideo/Record/mtvdhdhhd?materialId=1141&materialType=effect&musicId=457&rsourceType=13&op=2",
                     @"sodamobile://TinyVideo/Record/财神作揖修改的话题?&musicId=457&op=1&from=banner",
                     @"sodamobile://Shenqu/VT/D/身体分离术",
                     @"sodamobile://Shenqu/VT/D/我们不一样remix?isMusic=1&singer=热心网友&musicId=594942",
                     ];
    


    // 替换
    for (NSString *orginalString in arr) {
        
        NSString *regExpString = @"(sodamobile://Shenqu/VT/D/?)|(\\?.*)";
        
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regExpString
                                                                                           options:0 error:nil];
        NSString *result  = [regularExpression stringByReplacingMatchesInString:orginalString
                                                                     options:0
                                                                       range:NSMakeRange(0, orginalString.length)
                                                                withTemplate:@""];
        NSLog(@"regx = %@",result);
    }

}

// 替换字符串
- (NSString *)regxOrginalString:(NSString *)orginalString
                   regExpString:(NSString *)regExpString {

    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regExpString
                                                                                       options:0 error:nil];
    NSString *result  = [regularExpression stringByReplacingMatchesInString:orginalString
                                                                    options:0
                                                                      range:NSMakeRange(0, orginalString.length)
                                                               withTemplate:@""];
    
    return result;
}


- (void)regexMore {
    
    NSArray *arr = @[@"sodamobile://TinyVideo/Record",
                     @"sodamobile://TinyVideo/Record/拉春联?materialId=123&materialType=expression&resourceType=13",
                     @"sodamobile://TinyVideo/Record/作揖拜年?materialId=456&materialType=expression&resourceType=12",
                     @"sodamobile://TinyVideo/Record/今天谁买单?materialId=1368&materialType=expression&resourceType=11",
                     @"sodamobile://TinyVideo/Record?musicId=646&op=1&recordMode=0",
                     @"sodamobile://TinyVideo/Record/mtvdhdhhd?materialId=1141&materialType=effect&musicId=457&rsourceType=13&op=2",
                     @"sodamobile://TinyVideo/Record/财神作揖修改的话题?&musicId=457&op=1&from=banner",
                     @"sodamobile://Shenqu/VT/D/身体分离术",
                     @"sodamobile://Shenqu/VT/D/我们不一样remix?isMusic=1&singer=热心网友&musicId=594942",
                     ];
    
    NSError *error ;
    
    for (NSString *orginalString in arr) {
        
//        NSString *regExpString = @"sodamobile://TinyVideo/Record/?|\?.*";
        NSString *regExpString = @"([^sodamobile://Shenqu/VT/D])(.*)(\\?.*)";
//        NSString *regExpString = @"\\-\\d*\\.";
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regExpString
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];

        if(!error) {
            
            NSTextCheckingResult *match = [regular firstMatchInString:orginalString options:0 range:NSMakeRange(0, orginalString.length)];
            
            if (match) {
                
                NSString *result = [orginalString substringWithRange:match.range];
                NSLog(@"result = %@",result);
            }
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取时间间隔

#define TICK   CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

//#define TOCK   printf("Time: %f\n", CFAbsoluteTimeGetCurrent() - start);
#define TOCK   NSLog(@"Time: %f\n", (CFAbsoluteTimeGetCurrent() - start) * 1000); //ms

#define TOCKDoule  CFAbsoluteTimeGetCurrent() - start;


- (IBAction)oldroute1:(id)sender {
    TICK
    
//    printf("\n %lf ==============start",CFAbsoluteTimeGetCurrent());
        [[YYURINavigationCenter sharedObject] handleURI:@"sodamobile://Shenqu/TinyVideo/Detail/9202122610407568630/http%3A%2F%2Fgodmusic.bs2dl.yy.com%2F1739268231BsdrJvyEAm15312007171339726AMRoQuCugm/536*960"
                                    fromViewController :nil
                                               animated:YES
                                               complete:^(YYRoute *route) {
    //                                               NSLog(@"route=%@",route);
                                               }];
    TOCK //Time: 0.002602
}
- (IBAction)oldroute2:(id)sender {
    TICK
    [[YYURINavigationCenter sharedObject] handleURI:@"sodamobile://PersonalCenter/2174334694"
                                fromViewController :nil
                                           animated:YES
                                           complete:^(YYRoute *route) {
                                               //                                               NSLog(@"route=%@",route);
                                           }];
    TOCK
}
- (IBAction)oldroute3:(id)sender {
    TICK
    [[YYURINavigationCenter sharedObject] handleURI:@"sodamobile://TinyVideo/Record/炫酷春联?materialId=100&materialType=expression&rsourceType=13"
                                fromViewController :nil
                                           animated:YES
                                           complete:^(YYRoute *route) {
                                               //                                               NSLog(@"route=%@",route);
                                           }];
    TOCK
}

- (IBAction)newroute1:(id)sender {
    
    TICK
    NSString *routeStr = @"sodamobile://Shenqu/TinyVideo/Detail/9202122610407568630/http%3A%2F%2Fgodmusic.bs2dl.yy.com%2F1739268231BsdrJvyEAm15312007171339726AMRoQuCugm/536*960";
    NSString *donerouteStr = [self ada_converOldURIToStandardURI:routeStr];
    
    [[YYURINavigationCenter sharedObject] new_handleURI:donerouteStr
                                fromViewController :nil
                                           animated:YES
                                           complete:^(YYRoute *route) {
                                           }];
    TOCK
    //Time: 0.000372
    
}
- (IBAction)newroute2:(id)sender {
    NSString *routeStr = @"sodamobile://TinyVideo/Record/作揖拜年?materialId=456&materialType=expression&resourceType=12";// sodamobile://TinyVideo/Record
    NSString *donerouteStr = [self ada_converOldURIToStandardURI:routeStr];
}
- (IBAction)newroute3:(id)sender {
    NSString *routeStr = @"sodamobile://Shenqu/VT/D/身体分离术";
    NSString *donerouteStr = [self ada_converOldURIToStandardURI:routeStr];
}


- (void)test {
    
    NSArray *testUrlS = @[@"sodamobile://Web/Features/5/Url/https%3A%2F%2Fmv.yy.com%2Fv2%2Fbattle%2F%3Fseason%3D5000%26roomId%3D0%26from%3Dh5+",
                         @"yymobile://Shenqu/TinyVideo/Detail/9184931920384505589/http%3A%2F%2Fgodmusic.bs2dl.yy.com%2FdmFjNzc1YzgzMTcxNGI4YTY4YWY5NDlmODljNWY2NTdmMTkxMTMyMjY1MTc/540*960",
                         @"sodamobile://ShortVideo/Detail?resid=9184931920384505589&videoUrl=http%3A%2F%2Fgodmusic.bs2dl.yy.com%2FdmFjNzc1YzgzMTcxNGI4YTY4YWY5NDlmODljNWY2NTdmMTkxMTMyMjY1MTc&videoDPI=540*960",
                         @"sodamobile://PersonalCenter/1675870591",
                         @"sodamobile://TinyVideo/MyUserPage/1675870591",
                         @"sodamobile://Shenqu/VT/D/身体分离术",
                         @"sodamobile://Shenqu/VT/D/我们不一样remix?isMusic=1&singer=热心网友&musicId=594942",
                         @"sodamobile://TinyVideo/Record",
                         @"sodamobile://TinyVideo/Record/拉春联?materialId=123&materialType=expression&resourceType=13",
                         @"sodamobile://TinyVideo/Record/作揖拜年?materialId=456&materialType=expression&resourceType=12",
                         @"sodamobile://TinyVideo/Record/今天谁买单?materialId=1368&materialType=expression&resourceType=11",
                         @"sodamobile://TinyVideo/Record?musicId=646&op=1&recordMode=0",
                         @"sodamobile://TinyVideo/Record/mtvdhdhhd?materialId=1141&materialType=effect&musicId=457&rsourceType=13&op=2",
                         @"sodamobile://TinyVideo/Record/财神作揖修改的话题?&musicId=457&op=1&from=banner",
                         @"sodamobile://PersonalCenter/focus/1675870591",
                         @"sodamobile://PersonalCenter/fans/1675870591",
                         @"sodamobile://TinyVideo/MessageCenter/0",
                         @"sodamobile://TinyVideo/segmentIndex/2",
                         @"sodamobile://Certify"
                         ];
    for (NSString *testUrl in testUrlS) {
        NSString *doneStr = [self ada_converOldURIToStandardURI:testUrl];
        NSLog(@"============");
        NSLog(@"or:--> %@\n do:---> %@\n",testUrl,doneStr);
        NSLog(@"============");
    }
}


/**
 *  @brief  将NSDictionary转换成url 参数字符串
 *
 *  @return url 参数字符串
 */

- (NSString *)urlQueryString:(NSDictionary *)dic {
    
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in dic) {
        NSString *value = [dic objectForKey:key];
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    return [array componentsJoinedByString:@"&"];
}

@end















