//
//  NetworkViewController.m
//  UseRAC
//
//  Created by chester on 9/12/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "NetworkViewController.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkViewController ()

@property (nonatomic) AFHTTPRequestOperationManager *operationManager;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

- (IBAction)doNetworkRequest:(id)sender;

@end

@implementation NetworkViewController

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
    self.title = @"Networking";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doNetworkRequest:(id)sender
{
    RACSignal *netWorkSignal = [self GETWithURL:@"https://s.yimg.com/um/a1b0d20b4866686bba2e5b9ae0755666.jpg" parameters:nil];

    @weakify(self);
    [netWorkSignal subscribeNext:^(id x) {
        @strongify(self);
        self.imageView.image = x;
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    } completed:^{
        NSLog(@"signal1 complete");
    }];
    
    
    RACSignal *networkSignal2 = [self GETWithURL:@"https://s.yimg.com/um/63fbd4a3954d31345dba6ef9f1296252.jpg" parameters:nil];
    [networkSignal2 subscribeNext:^(id x) {
        @strongify(self);
        self.imageView2.image = x;
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    } completed:^{
        NSLog(@"signal2 complete");
    }];
    
    [[RACSignal merge:@[netWorkSignal, networkSignal2]] subscribeCompleted:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download all Complete"
                                                            message:@"complete"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
            if (0 == index.intValue)
                NSLog(@"OK Pressed!");
        }];
        
        [alert show];
    }];
}


#pragma mark - Get Method

- (RACSignal *)GETWithURL:(NSString *)URLString
                 parameters:(NSDictionary *)parameters
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        if (!_operationManager)
        {
            _operationManager = [AFHTTPRequestOperationManager manager];
            _operationManager.responseSerializer = [AFImageResponseSerializer serializer];
        }

        [_operationManager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
    
    return signal;
}


@end
