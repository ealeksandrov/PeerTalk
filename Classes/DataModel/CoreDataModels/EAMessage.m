#import "EAMessage.h"
#import "EAContact.h"
#import "EAPostmaster.h"

@interface EAMessage ()

// Private interface goes here.

@end

@implementation EAMessage

// Custom logic goes here.

#warning Bad style, strong coupling
#pragma mark - JSQMessageData

- (NSString *)senderId {
    if(self.isRecieved) {
        return self.contact.contactId;
    } else {
        return [EAPostmaster sharedInstance].localContactId;
    }
}

- (NSString *)senderDisplayName {
    if(self.isRecieved) {
        return self.contact.displayName;
    } else {
        return @"Me";
    }
}

- (BOOL)isMediaMessage {
    return NO;
}

- (NSString *)text {
    return self.message;
}

- (NSDate *)date {
    return self.time;
}

@end
