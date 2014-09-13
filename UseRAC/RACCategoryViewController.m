//
//  RACCategoryViewController.m
//  UseRAC
//
//  Created by chester on 9/12/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "RACCategoryViewController.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"

#define NotificationKey @"NotificationKey"

@interface RACCategoryViewController ()
- (IBAction)sendButtonTapped:(UIButton *)sender;
@end

@implementation RACCategoryViewController

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
    self.title = @"RACCateShow";
    [self makeConnection];
}

-(void)dealloc
{
    NSLog(@"dealloc");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeConnection
{
    // =========== notifications ===========//
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:NotificationKey
                                                            object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notification) {
         
         // get the value and do logic process
         NSString *notificationName  = [notification name];
         NSString *object = [notification object];
         NSDictionary *userInfo = [notification userInfo];
         NSLog(@"gocha the notification name :%@, object:%@, and Userinfo:%@",notificationName, object, userInfo);
         
     } completed:^{
         NSLog(@"be disposed");
     }];
    
    // =========== before dealloc's running block ===========//
    // if you wanna do some things, before self will dealloc, do things in the block
    [[self rac_willDeallocSignal] subscribeCompleted:^{
        
        //do what you want to dealloc
        NSLog(@"before dealloc");
    }];
    
    // =========== RACSignal with rac_liftSelector ===========//
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"sigA will send");
            [subscriber sendNext:@"A"];
            NSLog(@"sigA did send");
            NSLog(@"sigA will comp");
            [subscriber sendCompleted];
            NSLog(@"sigA did comp");
        });
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"B"];
        [subscriber sendNext:@"another b"];
        NSLog(@"sigB will comp");
        [subscriber sendCompleted];
        NSLog(@"sigB did comp");
        return nil;
    }];
    
    
    /*
     * important: do contrast with rac_liftSelector, combineLatest and merge //
     */
    
    // Lifts the selector on the receiver into the reactive world. The selector will
    /// be invoked whenever any signal argument sends a value, but only after each
    /// signal has sent an initial value.
    [self rac_liftSelector:@selector(doA:withB:) withSignals:signalA, signalB, nil];
    

    // combine latest means if signalA & B all have value ,their values will be reduce with block
//    [[RACSignal combineLatest:@[signalA, signalB] reduce:^id(NSString *stringA, NSString *stringB){
//
//        //do op here
//        NSLog(@"0");
//        return @"watch";
//    }] subscribeNext:^(id x) {
//        
//        NSLog(@"1");
//    } completed:^{
//        
//        NSLog(@"2");
//    }];
    
    // merge focus on signals' completed action
//    [[RACSignal merge:@[signalA, signalB]] subscribeCompleted:^{
//        NSLog(@"signalA and B all completed");
//    }];
}

- (void)doA:(NSString *)A withB:(NSString *)B
{
    NSLog(@"A:%@ and B:%@", A, B);
}

- (IBAction)sendButtonTapped:(UIButton *)sender {
    
    NSDictionary *dic = @{@"a":@"1",@"b":@"2"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationKey object:@"test0" userInfo:dic];
}

@end
