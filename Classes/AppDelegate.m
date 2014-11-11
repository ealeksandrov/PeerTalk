//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import "AppDelegate.h"
#import "EALogging.h"
#import "EARouter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [EALogging configureLumberjack];
    
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *bundleShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    DDLogInfo(@"Starting %@ v%@ (%@)", bundleId, bundleShortVersion, bundleVersion);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:[EARouter sharedInstance].rootVC];
    [self.window makeKeyAndVisible];
    
    return YES;
}
@end
