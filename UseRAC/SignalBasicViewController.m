//
//  SignalBasicViewController.m
//  UseRAC
//
//  Created by chester on 9/12/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "SignalBasicViewController.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"

@interface SignalBasicViewController ()

- (IBAction)filterTapped:(id)sender;
- (IBAction)intervalTapped:(id)sender;
- (IBAction)takeTapped:(id)sender;
- (IBAction)mapTapped:(id)sender;
- (IBAction)thenTapped:(id)sender;
- (IBAction)publishTapped:(id)sender;
- (IBAction)deliverOnTapped:(id)sender;
- (IBAction)replayTapped:(id)sender;
- (IBAction)mixThingsTapped:(id)sender;

@end

@implementation SignalBasicViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ---- Callbacks ----

- (IBAction)filterTapped:(UIButton *)sender {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"OK"];
            [subscriber sendNext:@"OT"];
            [subscriber sendCompleted];
        });
        return nil;
    }];

    // filter means add adjustment of wheather the value should pass to the subscriber
    [[signal filter:^BOOL(NSString *value) {
        
        return [value hasSuffix:@"K"];
        
    }] subscribeNext:^(NSString *value) {
        
        NSLog(@"I got the %@", value);

    } completed:^{
    
        NSLog(@"Complete");
        
    }];
}

- (IBAction)intervalTapped:(id)sender
{
    // signal trigered every interval time, like timer
    
    RACDisposable *dispose = [[RACSignal interval:1 onScheduler:[RACScheduler scheduler]] subscribeNext:^(id x) {
        NSLog(@"trigered!");
    }];

    // until I dispose it, the you will not receive the complete step
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [dispose dispose];
    });
}


- (IBAction)takeTapped:(id)sender {
    
    static NSUInteger count = 0;
    // take 5 times
    NSUInteger takeTimes = 5;
    
    //triger the signal every half seconds, and only trigered takeTimes times
    [[[RACSignal interval:0.5 onScheduler:[RACScheduler scheduler]] take:takeTimes] subscribeNext:^(id x) {
        NSLog(@"triger time = %d", ++count);
    } error:^(NSError *error) {
        NSLog(@"error");
    } completed:^{
        
        // after trigered takeTimes times, signal complete it's job and send the complete event
        NSLog(@"complete");
    }];
}

- (IBAction)mapTapped:(UIButton *)sender {
    
}

- (IBAction)thenTapped:(id)sender {
}

- (IBAction)publishTapped:(id)sender {
}

- (IBAction)deliverOnTapped:(id)sender {
}

- (IBAction)replayTapped:(id)sender {
}

- (IBAction)mixThingsTapped:(id)sender {
}


@end
