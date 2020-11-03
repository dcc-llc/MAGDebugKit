#import <CocoaLumberjack/CocoaLumberjack.h>


@interface MAGRemoteLogger : DDAbstractLogger

@property(nonatomic, readonly) NSString *host;
@property(nonatomic, readonly) NSUInteger port;

- (instancetype)initWithHost:(NSString *)host port:(NSUInteger)port;

@end
