//
//  YYURINavigationCenter+SODAAfter.m
//  YYRouteDemo
//
//  Created by A-Hing on 2018/4/14.
//  Copyright © 2018年 A-Hing. All rights reserved.
//

#import "YYURINavigationCenter+SODAAfter.h"
#import "NextViewController.h"

@implementation YYURINavigationCenter (SODAAfter)

- (void)gotoNext {
    
//    NextViewController *nextVC = [[NextViewController alloc] init];
//    //test
//    UINavigationController *currentVC = [YYURINavigationCenter currentVisiableRootViewController];
//    [currentVC pushViewController:nextVC animated:YES];
}

resignAction(SODASegmentAttention1, @[@"TinyVideo/nextVC"])
{
    [self gotoNext];
    return YES;
}

//sodamobile://ShortVideo/Detail?resid=${resid}&videoUrl=${encodeVideoUrl}&videoDPI=${videoDPI}&snapshotUrl=${encodeSnapshotUrl}&display=${displayPage}&commentId=${commentId}&commentedId=%d
// 视频播放页 评论页：新命令
resignAction(SODAShortVideoDetail1, (@[
                                       @"ShortVideo/Detail"
                                       ])) {
    
    [self gotoNext];
    return YES;
}

//视频播放页  ${scheme}://Shenqu/TinyVideo/Detail/${resid}/${encodeVideoUrl}[/${videoDPI}[/${encodeSnapshotUrl]]  // YYTVWatchViewController

resignAction(SODATinyVideoDetail1, (@[
                                     @"Shenqu/TinyVideo/Detail"
                                     ])) {
    [self gotoNext];
    return YES;
}

resignAction(SODARecordMachine1, (@[
                                    @"TinyVideo/Record"
                                    ]))
{
    [self gotoNext];
    return YES;
}

resignAction(SODAMsgCenterPage1, @[@"TinyVideo/MessageCenter"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAWebPushWeb1, @[@"Web/Features"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAPersonalCenterPersonalPage1, @[@"PersonalCenter"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAFollowsFollowersViewController1, @[@"PersonalCenter"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAFansFollowersViewController1, @[@"PersonalCenter"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODASegment1, @[@"TinyVideo/segmentIndex"])
{
    [self gotoNext];
    return YES;
}


resignAction(SODATinyVideoVTD1, @[@"TinyVideo/VT/D"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODATinyVideoVTDMuisc1, @[@"Shenqu/VT/D"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODACertify1, @[@"Certify"])
{
    [self gotoNext];
    return YES;
}

resignAction(SODAPushBindPhoneView1, @[@"pushBindPhoneView"])
{
    [self gotoNext];
    return YES;
}

@end
