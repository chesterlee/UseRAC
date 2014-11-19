//
//  ReplaysViewController.m
//  UseRAC
//
//  Created by lee chester on 11/19/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "ReplaysViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ReplaysViewController ()

- (IBAction)replay:(id)sender;
- (IBAction)replayInnerTapped:(id)sender;
- (IBAction)replayLast:(id)sender;
- (IBAction)replayLastInner:(id)sender;

- (IBAction)replayLazily:(id)sender;
- (IBAction)replayLayzilyInner:(id)sender;

@end

@implementation ReplaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - replayTest
- (IBAction)replay:(id)sender
{
    __block int num = 0;
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(RACSubject*  subscriber) {
        num++;//只被调用了一次，num始终为1
        NSLog(@"Increment num to: %i", num);
        [subscriber sendNext:@(num)];//发出信号，通知订阅者。replay使信号保留为“static”（一旦有新订阅者加入，会将它发给新订阅者，执行新订阅者代码）
        return nil;
    }] replay];//replay直接让signal（函数）首先执行一次【signal不允许被执行多次，与nomal示例不同】
    
    NSLog(@"Start subscriptions");
    
    
    [signal subscribeNext:^(id x) {//订阅，不能触发signal的执行。但是会被直接执行订阅者代码
        //接收到的x永远为1
        NSLog(@"订阅者1: %@", x);
    }];
    
    
    [signal subscribeNext:^(id x) {
        //接收到的x永远为1
        NSLog(@"订阅者2: %@", x);
    }];
    
    
    [signal subscribeNext:^(id x) {
        //接收到的x永远为1
        NSLog(@"订阅者3: %@", x);
    }];
}

- (IBAction)replayInnerTapped:(id)sender {
    
    RACSubject *letters = [RACSubject subject];
    RACSignal *signal = [letters replay];//由于内部没有sendNext，所以还没有信号。此时加入的订阅者，其订阅者代码不会被调用
    
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者1: %@", x);
    }];
    
    [letters sendNext:@"A"];//发出信号（就有了“static”信号），通知所有订阅者，执行订阅者代码
    [letters sendNext:@"B"];//信号“A”、“B”都会被保留。变成组合信号
    
    
    [signal subscribeNext:^(id x) {//新订阅者加入，订阅者代码立即执行。因为此时内存中有“static”的信号
        NSLog(@"订阅者2: %@", x);
    }];
    
    [letters sendNext:@"C"];
    [letters sendNext:@"D"];
    
    [signal subscribeNext:^(id x) {//到这里的时候，信号为“A”、“B”、“C”、“D”
        NSLog(@"订阅者3: %@", x);
    }];

}

- (IBAction)replayLast:(id)sender
{
    RACSubject *letters = [RACSubject subject];
    RACSignal *signal = [letters replayLast];//replayLast：拥有replay的特性。不同的是：只保留最后一个sendNext的信号，之前的信号在sendNext完成后会被替换掉
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者1: %@", x);
    }];
    
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];//这一句执行完后，信号只为“B”
    
    [signal subscribeNext:^(id x) {//刚一参与订阅，由于有“static”的信号，所以立即被执行订阅者代码。但信号只为“B”
        NSLog(@"订阅者2: %@", x);
    }];
    
    [letters sendNext:@"C"];//发出信号，触发上面2个订阅者
    [letters sendNext:@"D"];
    
    [signal subscribeNext:^(id x) {//刚一参与订阅，由于有“static”的信号，所以立即被执行订阅者代码。但信号只为“D”
        NSLog(@"订阅者3: %@", x);
    }];

}

- (IBAction)replayLastInner:(id)sender
{
    __block int num = 0;
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id  subscriber) {
        num++;
        NSLog(@"Increment num to: %i", num);
        [subscriber sendNext:@(num)];
        return nil;
    }] replayLast];//replayLast：拥有replay的特性。不同的是：只保留最后一个sendNext的信号，之前的信号在sendNext完成后会被替换掉
    
    
    NSLog(@"Start subscriptions");
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者1: %@", x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者2: %@", x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者3: %@", x);
    }];
}

- (IBAction)replayLazily:(id)sender
{
    __block int num = 0;
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id  subscriber) {
        num++;
        NSLog(@"Increment num to: %i", num);
        [subscriber sendNext:@(num)];
        return nil;
    }] replayLazily];//replayLazily:拥有replay的特性。不同的是：signal被用到的时候才加载
    
    NSLog(@"Start subscriptions");
    
    [signal subscribeNext:^(id x) {//订阅，触发signal，signal才被加载执行
        NSLog(@"订阅者1: %@", x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者2: %@", x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者3: %@", x);
    }];

}

- (IBAction)replayLayzilyInner:(id)sender
{
    RACSubject *letters = [RACSubject subject];
    RACSignal *signal = [letters replayLazily];//被用到的时候才加载
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者1: %@", x);
    }];
    
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者2: %@", x);
    }];
    
    [letters sendNext:@"C"];
    [letters sendNext:@"D"];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅者3: %@", x);
    }];
}

@end
