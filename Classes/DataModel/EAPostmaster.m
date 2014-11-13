//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import "EAPostmaster.h"
#import <MagicalRecord/MagicalRecord.h>

static NSString * const localContactIdKey = @"localContactId";

@interface EAPostmaster ()

@property (nonatomic, strong) NSString *localContactId;
@property (nonatomic, strong) EAMultipeerManager *manager;

@end

@implementation EAPostmaster

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
    self.localContactId = [[NSUserDefaults standardUserDefaults] valueForKey:localContactIdKey];
    if(!self.localContactId) {
        self.localContactId = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setValue:self.localContactId forKey:localContactIdKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.manager = [EAMultipeerManager sharedInstance];
    self.manager.localContactId = self.localContactId;
    self.manager.delegate = self;
    
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupAutoMigratingStack];
    
    return [super init];
}

#pragma mark - 

- (void)startWorking {
    [self.manager startConnectivity];
}

- (void)stopWorking {
    [self.manager stopConnectivity];
}

- (NSArray *)discoveredContacts {
    return [self.manager.discoveredItems copy];
}

#pragma mark - 

- (void)sendMessage:(NSString *)messageStr toContactWithId:(NSString *)contactId {
    
}

#pragma mark - EAMultipeerManager delegate

- (void)manager:(EAMultipeerManager *)manager foundPeerWithId:(NSString *)contactId {
    [self.delegate postmaster:self foundPeerWithId:contactId];
}

- (void)manager:(EAMultipeerManager *)manager lostPeerWithId:(NSString *)contactId {
    [self.delegate postmaster:self lostPeerWithId:contactId];
}

- (void)manager:(EAMultipeerManager *)manager recievedMessage:(NSString *)message fromPeerWithId:(NSString *)contactId {
    [self.delegate postmaster:self recievedMessage:message fromPeerWithId:contactId];
}

@end
