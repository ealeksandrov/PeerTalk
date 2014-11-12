//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import "EAMultipeerManager.h"
#import "EALogging.h"

static NSString * const peerTalkServiceType = @"ptalk-service";

@interface EAMultipeerManager () {
    MCPeerID *localPeerID;
    MCNearbyServiceBrowser *_browser;
    MCNearbyServiceAdvertiser *_advertiser;
    
    // key is contactId
    NSMutableDictionary *peerIds;
    NSMutableDictionary *sessions;
}

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
    peerIds = [NSMutableDictionary dictionary];
    sessions = [NSMutableDictionary dictionary];
    
    return [super init];
}

#pragma mark - Actions

- (void)testConnectivity {
    localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    NSString *localContactId = [[NSUUID UUID] UUIDString];
    _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:localPeerID
                                                    discoveryInfo:@{@"contactId" : localContactId}
                                                      serviceType:peerTalkServiceType];
    _advertiser.delegate = self;
    [_advertiser startAdvertisingPeer];
    
    _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:localPeerID serviceType:peerTalkServiceType];
    _browser.delegate = self;
    [_browser startBrowsingForPeers];
}

- (void)sendMessage:(NSString *)message toContactWithId:(NSString *)contactId {
    NSData *dataToSend = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    MCPeerID *peerID = [peerIds objectForKey:contactId];
    if(!peerID) {
        return;
    }
    
    MCSession *session = [self sessionForContactId:contactId];
    if(!session) {
        return;
    }
    
    NSError *error;
    
    [session sendData:dataToSend toPeers:@[peerID] withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        DDLogError(@"Send message error: %@", [error localizedDescription]);
    }
}

- (void)connectContactWithId:(NSString *)contactId {
    MCPeerID *peerID = [peerIds objectForKey:contactId];
    if(!peerID) {
        return;
    }
    
    MCSession *session = [self sessionForContactId:contactId];
    if(!session) {
        return;
    }
    
    [_browser invitePeer:peerID toSession:session withContext:nil timeout:0];
}

- (void)disconnectContactWithId:(NSString *)contactId {
    MCPeerID *peerID = [peerIds objectForKey:contactId];
    if(!peerID) {
        return;
    }
    
    MCSession *session = [self sessionForContactId:contactId];
    if(!session) {
        return;
    }
    
    [self closeSessionForContactId:contactId];
}

- (NSArray *)discoveredItems {
    NSMutableArray *mutableItems = [NSMutableArray arrayWithCapacity:[peerIds count]];
    for (NSString *contactId in peerIds) {
        MCPeerID *peerID = [peerIds objectForKey:contactId];
        [mutableItems addObject:@{@"contactId" : contactId, @"displayName" : peerID.displayName}];
    }
    return [mutableItems copy];
}

#pragma mark - Private actions

- (NSString *)contactIdForPeer:(MCPeerID *)peerID {
    return [[peerIds allKeysForObject:peerID] firstObject];
}

- (void)peerFound:(MCPeerID *)peerID forContactId:(NSString *)contactId {
    if([peerIds objectForKey:contactId]) {
        [self peerLostWithContactId:contactId];
    }
    [peerIds setObject:peerID forKey:contactId];
    
    if(self.delegate) {
        [self.delegate manager:self foundPeerWithId:contactId];
    }
}

- (void)peerLostWithContactId:(NSString *)contactId {
    if(![peerIds objectForKey:contactId]) {
        return;
    }
    [peerIds removeObjectForKey:contactId];
    [self closeSessionForContactId:contactId];
    
    if(self.delegate) {
        [self.delegate manager:self lostPeerWithId:contactId];
    }
}

- (MCSession *)sessionForContactId:(NSString *)contactId {
    if (![sessions objectForKey:contactId]) {
        [self openSessionForContactId:contactId];
    }
    return [sessions objectForKey:contactId];
}

- (void)openSessionForContactId:(NSString *)contactId {
    MCSession *session = [[MCSession alloc] initWithPeer:localPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    session.delegate = self;
    
    [sessions setObject:session forKey:contactId];
}

- (void)closeSessionForContactId:(NSString *)contactId {
    MCSession *session = [self sessionForContactId:contactId];
    if(!session) {
        return;
    }
    
    [session disconnect];
    [sessions removeObjectForKey:contactId];
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    DDLogInfo(@"Peer changed state: %@ to %ld", peerID, (long)state);
    
    NSString *contactId = [self contactIdForPeer:peerID];
    if(!contactId) {
        return;
    }
    
    MCSession *_session = [sessions objectForKey:contactId];
    if(!_session || _session != session) {
        return;
    }
    
    if(state == MCSessionStateNotConnected) {
        [self closeSessionForContactId:contactId];
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DDLogInfo(@"Data recieved: %@", message);
    
    if(self.delegate) {
        [self.delegate manager:self recievedMessage:message fromPeerWithId:[self contactIdForPeer:peerID]];
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    // Received a byte stream from remote peer
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    // Start receiving a resource from remote peer
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
}

#pragma mark MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler {
    DDLogInfo(@"Advertiser recieved invite from: %@",peerID);
    
    if(![peerIds objectForKey:[self contactIdForPeer:peerID]]) {
        DDLogError(@"Peer is not yet discovered, reject and wait for browser");
        invitationHandler(NO, nil);
        return;
    }
    
    MCSession *session = [self sessionForContactId:[self contactIdForPeer:peerID]];
    
    invitationHandler(session != nil, session);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    DDLogError(@"Advertiser error: %@",error);
}

#pragma mark MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSString *contactId = info[@"contactId"];
    if (!contactId) {
        return;
    }
    
    DDLogInfo(@"Found peer: %@ %@",peerID,info);
    [self peerFound:peerID forContactId:contactId];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    DDLogInfo(@"Lost peer: %@",peerID);
    
    [self peerLostWithContactId:[self contactIdForPeer:peerID]];
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    DDLogError(@"Browser error: %@",error);
}

@end
