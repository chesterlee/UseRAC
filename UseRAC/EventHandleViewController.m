//
//  EventHandleViewController.m
//  UseRAC
//
//  Created by lee chester on 9/11/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "EventHandleViewController.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"
#import <MBProgressHUD.h>

@interface EventHandleViewController ()

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (copy, nonatomic) NSString *firstTappedString;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIButton *selectorButton;

@end

@implementation EventHandleViewController

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
    self.title = @"UIEvent handle";
    self.firstTappedString = @"";
    [self makeConnections];
    [self createGesture];
    [self makeSelectors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)makeConnections
{
    // ================ handle tap type1: ==================//
    @weakify(self);
    _firstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"first button tapped!");
        @strongify(self);
        self.firstTappedString = @"I have value!";
        return [RACSignal empty];
    }];
    
    // ================ handle tap type2: ================ //
    [[_secondButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        @strongify(self);
        NSLog(@"second button tapped!");
        NSLog(@"%@",self.secondButton);
    }];
    
    // ================ command using ================//
    // stateButton state relay on the other signal(ex: firstTappedString signal which triggered by first button)
    _stateButton.rac_command = [[RACCommand alloc] initWithEnabled:[RACObserve(self, firstTappedString) map:^id(NSString *value) {
        return [value isEqual:@""]? @NO:@YES;
    }] signalBlock:^RACSignal *(id input) {
        
        //maybe you can do logic work here
        //.....logic work(Simple work maybe).....
        //and return empty signal
        
        //or return a signal and make subscriber outside can subscribe the signal
        // it can be asyn operation as well
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"stateButton tapped"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [[_stateButton.rac_command executionSignals] subscribeNext:^(RACSignal *signalFromCommand) {
        [signalFromCommand subscribeNext:^(NSString *string) {
            NSLog(@"%@",string);
        }];
    }];
    
    // ================ for selector use ================//
    _selectorButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSelector:@selector(testSelector) withObject:nil afterDelay:0.5];
        return [RACSignal empty];
    }];
}

#pragma mark - gesture
- (void)createGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        NSLog(@"gesture tapped!");
    }];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - selector
- (void)makeSelectors
{
    RACSignal *selectorSignal = [self rac_signalForSelector:@selector(testSelector)];
    [selectorSignal subscribeNext:^(id x) {
        NSLog(@"do my subsriber things after testSelector");
    }];
}

-(void)testSelector
{
    NSLog(@"do my test seletor things");
}



@end
