//
//  YYURINavigationCenter+SODAPersonal.m
//  Soda
//
//  Created by A-Hing on 2018/1/5.
//  Copyright © 2018年 yy.inc. All rights reserved.
//

#import "YYURINavigationCenter+SODAPersonal.h"
#import "NextViewController.h"

@implementation YYURINavigationCenter (SODAPersonal)

- (void)gotoNext {
    
    
//    NextViewController *nextVC = [[NextViewController alloc] init];
//    //test
//    UINavigationController *currentVC = [YYURINavigationCenter currentVisiableRootViewController];
//    [currentVC pushViewController:nextVC animated:YES];
}

resignAction(SODASegmentAttention, @[@"TinyVideo/nextVC/:uid"])
{
    [self gotoNext];
    return YES;
}

//sodamobile://ShortVideo/Detail?resid=${resid}&videoUrl=${encodeVideoUrl}&videoDPI=${videoDPI}&snapshotUrl=${encodeSnapshotUrl}&display=${displayPage}&commentId=${commentId}&commentedId=%d
// 视频播放页 评论页：新命令
resignAction(SODAShortVideoDetail, (@[@"ShortVideo/Detail"])) {
    
    [self gotoNext];
    return YES;
}

//视频播放页  ${scheme}://Shenqu/TinyVideo/Detail/${resid}/${encodeVideoUrl}[/${videoDPI}[/${encodeSnapshotUrl]]  // YYTVWatchViewController

resignAction(SODATinyVideoDetail, (@[
                                     @"Shenqu/TinyVideo/Detail/:resid",
                                     @"Shenqu/TinyVideo/Detail/:resid/:encodeVideoUrl",  //固定
                                     @"Shenqu/TinyVideo/Detail/:resid/:encodeVideoUrl/:videoDPI",
                                     @"Shenqu/TinyVideo/Detail/:resid/:encodeVideoUrl/:videoDPI/:encodeSnapshotUrl"
                                     ])) {
//    NSLog(@"userInfo:%@",userInfo);
    [self gotoNext];
    return YES;
}

resignAction(SODARecordMachine, (@[@"TinyVideo/Record",
                                   @"TinyVideo/Record/:topicName",
                                   @"TinyVideo/Record/:topicName/:otherurl",
                                   @"TinyVideo/Record/:topicName/:otherurl/:fromReport",
                                   @"TinyVideo/Record/:topicName/:materialId/:materialType/:resourceType"]))
{
    [self gotoNext];
    return YES;
}

resignAction(SODAMsgCenterPage, @[@"TinyVideo/MessageCenter/:msgPageType"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAWebPushWeb, @[@"Web/Features/:features/Url/:encodedURL"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAPersonalCenterPersonalPage, @[@"PersonalCenter/:uid"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAFollowsFollowersViewController, @[@"PersonalCenter/focus/:uid"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAFansFollowersViewController, @[@"PersonalCenter/fans/:uid"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODASegment, @[@"TinyVideo/segmentIndex/:index"])
{
    [self gotoNext];
    return YES;
}


resignAction(SODATinyVideoVTD, @[@"TinyVideo/VT/D/:musicId/:topic/:singer"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODATinyVideoVTDMuisc, @[@"Shenqu/VT/D/:topic"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODACertify, @[@"Certify"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAPushBindPhoneView, @[@"pushBindPhoneView"])
{
    [self gotoNext];
    return YES;
}

+ (UINavigationController*) currentVisiableRootViewController {
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UINavigationController *vc = (UINavigationController *)[topWindow rootViewController];
    return vc;
}


//.quad    "-[YYURINavigationCenter(SODAPersonal) _UriNavigationCenterResignSODASegmentAttention]"
//.quad    "-[YYURINavigationCenter(SODAPersonal) gotoSODASegmentAttention:fromViewController:animation:]"
//.quad    "-[YYURINavigationCenter(SODAPersonal) _UriNavigationCenterResignSODASegmentAttention1]"
//.quad    "-[YYURINavigationCenter(SODAPersonal) gotoSODASegmentAttention1:fromViewController:animation:]"

@end
