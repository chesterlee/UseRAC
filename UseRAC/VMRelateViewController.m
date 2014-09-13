//
//  VMRelateViewController.m
//  UseRAC
//
//  Created by chester on 9/11/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "VMRelateViewController.h"
#import "RelateViewModel.h"
#import <MBProgressHUD.h>

@interface VMRelateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)onLoginTapped:(UIButton *)sender;



@property (nonatomic) RelateViewModel *viewModel;

@end

@implementation VMRelateViewController

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
    
    self.title = @"Data & UI";
    
    // init viewmodel
    self.viewModel = [[RelateViewModel alloc] init];

    [self createGesture];

    [self createConnections];
    
    // simulate request
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[self.viewModel prefetchData] subscribeCompleted:^{
            @strongify(self);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)createGesture
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(onTap:)];
    
    [self.view addGestureRecognizer:tapGes];
}

-(void)onTap:(UITapGestureRecognizer *)tpGesture
{
    [_nameTextField resignFirstResponder];
    [_sexTextField resignFirstResponder];
    [_ageTextField resignFirstResponder];
    [_password resignFirstResponder];
    [_password2 resignFirstResponder];
}

-(void)createConnections
{
    RAC(self.nameTextField, text) = RACObserve(self.viewModel, name);
    RAC(self.sexTextField, text) = RACObserve(self.viewModel, sex);
    RAC(self.ageTextField,text) = RACObserve(self.viewModel, age);

    // logic one:
    
    // writing type1:
//    RAC(self.loginButton, hidden) = [self.password.rac_textSignal map:^id(NSString *value) {
//        return [value isEqualToString:@""] ? @YES:@NO;
//    }];
    
    // writing type2:
    //    [self.password.rac_textSignal subscribeNext:^(id x) {
    //
    //        //
    //        if (![x isEqualToString:@""])
    //        {
    //            self.loginButton.hidden = NO;
    //        }
    //        else
    //        {
    //            self.loginButton.hidden = YES;
    //        }
    //    }];
    
    // logic two:
    RAC(self.loginButton, hidden) = [RACSignal combineLatest:@[self.password.rac_textSignal,
                                                               self.password2.rac_textSignal]
                                                      reduce:^id(NSString *password1, NSString *password2){
                                                          return [password2 isEqualToString:password1] ?
                                                          ([password2 isEqualToString:@""] ? @YES: @NO) : @YES;
                                                      }];
}

- (IBAction)onLoginTapped:(UIButton *)sender
{
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[self.viewModel registerAccountWithPassword:self.password.text] subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } completed:^{
        @strongify(self);
        NSLog(@"login sucess or whatever");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

}

@end
