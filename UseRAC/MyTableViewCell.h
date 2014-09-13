//
//  MyTableViewCell.h
//  UseRAC
//
//  Created by chester on 9/12/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

-(void)configure;

@end
