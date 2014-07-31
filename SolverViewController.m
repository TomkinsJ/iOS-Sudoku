//
//  SolverViewController.m
//  Sudoku
//
//  Created by John on 20/07/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import "SolverViewController.h"
#import "Cell.h"
#import <sys/utsname.h>


@interface SolverViewController (){
    NSMutableDictionary *properties;
    NSString *path;
    UIColor *highlightedColour;
}

@end

@implementation SolverViewController

@synthesize incompleteSudoku;
@synthesize solvedSudoku;
@synthesize activeCell;
@synthesize previousActiveCell;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

NSString* machineNameSolver()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*if (!([[[UIDevice currentDevice]model]rangeOfString:@"iPad"].location == NSNotFound)) {
     iPad = YES;
     }*/
    
    /*if ([machineName()rangeOfString:@"ipad"].location == NSNotFound) {
     iPad = YES;
     NSLog(@"yes");
     }*/
    
    NSString* deviceName = [[UIDevice currentDevice]model];
    BOOL not4InchScreen = NO;
    if ((![machineNameSolver()isEqualToString:@"iPhone5,1"]) &&
        (![machineNameSolver()isEqualToString:@"iPhone5,2"]) &&
        (![machineNameSolver()isEqualToString:@"iPhone5,3"]) &&
        (![machineNameSolver()isEqualToString:@"iPhone5,4"]) &&
        (![machineNameSolver()isEqualToString:@"iPhone6,1"]) &&
        (![machineNameSolver()isEqualToString:@"iPhone6,2"]) &&
        (![deviceName isEqualToString:@"iPhone Simulator"]) &&
        ([machineNameSolver()rangeOfString:@"ipad"].location == NSNotFound)) {
        not4InchScreen = YES;
    }
    
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
            
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SudokuBackground.jpg"]];
            highlightedColour = [UIColor colorWithRed:94.0/255.0 green:121.0/255.0 blue:157.0/255.0 alpha:1.0];
            
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"blue"]){
            
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SudokuBackgroundBlue.jpg"]];
            highlightedColour = [UIColor colorWithRed:166.0/255.0 green:207.0/255.0 blue:255.0/255.0 alpha:1.0];
            
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"brown"]){
            
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SudokuBackgroundBrown.jpg"]];
            highlightedColour = [UIColor colorWithRed:255.0/255.0 green:214.0/255.0 blue:166.0/255.0 alpha:1.0];
            
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"purple"]){
            
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SudokuBackgroundPurple.jpg"]];
            highlightedColour = [UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:255.0/255.0 alpha:1.0];
            
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"black"]){
            
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SudokuBackgroundBlack.jpg"]];
            highlightedColour = [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:1.0];
        }
    } else {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SudokuBackgroundBrown.jpg"]];
        
    }
    
    [self.view addSubview: background];
    background.frame = self.view.bounds;
    [self.view sendSubviewToBack: background];
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView *grid = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grid.png"]];
    [self.view addSubview: grid];
    grid.frame = self.view.bounds;
    

    // draw the buttons to hold the 81 numbers of the Sudoku board
    int cellCount = 0;
    int xCoord = 20;
    int ySize = 33;
    if (not4InchScreen) {
        ySize = 28;
    }
    
    for (int i = 0; i <= 8; i++){
        
        int yCoord = 99;
        if (not4InchScreen) {
            yCoord = 83;
        }
        
        for (int j = 0; j <= 8; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(xCoord, yCoord, 30, ySize);
            button.titleLabel.font = [UIFont systemFontOfSize:21.0];
            
 
            
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setTag:cellCount]; // tag will match the index of the value in both complete and active sudoku
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cellPressed:) forControlEvents:UIControlEventTouchUpInside]; // run cellPressed: when a cell is highlighted
            [[self view] addSubview:button];
            if (not4InchScreen) {
                yCoord += 29;
            } else {
                yCoord += 34;
            }
            cellCount++;
        }
        xCoord += 31;
    }
    
    // Fill incomplete sudoku with empty cells with number = 0
    
    /*incompleteSudoku = [[NSMutableArray alloc]init];
    for (int i = 0; i <= 80; i++) {
        Cell *emptyCell = [[Cell alloc]init];
        [emptyCell setDug:YES];
        [incompleteSudoku addObject:emptyCell];
    }*/
    incompleteSudoku = [Sudoku generateBoard];
    for (Cell *cell in incompleteSudoku) {
        [cell setNumber:0];
        [cell setDug:YES];
    }
    
}



- (void)cellPressed:(id)sender
{
    
    [previousActiveCell setBackgroundColor:[UIColor clearColor]];
    activeCell = sender;
    [activeCell setBackgroundColor:highlightedColour];
    previousActiveCell = sender;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)numberPressed:(id)sender
{
    if (activeCell) {
        
        Cell *proposedCell = [Sudoku createCellWithIndex:[activeCell tag] WithNumber:[[[sender titleLabel]text]integerValue]];
        if (![Sudoku conflictsWithCells:incompleteSudoku WithProposedCell:proposedCell]) {
            
            [[incompleteSudoku objectAtIndex:[activeCell tag]]setNumber:[[[sender titleLabel]text]integerValue]];
            [[incompleteSudoku objectAtIndex:[activeCell tag]]setDug:NO];
            [activeCell setTitle:[[sender titleLabel]text] forState:UIControlStateNormal];
            [activeCell setTitleColor:[UIColor colorWithRed:0/255.0 green:220.0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [activeCell setBackgroundColor:[UIColor clearColor]];
            activeCell = nil;
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Oops"
                                                           message: @"That number cannot go there!"
                                                          delegate: self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:NO,nil];
            [alert show];
        }

    }
}

- (IBAction)clearCell:(id)sender
{
    if (activeCell) {
        [activeCell setTitle:@"" forState:UIControlStateNormal];
        [activeCell setBackgroundColor:[UIColor clearColor]];
        [[incompleteSudoku objectAtIndex:[activeCell tag]]setNumber:0]; // update active sudoku with clear value
        [[incompleteSudoku objectAtIndex:[activeCell tag]]setDug:YES];
        activeCell = nil;
    }
}

- (IBAction)reset:(id)sender {
    
    // reset all the numbers user has entered to blank
    for (int i = 0; i <= 80; i++) {
        [[incompleteSudoku objectAtIndex:i]setNumber:0];
        [[incompleteSudoku objectAtIndex:i]setDug:YES];
        for (id object in [self.view subviews]) {
            if ([object isKindOfClass:[UIButton class]]) {
                if ([object tag] == i) {
                    [object setTitle:@"" forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (IBAction)solve:(id)sender {
    
    solvedSudoku = [Sudoku solveBoard:incompleteSudoku];
    for (int i = 0; i <= 80; i++) {
        for (id object in [self.view subviews]) {
            if ([object isKindOfClass:[UIButton class]]) {
                if ([object tag] == i) {
                    [object setTitle:[NSString stringWithFormat:@"%ld", (long)[[solvedSudoku objectAtIndex:i]number]] forState:UIControlStateNormal];
                    if ([[solvedSudoku objectAtIndex:i]dug]) {
                        [object setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}

@end
