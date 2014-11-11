//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import "EAMultipeerManager.h"
#import "EARouter.h"

#import <BlocksKit/UIActionSheet+BlocksKit.h>

static NSString * const peerTalkServiceType = @"ptalk-service";

@interface EAMultipeerManager () {
    MCPeerID *localPeerID;
    MCSession *session;
    MCNearbyServiceBrowser *browser;
    MCNearbyServiceAdvertiser *advertiser;
}

@property (nonatomic, strong) NSMutableArray *mutableBlockedPeers;

@end

@implementation EAMultipeerManager

#pragma mark - Singleton logic

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype)initUniqueInstance {
    return [super init];
}

#pragma mark - Actions

- (void)testConnectivity {
    localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:localPeerID
                                                   discoveryInfo:nil
                                                     serviceType:peerTalkServiceType];
    
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
    
    browser = [[MCNearbyServiceBrowser alloc] initWithPeer:localPeerID serviceType:peerTalkServiceType];
    browser.delegate = self;
    [browser startBrowsingForPeers];
}

#pragma mark - MCSessionDelegate

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

#pragma mark MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler {
        if ([self.mutableBlockedPeers containsObject:peerID]) {
            invitationHandler(NO, nil);
            return;
        }
        
        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Received Invitation from %@", @"Received Invitation from {Peer}"), peerID.displayName]];
        
        [actionSheet bk_setCancelButtonWithTitle:@"Reject" handler:nil];
        
        [actionSheet bk_setDestructiveButtonWithTitle:@"Block" handler:^{
            [self.mutableBlockedPeers addObject:peerID];
        }];
        
        [actionSheet bk_addButtonWithTitle:@"Accept" handler:^{
            session = [[MCSession alloc] initWithPeer:localPeerID
                                     securityIdentity:nil
                                 encryptionPreference:MCEncryptionNone];
            session.delegate = self;
            invitationHandler(YES, session);
        }];
        
        [actionSheet showInView:[EARouter sharedInstance].rootVC.view];
}

// Advertising did not start due to an error
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    
}

#pragma mark MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
}

// Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    
}

@end
