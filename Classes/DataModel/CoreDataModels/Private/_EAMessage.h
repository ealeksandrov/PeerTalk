// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EAMessage.h instead.

#import <CoreData/CoreData.h>

extern const struct EAMessageAttributes {
	__unsafe_unretained NSString *isRecieved;
	__unsafe_unretained NSString *message;
	__unsafe_unretained NSString *messageId;
	__unsafe_unretained NSString *time;
} EAMessageAttributes;

extern const struct EAMessageRelationships {
	__unsafe_unretained NSString *contact;
} EAMessageRelationships;

@class EAContact;

@interface EAMessageID : NSManagedObjectID {}
@end

@interface _EAMessage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EAMessageID* objectID;

@property (nonatomic, strong) NSNumber* isRecieved;

@property (atomic) BOOL isRecievedValue;
- (BOOL)isRecievedValue;
- (void)setIsRecievedValue:(BOOL)value_;

//- (BOOL)validateIsRecieved:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* message;

//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* messageId;

//- (BOOL)validateMessageId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* time;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) EAContact *contact;

//- (BOOL)validateContact:(id*)value_ error:(NSError**)error_;

@end

@interface _EAMessage (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIsRecieved;
- (void)setPrimitiveIsRecieved:(NSNumber*)value;

- (BOOL)primitiveIsRecievedValue;
- (void)setPrimitiveIsRecievedValue:(BOOL)value_;

- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;

- (NSString*)primitiveMessageId;
- (void)setPrimitiveMessageId:(NSString*)value;

- (NSDate*)primitiveTime;
- (void)setPrimitiveTime:(NSDate*)value;

- (EAContact*)primitiveContact;
- (void)setPrimitiveContact:(EAContact*)value;

@end
