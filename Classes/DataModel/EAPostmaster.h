//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

@import Foundation;
#import "EAMultipeerManager.h"
#import "EAContact.h"

@protocol EAPostmasterDelegate;

@interface EAPostmaster : NSObject <EAMultipeerManagerDelegate>

@property (nonatomic, strong, readonly) NSString *localContactId;
@property (nonatomic, strong, readonly) NSArray *onlineContacts;
@property (nonatomic, strong, readonly) NSArray *offlineContacts;
@property (nonatomic, weak) id<EAPostmasterDelegate> delegate;

// singleton logic
+ (instancetype)sharedInstance;
+ (instancetype)alloc __attribute__((unavailable("call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("call sharedInstance instead")));

- (void)startWorking;
- (void)stopWorking;

- (void)deleteContact:(EAContact *)contact;

@end

@protocol EAPostmasterDelegate <NSObject>

- (void)postmaster:(EAPostmaster *)postmaster foundPeer:(EAContact *)contact;
- (void)postmaster:(EAPostmaster *)postmaster lostPeer:(EAContact *)contact;
- (void)postmaster:(EAPostmaster *)postmaster recievedMessage:(NSString *)message fromPeer:(EAContact *)contact;

@end
