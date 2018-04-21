#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYRoute : NSObject <NSCopying>


- (instancetype)initWithURL:(NSURL *)url;

@property (nonatomic, copy, readonly) NSURL *destURL;

@property (nonatomic, copy) NSDictionary *parameters;

@property (nonatomic, strong) NSDictionary *info;

@property (nonatomic, strong) UIViewController *viewController;

/**
 *  回调地址
 */
@property (nonatomic, strong) NSURL *callbackURL;

- (id)objectForKeyedSubscript:(NSString *)key;

@end
