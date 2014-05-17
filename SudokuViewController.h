//
//  SudokuViewController.h
//  Sudoku
//
//  Created by John on 26/02/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sudoku.h"

@interface SudokuViewController : UIViewController

@property (strong) NSMutableArray *completeSudoku;
@property (strong) NSMutableArray *incompleteSudoku;
@property (strong) NSMutableArray *activeSudoku;
@property (strong, nonatomic) IBOutlet UILabel *timeDisplay;
@property (nonatomic) UIButton *hintButton;
@property (strong, nonatomic) UIButton *activeCell;
@property (strong, nonatomic) UIButton *previousActiveCell;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger duration;
@property (nonatomic) NSString *difficulty;

- (void)cellPressed:(id)sender;

- (void)updateTimer;

- (IBAction)numberPressed:(id)sender;

- (IBAction)clearCell:(id)sender;

- (IBAction)showHint:(id)sender;

- (IBAction)reset:(id)sender;

- (void)gameFinished;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
