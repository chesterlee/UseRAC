//
//  MyTableViewCell.m
//  UseRAC
//
//  Created by chester on 9/12/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "MyTableViewCell.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"

@interface MyTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation MyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configure
{
    [[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside]
    takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cell Button"
                                                            message:@"Tapped"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        
        [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *index) {
            if (0 == index.intValue)
                NSLog(@"confire");
        }];
        [alertView show];
    }];
}

@end
