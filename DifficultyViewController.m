//
//  DifficultyViewController.m
//  Sudoku
//
//  Created by John on 26/02/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import "DifficultyViewController.h"
#import "SudokuViewController.h"
#import "Sudoku.h"

@interface DifficultyViewController (){
    NSMutableDictionary *properties;
    NSString *path;
}

@end

@implementation DifficultyViewController

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
	// Do any additional setup after loading the view.
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"properties.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"properties" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    properties = [[NSMutableDictionary alloc] initWithContentsOfFile: path];

    UIImageView *background;
    if ([properties objectForKey:@"colourScheme"]) {
        // choose background from options plist
        if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"original"]) {
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiffBackground.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"blue"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiffBackgroundBlue.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"brown"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiffBackgroundBrown.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"purple"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiffBackgroundPurple.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"black"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiffBackgroundBlack.jpg"]];
        }
    } else {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiffBackgroundBrown.jpg"]];
        
    }
        
        
    [self.view addSubview: background];
    background.frame = self.view.bounds;
    [self.view sendSubviewToBack: background];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"easySudoku"]) {
        SudokuViewController *sudokuViewController = (SudokuViewController *)[segue destinationViewController];
        NSInteger holes = (15 + arc4random_uniform(25 - 15 + 1)); // between 15 and 25 holes
        NSArray *boards = [Sudoku generateSudokuWithHoles:holes withUniqueSolution:YES];
        [sudokuViewController setCompleteSudoku:[boards objectAtIndex:0]];
        [sudokuViewController setIncompleteSudoku:[boards objectAtIndex:1]];
        [sudokuViewController setDifficulty:@"easy"];
    }
    
    if ([[segue identifier] isEqualToString:@"mediumSudoku"]) {
        SudokuViewController *sudokuViewController = (SudokuViewController *)[segue destinationViewController];
        NSInteger holes = (26 + arc4random_uniform(45 - 26 + 1)); // between 26 and 45 holes
        NSArray *boards = [Sudoku generateSudokuWithHoles:holes withUniqueSolution:NO];
        [sudokuViewController setCompleteSudoku:[boards objectAtIndex:0]];
        [sudokuViewController setIncompleteSudoku:[boards objectAtIndex:1]];
        [sudokuViewController setDifficulty:@"medium"];
    }
    
    if ([[segue identifier] isEqualToString:@"hardSudoku"]) {
        SudokuViewController *sudokuViewController = (SudokuViewController *)[segue destinationViewController];
        NSInteger holes = (46 + arc4random_uniform(64 - 46 + 1)); // between 46 and 64 holes (cannot have more than 64 holes or multiple solutions guaranteed
        NSArray *boards = [Sudoku generateSudokuWithHoles:holes withUniqueSolution:NO];
        [sudokuViewController setCompleteSudoku:[boards objectAtIndex:0]];
        [sudokuViewController setIncompleteSudoku:[boards objectAtIndex:1]];
        [sudokuViewController setDifficulty:@"hard"];

    }
}

@end
