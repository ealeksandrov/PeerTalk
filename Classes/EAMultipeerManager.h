//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

@import Foundation;
@import MultipeerConnectivity;

@interface EAMultipeerManager : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

// singleton logic
+ (instancetype)sharedInstance;
+ (instancetype)alloc __attribute__((unavailable("call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("call sharedInstance instead")));

- (void)testConnectivity;

@end
