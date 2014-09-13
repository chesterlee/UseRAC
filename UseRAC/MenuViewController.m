//
//  MenuViewController.m
//  UseRAC
//
//  Created by chester on 9/11/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "MenuViewController.h"
#import "VMRelateViewController.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"

@interface MenuViewController ()

@property (nonatomic) NSArray *cellTitles;
@property (nonatomic) NSArray *segueIDs;


@end

@implementation MenuViewController

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
    self.title = @"Main";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BasicCell"];
    self.cellTitles = @[@"Data and UI", @"UIEvent handle", @"CategoryShow", @"SysComponent", @"More"];
    self.segueIDs = @[@"RelateVM",@"EHVC",@"NotiSegue",@"SysItemSegue",@"MoreSegue"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
