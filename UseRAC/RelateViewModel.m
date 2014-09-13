//
//  RelateViewModel.m
//  UseRAC
//
//  Created by chester on 9/11/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "RelateViewModel.h"


@implementation RelateViewModel
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.sex = @"";
        self.age = @"";
        self.name = @"";
    }
    return self;
}

-(RACSignal *)prefetchData
{
    @weakify(self);
    return [RACSignal  createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            self.sex = @"male";
            self.age = @"30";
            self.name = @"Kevin";
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

-(RACSignal *)registerAccountWithPassword:(NSString *)password
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

@end
