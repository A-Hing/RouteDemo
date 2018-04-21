#import "YYRoute.h"

@implementation YYRoute

- (instancetype)initWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _destURL = url;
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        
        NSString *parametersString = [url query];
        if (parametersString && parametersString.length > 0) {
            NSArray *paramStringArr = [parametersString componentsSeparatedByString:@"&"];
            for (NSString *paramString in paramStringArr) {
                NSArray *paramArr = [paramString componentsSeparatedByString:@"="];
                if (paramArr.count > 1) {
                    NSString *key = [paramArr objectAtIndex:0];
                    NSString *value = [paramArr objectAtIndex:1];

                    if (key && value) {
                        [mDict setObject:value forKey:key];
                    }
                }
            }
        }
        
        self.parameters = mDict;
        
    }
    return self;
}

- (void)setParameters:(NSDictionary *)parameters
{
    if (!_parameters) {
        _parameters = [parameters copy];
    } else {
        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:_parameters];
        [mDict addEntriesFromDictionary:parameters];
        _parameters = [mDict copy];
    }
}

/**
 *  TODO: 回调URL的逻辑
 */


- (NSString *)description {
    return [NSString stringWithFormat:
            @"\n<%@ %p\n"
            @"\t URL: \"%@\"\n"
            @"\t routeParameters: \"%@\"\n"
            @"\t callbackURL: \"%@\"\n"
            @">",
            NSStringFromClass([self class]),
            self,
            [self.destURL description],
            self.parameters,
            [self.callbackURL description]];
}


#pragma mark - Parameter Retrieval via Object Subscripting

- (id)objectForKeyedSubscript:(NSString *)key {
    id value    = self.parameters[key];
    return value;
}


#pragma mark - Equality

- (BOOL)isEqual:(YYRoute *)object {
    
    if (self == object) {
        return YES;
    }
    else if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return (!self.destURL && !object.destURL) || [self.destURL isEqual:object.destURL];
}

- (NSUInteger)hash {
    return [self.destURL hash];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithURL:self.destURL];
}


@end
