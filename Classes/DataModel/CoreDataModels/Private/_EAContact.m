// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EAContact.m instead.

#import "_EAContact.h"

const struct EAContactAttributes EAContactAttributes = {
	.contactId = @"contactId",
	.displayName = @"displayName",
	.lastDeliveredMsgID = @"lastDeliveredMsgID",
	.lastReadMsgID = @"lastReadMsgID",
};

const struct EAContactRelationships EAContactRelationships = {
	.messages = @"messages",
};

@implementation EAContactID
@end

@implementation _EAContact

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EAContact" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EAContact";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EAContact" inManagedObjectContext:moc_];
}

- (EAContactID*)objectID {
	return (EAContactID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic contactId;

@dynamic displayName;

@dynamic lastDeliveredMsgID;

@dynamic lastReadMsgID;

@dynamic messages;

- (NSMutableSet*)messagesSet {
	[self willAccessValueForKey:@"messages"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"messages"];

	[self didAccessValueForKey:@"messages"];
	return result;
}

@end

