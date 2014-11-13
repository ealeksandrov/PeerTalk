// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EAMessage.m instead.

#import "_EAMessage.h"

const struct EAMessageAttributes EAMessageAttributes = {
	.isRecieved = @"isRecieved",
	.message = @"message",
	.messageId = @"messageId",
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

	if ([key isEqualToString:@"isRecievedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isRecieved"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic isRecieved;

- (BOOL)isRecievedValue {
	NSNumber *result = [self isRecieved];
	return [result boolValue];
}

- (void)setIsRecievedValue:(BOOL)value_ {
	[self setIsRecieved:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsRecievedValue {
	NSNumber *result = [self primitiveIsRecieved];
	return [result boolValue];
}

- (void)setPrimitiveIsRecievedValue:(BOOL)value_ {
	[self setPrimitiveIsRecieved:[NSNumber numberWithBool:value_]];
}

@dynamic message;

@dynamic messageId;

@dynamic time;

@dynamic contact;

@end

