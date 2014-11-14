// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EAMessage.m instead.

#import "_EAMessage.h"

const struct EAMessageAttributes EAMessageAttributes = {
	.message = @"message",
	.messageId = @"messageId",
	.senderId = @"senderId",
	.time = @"time",
};

const struct EAMessageRelationships EAMessageRelationships = {
	.contact = @"contact",
};

@implementation EAMessageID
@end

@implementation _EAMessage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EAMessage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EAMessage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EAMessage" inManagedObjectContext:moc_];
}

- (EAMessageID*)objectID {
	return (EAMessageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic message;

@dynamic messageId;

@dynamic senderId;

@dynamic time;

@dynamic contact;

@end

