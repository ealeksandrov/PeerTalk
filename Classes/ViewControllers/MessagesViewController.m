//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import "MessagesViewController.h"

#import <MagicalRecord/MagicalRecord+Actions.h>
#import "EAPostmaster.h"
#import "EAMessage.h"
#import "EALogging.h"

@interface MessagesViewController () <NSFetchedResultsControllerDelegate> {
    NSMutableArray *insertIndexPaths;
    NSMutableArray *deleteIndexPaths;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputToolbar.contentView.textView.userInteractionEnabled = NO;
    
    self.senderId = [EAPostmaster sharedInstance].localContactId;
    self.senderDisplayName = @"Me";
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
    insertIndexPaths = [NSMutableArray array];
    deleteIndexPaths = [NSMutableArray array];
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [[EAPostmaster sharedInstance] sendMessage:text toContactWithId:self.contact.contactId];
    
    [self finishSendingMessage];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    EAMessage *msg = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([msg.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
#warning Delivered/read status
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    EAMessage *msg = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([msg.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor whiteColor];
    } else {
        cell.textView.textColor = [UIColor darkTextColor];
    }
    
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
#warning Delivered/read status
    return 0.0f;
}

#pragma mark - NSFetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        if([insertIndexPaths count]) {
            [self.collectionView insertItemsAtIndexPaths:insertIndexPaths];
            [insertIndexPaths removeAllObjects];
        }
        if([deleteIndexPaths count]) {
            [self.collectionView deleteItemsAtIndexPaths:deleteIndexPaths];
            [deleteIndexPaths removeAllObjects];
        }
    } completion:nil];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [insertIndexPaths addObject:newIndexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [deleteIndexPaths addObject:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [deleteIndexPaths addObject:indexPath];
            [insertIndexPaths addObject:newIndexPath];
            break;
        default:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

#pragma mark - Custom accessors

- (NSFetchedResultsController *)fetchedResultsController {
    if(!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[EAMessage entityName]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"contact == %@",self.contact]];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[MagicalRecordStack defaultStack] context] sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController setDelegate:self];
        
        NSError *error = nil;
        [_fetchedResultsController performFetch:&error];
        
        if (error) {
            DDLogError(@"Unable to perform fetch.");
            DDLogError(@"%@, %@", error, error.localizedDescription);
        }
    }
    
    return _fetchedResultsController;
}

- (void)setContact:(EAContact *)contact {
    if(_contact) {
        [[EAMultipeerManager sharedInstance] disconnectContactWithId:contact.contactId];
    }
    _contact = contact;
    [[EAMultipeerManager sharedInstance] connectContactWithId:contact.contactId];
    self.fetchedResultsController = nil;
    [self.collectionView reloadData];
    self.inputToolbar.contentView.textView.userInteractionEnabled = YES;
}

@end
