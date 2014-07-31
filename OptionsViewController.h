//
//  OptionsViewController.h
//  Sudoku
//
//  Created by John on 26/02/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController

- (IBAction)saveOptions:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *showIncorrectSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *showHintsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *timeAttemptsSwitch;
@property (strong, nonatomic) IBOutlet UISegmentedControl *colourSegmentedControl;

- (IBAction)changeColourScheme:(id)sender;

@end
