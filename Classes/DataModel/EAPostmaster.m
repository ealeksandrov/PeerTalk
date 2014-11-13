//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import "EAPostmaster.h"

#import "EALogging.h"
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+Actions.h>
#import "EAMessage.h"

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
        DDLogError(@"NEW UDID HERE");
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

- (NSArray *)onlineContacts {
    return [EAContact MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"%K in %@", contactIdKey, [self onlineContactsIds]]];
}

- (NSArray *)offlineContacts {
    return [EAContact MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"NOT %K in %@", contactIdKey, [self onlineContactsIds]]];
}

#pragma mark -

- (NSArray *)onlineContactsIds {
    NSMutableArray *mutableOnlineContactsIds = [NSMutableArray array];
    for (NSDictionary *dict in self.manager.discoveredItems) {
        [mutableOnlineContactsIds addObject:[dict objectForKey:contactIdKey]];
    }
    
    return [mutableOnlineContactsIds copy];
}

- (void)sendMessage:(NSString *)messageStr toContactWithId:(NSString *)contactId {
    
}

- (void)deleteContact:(EAContact *)contact {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        [contact MR_deleteEntityInContext:localContext];
#warning delete all related messages here
    }];
}

#pragma mark - EAMultipeerManager delegate

- (void)manager:(EAMultipeerManager *)manager foundPeerWithId:(NSString *)contactId {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        EAContact *newPeer = [EAContact MR_findFirstByAttribute:contactIdKey withValue:contactId inContext:localContext];
        if(!newPeer) {
            newPeer = [EAContact MR_createEntityInContext:localContext];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", contactIdKey, contactId];
        NSDictionary *dictForSearch = [[self.manager.discoveredItems filteredArrayUsingPredicate:predicate] firstObject];
        
        newPeer.contactId = contactId;
        newPeer.displayName = [dictForSearch objectForKey:displayNameKey];
    }];
    
    [self.delegate postmaster:self foundPeer:[EAContact MR_findFirstByAttribute:contactIdKey withValue:contactId]];
}

- (void)manager:(EAMultipeerManager *)manager lostPeerWithId:(NSString *)contactId {
    [self.delegate postmaster:self lostPeer:[EAContact MR_findFirstByAttribute:contactIdKey withValue:contactId]];
}

- (void)manager:(EAMultipeerManager *)manager recievedMessage:(NSString *)message fromPeerWithId:(NSString *)contactId {
    [self.delegate postmaster:self recievedMessage:message fromPeer:[EAContact MR_findFirstByAttribute:contactIdKey withValue:contactId]];
}

@end
