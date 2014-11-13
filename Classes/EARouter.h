//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

@import UIKit;

#import "ContactsTableViewController.h"
#import "MessagesViewController.h"
#import "EAContact.h"

@interface EARouter : NSObject <UISplitViewControllerDelegate>

@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic, strong) ContactsTableViewController *masterVC;
@property (nonatomic, strong) MessagesViewController *detailVC;

// singleton logic
+ (instancetype)sharedInstance;
+ (instancetype)alloc __attribute__((unavailable("call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("call sharedInstance instead")));

- (void)openContact:(EAContact *)contact;

@end
