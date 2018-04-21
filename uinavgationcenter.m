resignAction(SODASegmentAttention1, @[@"Shenqu/TinyVideo/Detail/:topic/:hello/:dpi"])
{
    NextViewController *nextVC = [[NextViewController alloc] init];
    //test
    UINavigationController *currentVC = [YYURINavigationCenter currentVisiableRootViewController];
    [currentVC pushViewController:nextVC animated:YES];
    return YES;
}
//=====================1  编辑前生成方法=====
// 1、resignURI(t) 
// 2、goto(t)
// 3、utriLis = @[@"Shenqu/TinyVideo/Detail/:topic/:hello/:dpi"]

-(void)_UriNavigationCenterResignSODASegmentAttention1 { 

    YYRouteHandlerBlock block = ^BOOL (YYRoute *route){ 

        UIViewController* vc = route.parameters[@"YYURIViewControllerKey"]; 
        NSNumber* isGetter = route.parameters[@"YYURIActionForGetViewControllerKey"]; 
        if (isGetter.boolValue) { 
            do {} while (0); 
            return __objc_no; 
            } 
        NSNumber* animation = route.parameters[@"YYURIAnimationKey"]; 
        return [self gotoSODASegmentAttention1:route.parameters fromViewController:vc animation:animation.boolValue]; 
    }; 
    [[YYRouteManager defaultManager] setObject:block forKeyedListSubscript:@[@"Shenqu/TinyVideo/Detail/:topic/:hello/:dpi"]]; 
}
//   obj : block  key: NSString *key in utriLis
-(BOOL)gotoSODASegmentAttention1:(NSDictionary *)userInfo fromViewController:(UIViewController*)viewController animation:(BOOL)animated
{
    NextViewController *nextVC = [[NextViewController alloc] init];
    UINavigationController *currentVC = [YYURINavigationCenter currentVisiableRootViewController];
    [currentVC pushViewController:nextVC animated:__objc_yes];
    return __objc_yes;
}

//=====================2  初始化生成方法 ，注册对应路由=====

registerURI(SODASegmentAttention)
registerURI(SODASegmentAttention1)

 [[YYURINavigationCenter sharedObject] performSelector:@selector(_UriNavigationCenterResignSODASegmentAttention)];
 [[YYURINavigationCenter sharedObject] performSelector:@selector(_UriNavigationCenterResignSODASegmentAttention1)];

//=====================3  调用路由方法 =====

    [[YYURINavigationCenter sharedObject] handleURI:@"sodamobile://Shenqu/TinyVideo/Detail/9202122610407568630/http%3A%2F%2Fgodmusic.bs2dl.yy.com%2F1739268231BsdrJvyEAm15312007171339726AMRoQuCugm/536*960?display=commentList" fromViewController :nil];

//  3-1、YYRouteManager


