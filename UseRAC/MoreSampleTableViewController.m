//
//  MoreSampleTableViewController.m
//  UseRAC
//
//  Created by chester on 9/12/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "MoreSampleTableViewController.h"

/**
 *  filter, interval, take, map, publish, then, flattenMap, deliverOn, replay(RACMulticastConnection)
 *  RACSubject, Sequence
 *  networking, switchToLatest
 *
 */
@interface MoreSampleTableViewController ()

@property (nonatomic) NSArray *cellTitles;
@property (nonatomic) NSArray *segueIDs;

@end

@implementation MoreSampleTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"More";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BasicCell"];
    self.cellTitles = @[@"SignalBasic", @"Network",@"ReplayDetail"];
    self.segueIDs = @[@"SignalSegue",@"NetworkSegue",@"ReplaysSegue"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell" forIndexPath:indexPath];
    cell.textLabel.text = self.cellTitles[indexPath.row];
    cell.textLabel.tintColor = [UIColor blueColor];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:self.segueIDs[indexPath.row] sender:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}


@end
