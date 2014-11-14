#import "EAMessage.h"
#import "EAContact.h"

@interface EAMessage ()

// Private interface goes here.

@end

@implementation EAMessage

// Custom logic goes here.

#pragma mark - JSQMessageData

- (NSString *)senderDisplayName {
    if(self.contact.contactId == self.senderId) {
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
