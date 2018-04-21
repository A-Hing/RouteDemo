#import <Foundation/Foundation.h>
#import "YYRoute.h"

@interface YYRouteMatcher : NSObject
@property (nonatomic, readonly) NSString  *route;

+ (instancetype)matcherWithPath:(NSString *)path;

- (BOOL)matchRoute:(YYRoute *)route;

@end
