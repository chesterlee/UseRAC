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

    // filter means add adjustment of whether the value should pass to the subscriber
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
    
    // ========== Map with any value =========//
    RACSignal *signalOne =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@NO]; //Maybe you can change the value to @YES
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalTwo = [signalOne map:^id(NSNumber *value)
    {
        if ([value boolValue])
        {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:@"signalOne make it Yes!!"];
                [subscriber sendCompleted];
                return nil;
            }];
        }
        return @NO;
    }];
    
    //subscribe  signalTwo will get the mapped value which is a signal
    [signalTwo subscribeNext:^(id value) {

        if ([value isKindOfClass:[RACSignal class]])
        {
            RACSignal *signal = value;
            // subscribe the mapped signal
            [signal subscribeNext:^(NSString *string) {
                NSLog(@"%@",string);
            } error:^(NSError *error) {
                
            } completed:^{
                NSLog(@"complete1");
            }];
        }
        else
        {
            NSLog(@"%@", value);
        }
        

    } error:^(NSError *error) {
        
    } completed:^{
    
        NSLog(@"complete2");
    
    }];
    

    // ========== flatten map with any RACStream ========== //
    RACSignal *signalThree = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"Three Over"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[signalThree flattenMap:^RACStream *(id value) {
        
        RACSignal *sos = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"Intern"];
            [subscriber sendCompleted];
            return nil;
        }];
        return sos;
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        
    } completed:^{
        NSLog(@"complete3");
    }];
}

- (IBAction)thenTapped:(id)sender
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"signal will do send next");
        [subscriber sendNext:@""];
        NSLog(@"signal did do send next");
        
        NSLog(@"signal will make completed");
        [subscriber sendCompleted];
        NSLog(@"signal made completed");
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"2"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // you can see from the log below, when signal send completed, 'then' works
    [[signal1 then:^RACSignal *{
        
        NSLog(@"after signal1 is completed!");
        return signal2;
        
    }] subscribeNext:^(NSString *string) {
        
        NSLog(@"value from signal2 = %@", string);
    } error:^(NSError *error) {
        
    } completed:^{
        NSLog(@"signal2 completed");
    }];
    
}

- (IBAction)publishTapped:(id)sender
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"side effect");
        [subscriber sendNext:@"aaa"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACMulticastConnection *connection = [signal publish];
    
    // connection make side effect triggered only once
    [[connection autoconnect] subscribeNext:^(id x) {
        NSLog(@"sub1 get next");
    } completed:^{
        NSLog(@"sub1 get complete");
    }];

    [[connection autoconnect] subscribeNext:^(id x) {
        NSLog(@"sub2 will NOT get next");
    } completed:^{
        NSLog(@"sub2 will NOT get complete");
    }];
}

- (IBAction)deliverOnTapped:(id)sender
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"sendSomeThings"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // It's using just like the GCD! 
    [[signal deliverOn:[RACScheduler immediateScheduler]] subscribeNext:^(id x) {
        NSLog(@"0%@", x);
    } completed:^{
    }];
    
    [[signal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"1%@", x);
    } completed:^{
        
    }];
    
    [[signal deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]] subscribeNext:^(id x) {
        NSLog(@"2%@", x);
    } completed:^{
        
    }];
    
    [[signal deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh]] subscribeNext:^(id x) {
        NSLog(@"3%@", x);
    } completed:^{
        
    }];
}

- (IBAction)replayTapped:(id)sender
{
    
}

- (IBAction)mixThingsTapped:(id)sender
{
    
}


@end
