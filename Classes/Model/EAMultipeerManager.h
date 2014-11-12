//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

@import Foundation;
@import MultipeerConnectivity;

@protocol EAMultipeerManagerDelegate;

@interface EAMultipeerManager : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong, readonly) NSArray *discoveredItems;
@property (nonatomic, strong) NSString *localContactId;
@property (nonatomic, weak) id<EAMultipeerManagerDelegate> delegate;

// singleton logic
+ (instancetype)sharedInstance;
+ (instancetype)alloc __attribute__((unavailable("call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("call sharedInstance instead")));

- (void)startConnectivity;
- (void)stopConnectivity;

- (void)sendMessage:(NSString *)message toContactWithId:(NSString *)contactId;
- (void)connectContactWithId:(NSString *)contactId;
- (void)disconnectContactWithId:(NSString *)contactId;

@end

@protocol EAMultipeerManagerDelegate <NSObject>

- (void)manager:(EAMultipeerManager *)manager foundPeerWithId:(NSString *)contactId;
- (void)manager:(EAMultipeerManager *)manager lostPeerWithId:(NSString *)contactId;
- (void)manager:(EAMultipeerManager *)manager recievedMessage:(NSString *)message fromPeerWithId:(NSString *)contactId;

@end
