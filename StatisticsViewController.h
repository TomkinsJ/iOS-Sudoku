//
//  StatisticsViewController.h
//  Sudoku
//
//  Created by John on 26/02/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *puzzlesCompletedLabel;
@property (strong, nonatomic) IBOutlet UILabel *easyTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *mediumTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *hardTimeLabel;

- (IBAction)resetStatistics:(id)sender;

@end
