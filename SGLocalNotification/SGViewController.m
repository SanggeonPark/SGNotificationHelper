//
//  ViewController.m
//  SGLocalNotification
//
//  Created by ParkSanggeon on 21/01/15.
//  Copyright (c) 2015 SGP. All rights reserved.
//

#import "SGViewController.h"
#import "SGNotificationHelper.h"

static NSString *CellIdentifier = @"TableViewCell";

@interface SGViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *notifications;
@end

@implementation SGViewController

#pragma mark - Accessors

- (void)setNotifications:(NSArray *)notifications
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
    _notifications = [notifications sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)removeAllNotifications:(id)sender
{
    [SGNotificationHelper removeAllNotifications];
    self.notifications = [SGNotificationHelper allNotifications];
}

- (IBAction)reloadTableView:(id)sender
{
    self.notifications = [SGNotificationHelper allNotifications];
}

- (IBAction)addLocalNotification:(id)sender
{
    NSString *keyForCache = [@([[NSDate date] timeIntervalSince1970]) stringValue];
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertAction = @"Let's Check";
    notification.alertBody = [NSString stringWithFormat:@"Test\n%@\n%@", [NSDate date], keyForCache];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    [notification setKey:keyForCache];
    [SGNotificationHelper showNotification:notification];
    self.notifications = [SGNotificationHelper allNotifications];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILocalNotification *noti = self.notifications[indexPath.row];
    cell.textLabel.text = noti.alertBody;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notifications.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove Notification"
                                                    message:@"Do you really want remove this notification?"
                                                   delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = indexPath.row;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [SGNotificationHelper removeNotification:self.notifications[alertView.tag]];
        self.notifications = [SGNotificationHelper allNotifications];
    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.notifications = [SGNotificationHelper allNotifications];
}


@end
