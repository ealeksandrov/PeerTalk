//  Copyright (c) 2014 Evgeny Aleksandrov. All rights reserved.

#import "ContactsTableViewController.h"
#import "EALogging.h"

#import "EAContact.h"

static NSString * const ContactCellIdentifier = @"ContactCell";

@interface ContactsTableViewController ()

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSDictionary *sectionHeaders;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PeerTalk";
    
    self.sections = @[[EAPostmaster sharedInstance].onlineContacts,[EAPostmaster sharedInstance].offlineContacts];
    
    self.sectionHeaders = @{@0 : @"Online",
                            @1 : @"Offline"};
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ContactCellIdentifier];
    
    [[EAPostmaster sharedInstance] setDelegate:self];
    [[EAPostmaster sharedInstance] startWorking];
}

#pragma mark - EAPostmaster delegate

- (void)postmaster:(EAPostmaster *)postmaster foundPeer:(EAContact *)contact {
    if([self.sections[1] containsObject:contact]) {
        NSIndexPath *indexPathFrom = [NSIndexPath indexPathForRow:[self.sections[1] indexOfObject:contact] inSection:1];
        self.sections = @[[EAPostmaster sharedInstance].onlineContacts,[EAPostmaster sharedInstance].offlineContacts];
        NSIndexPath *indexPathTo = [NSIndexPath indexPathForRow:[self.sections[0] indexOfObject:contact] inSection:0];
        
        [self.tableView moveRowAtIndexPath:indexPathFrom toIndexPath:indexPathTo];
    } else {
        self.sections = @[[EAPostmaster sharedInstance].onlineContacts,[EAPostmaster sharedInstance].offlineContacts];
        NSIndexPath *indexPathTo = [NSIndexPath indexPathForRow:[self.sections[0] indexOfObject:contact] inSection:0];
        
        [self.tableView insertRowsAtIndexPaths:@[indexPathTo] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)postmaster:(EAPostmaster *)postmaster lostPeer:(EAContact *)contact {
    if([self.sections[0] containsObject:contact]) {
        NSIndexPath *indexPathFrom = [NSIndexPath indexPathForRow:[self.sections[0] indexOfObject:contact] inSection:0];
        self.sections = @[[EAPostmaster sharedInstance].onlineContacts,[EAPostmaster sharedInstance].offlineContacts];
        NSIndexPath *indexPathTo = [NSIndexPath indexPathForRow:[self.sections[1] indexOfObject:contact] inSection:1];
        
        [self.tableView moveRowAtIndexPath:indexPathFrom toIndexPath:indexPathTo];
    } else {
        self.sections = @[[EAPostmaster sharedInstance].onlineContacts,[EAPostmaster sharedInstance].offlineContacts];
        NSIndexPath *indexPathTo = [NSIndexPath indexPathForRow:[self.sections[1] indexOfObject:contact] inSection:0];
        
        [self.tableView insertRowsAtIndexPaths:@[indexPathTo] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)postmaster:(EAPostmaster *)postmaster recievedMessage:(NSString *)message fromPeer:(EAContact *)contact {
    
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.sections[section]).count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionHeaders[@(section)];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactCellIdentifier forIndexPath:indexPath];
    
    EAContact *item = [self itemAtIndexPath:indexPath];
    
    [cell.textLabel setText:item.displayName];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[EAPostmaster sharedInstance] deleteContact:[self itemAtIndexPath:indexPath]];
        self.sections = @[[EAPostmaster sharedInstance].onlineContacts,[EAPostmaster sharedInstance].offlineContacts];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Data helpers

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.sections[indexPath.section][indexPath.row];
}

@end
