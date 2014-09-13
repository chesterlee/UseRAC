//
//  SystemItemViewController.m
//  UseRAC
//
//  Created by chester on 9/12/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "SystemItemViewController.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"
#import "MyTableViewCell.h"

@interface SystemItemViewController ()<UITableViewDataSource, UITableViewDelegate>
- (IBAction)showAlertButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SystemItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Sys Component";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlertButtonTapped:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Accept?"
                                                        message:@"Alert"
                                                       delegate:nil
                                              cancelButtonTitle:@"YES"
                                              otherButtonTitles:@"NO", nil];
    
    @weakify(self);
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *index) {
        @strongify(self);
        if (0 == index.intValue)
            [self confirm];
        else
            [self negative];
    }];
    
    [alertView show];
}

-(void)confirm
{
    NSLog(@"do confirm job");
}

-(void)negative
{
    NSLog(@"do negative job");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCell1" forIndexPath:indexPath];
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    [cell configure];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}


@end
