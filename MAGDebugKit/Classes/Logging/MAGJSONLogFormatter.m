#import "MAGJSONLogFormatter.h"


@interface MAGJSONLogFormatter () {
	NSMutableDictionary <NSString *, id> *_permanentFields;
}
@property (atomic) dispatch_queue_t accessQueue;

@end


@implementation MAGJSONLogFormatter

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}

	_permanentFields = [[NSMutableDictionary alloc] init];
	_accessQueue = dispatch_queue_create(
		"MAGDebugKit.MAGJSONLogFormatter.PermanentValuesAccessQueue",
		DISPATCH_QUEUE_CONCURRENT);

	return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	NSMutableDictionary *map = [[NSMutableDictionary alloc] initWithDictionary:@{
			@"date": @(logMessage->_timestamp.timeIntervalSince1970),
			@"message": logMessage->_message,
			@"source": [NSString stringWithFormat:@"%@:%@ %@",
				logMessage->_fileName, @(logMessage->_line), logMessage->_function],
			@"context": @(logMessage->_context),
			@"level": levelString(logMessage->_flag),
		}];

    if (logMessage.tag) {
        map[@"payload"] = logMessage.tag;
    }

	dispatch_sync(self.accessQueue, ^{
		[map addEntriesFromDictionary:_permanentFields];
	});

	NSData *data = [NSJSONSerialization dataWithJSONObject:map options:0 error:nil];
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	string = [string stringByAppendingString:@"\n"];
	
    return string;
}

- (void)setPermanentLogValue:(id)value field:(NSString *)field {
	dispatch_barrier_async(self.accessQueue, ^{
		self->_permanentFields[field] = value;
	});
}


static NSString *levelString(DDLogFlag level) {
	static NSDictionary *levels = nil;
	if (!levels) {
		levels = @{
				@(DDLogFlagError): @"Error",
				@(DDLogFlagWarning): @"Warning",
				@(DDLogFlagInfo): @"Info",
				@(DDLogFlagDebug): @"Debug",
				@(DDLogFlagVerbose): @"Verbose",
			};
	}
	
	NSString *string = levels[@(level)];
	if (!string) {
		string = @"";
	}
	
	return string;
}

@end
