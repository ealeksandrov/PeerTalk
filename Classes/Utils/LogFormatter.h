//  Copyright (c) 2013 Evgeny Aleksandrov. All rights reserved.

#import <CocoaLumberjack/DDLog.h>

@interface LogFormatter : NSObject <DDLogFormatter> {
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

@end
