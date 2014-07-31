//
//  SolverViewController.h
//  Sudoku
//
//  Created by John on 20/07/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sudoku.h"

@interface SolverViewController : UIViewController

@property (strong) NSMutableArray *incompleteSudoku;
@property (strong) NSMutableArray *solvedSudoku;
@property (strong, nonatomic) UIButton *activeCell;
@property (strong, nonatomic) UIButton *previousActiveCell;

- (void)cellPressed:(id)sender;

- (IBAction)numberPressed:(id)sender;

- (IBAction)clearCell:(id)sender;

- (IBAction)reset:(id)sender;

- (IBAction)solve:(id)sender;

@end
