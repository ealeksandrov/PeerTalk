// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EAContact.h instead.

#import <CoreData/CoreData.h>

extern const struct EAContactAttributes {
	__unsafe_unretained NSString *contactId;
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *lastDeliveredMsgID;
	__unsafe_unretained NSString *lastReadMsgID;
} EAContactAttributes;

extern const struct EAContactRelationships {
	__unsafe_unretained NSString *messages;
} EAContactRelationships;

@class EAMessage;

@interface EAContactID : NSManagedObjectID {}
@end

@interface _EAContact : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EAContactID* objectID;

@property (nonatomic, strong) NSString* contactId;

//- (BOOL)validateContactId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastDeliveredMsgID;

//- (BOOL)validateLastDeliveredMsgID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastReadMsgID;

//- (BOOL)validateLastReadMsgID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *messages;

- (NSMutableSet*)messagesSet;

@end

@interface _EAContact (MessagesCoreDataGeneratedAccessors)
- (void)addMessages:(NSSet*)value_;
- (void)removeMessages:(NSSet*)value_;
- (void)addMessagesObject:(EAMessage*)value_;
- (void)removeMessagesObject:(EAMessage*)value_;

@end

@interface _EAContact (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContactId;
- (void)setPrimitiveContactId:(NSString*)value;

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveLastDeliveredMsgID;
- (void)setPrimitiveLastDeliveredMsgID:(NSString*)value;

- (NSString*)primitiveLastReadMsgID;
- (void)setPrimitiveLastReadMsgID:(NSString*)value;

- (NSMutableSet*)primitiveMessages;
- (void)setPrimitiveMessages:(NSMutableSet*)value;

@end
