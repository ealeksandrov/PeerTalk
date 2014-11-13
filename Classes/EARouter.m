//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import "EARouter.h"

@implementation EARouter

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
    return [super init];
}

#pragma mark - Private actions

- (void)setupRootVC {
    self.masterVC = [[ContactsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    self.detailVC = [[MessagesViewController alloc] init];
    
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        // using UISplitVC for iOS8 and iPad on iOS7
        [[EARouter sharedInstance] setupSplitVC];
    } else {
        // using simple mater-detail VC for iPhone on iOS 7
        [[EARouter sharedInstance] setupNavVC];
    }
}

- (void)setupSplitVC {
    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    
    UINavigationController *masterNavVC = [[UINavigationController alloc] initWithRootViewController:self.masterVC];
    UINavigationController *detailNavVC = [[UINavigationController alloc] initWithRootViewController:self.detailVC];
    
    splitViewController.viewControllers = @[masterNavVC, detailNavVC];
    splitViewController.delegate = self;
    
    if ([UISplitViewController instancesRespondToSelector:@selector(setPreferredDisplayMode:)]) {
        splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    }
    
    self.rootVC = splitViewController;
}

- (void)setupNavVC {
    UINavigationController *masterNavVC = [[UINavigationController alloc] initWithRootViewController:self.masterVC];
    
    self.rootVC = masterNavVC;
}

- (void)openContact:(EAContact *)contact {
    [self.detailVC setContact:contact];
    if([self.rootVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self.rootVC pushViewController:self.detailVC animated:YES];
    } else {
        [(UISplitViewController *)self.rootVC showDetailViewController:self.detailVC sender:self];
    }
}

#pragma mark - UISplitViewController delegate

// show master view first on iphone
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryVC ontoPrimaryViewController:(UIViewController *)primaryVC {
    if ([secondaryVC isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryVC topViewController] isKindOfClass:[self.detailVC class]]) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

// show master view in portrait orientation on iOS7
- (BOOL)splitViewController:(UISplitViewController *)splitViewController shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

#pragma mark - Custom accessors

- (UIViewController *)rootVC {
    if(!_rootVC) {
        [self setupRootVC];
    }
    return _rootVC;
}

@end
