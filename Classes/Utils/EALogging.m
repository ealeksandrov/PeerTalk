//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import "EALogging.h"
#import "LogFormatter.h"

#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>

@implementation EALogging

+ (void)configureLumberjack {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    LogFormatter *formatter = [[LogFormatter alloc] init];
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
}

@end
