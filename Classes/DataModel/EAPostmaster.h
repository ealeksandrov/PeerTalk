//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

@import Foundation;
#import "EAMultipeerManager.h"

@protocol EAPostmasterDelegate;

@interface EAPostmaster : NSObject <EAMultipeerManagerDelegate>

@property (nonatomic, strong, readonly) NSString *localContactId;
@property (nonatomic, strong, readonly) NSArray *discoveredContacts;
@property (nonatomic, weak) id<EAPostmasterDelegate> delegate;

// singleton logic
+ (instancetype)sharedInstance;
+ (instancetype)alloc __attribute__((unavailable("call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("call sharedInstance instead")));

- (void)startWorking;
- (void)stopWorking;

@end

@protocol EAPostmasterDelegate <NSObject>

- (void)postmaster:(EAPostmaster *)postmaster foundPeerWithId:(NSString *)contactId;
- (void)postmaster:(EAPostmaster *)postmaster lostPeerWithId:(NSString *)contactId;
- (void)postmaster:(EAPostmaster *)postmaster recievedMessage:(NSString *)message fromPeerWithId:(NSString *)contactId;

@end
