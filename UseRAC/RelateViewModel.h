//
//  RelateViewModel.h
//  UseRAC
//
//  Created by chester on 9/11/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"

@interface RelateViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *age;

// fetch data
-(RACSignal *)prefetchData;

// log or regist
-(RACSignal *)registerAccountWithPassword:(NSString *)password;

@end
