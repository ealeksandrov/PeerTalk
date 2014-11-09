//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import <CocoaLumberjack/DDLog.h>

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface EALogging : NSObject

+ (void)configureLumberjack;

@end
