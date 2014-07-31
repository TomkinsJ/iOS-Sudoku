//
//  SudokuViewController.m
//  Sudoku
//
//  Created by John on 26/02/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import "SudokuViewController.h"
#import <sys/utsname.h>

@interface SudokuViewController (){
    NSMutableDictionary *properties;
    NSString *path;
    UIColor *highlightedColour;
}

@end

@implementation SudokuViewController

#define correctColour [UIColor colorWithRed:0/255.0 green:220.0/255.0 blue:0/255.0 alpha:1.0]
#define incorrectColour [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]

@synthesize completeSudoku;
@synthesize incompleteSudoku;
@synthesize activeSudoku;
@synthesize timer;
@synthesize timeDisplay;
@synthesize duration;
@synthesize difficulty;
@synthesize activeCell;
@synthesize previousActiveCell;
@synthesize hintButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

NSString* machineName()
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
    if ((![machineName()isEqualToString:@"iPhone5,1"]) &&
        (![machineName()isEqualToString:@"iPhone5,2"]) &&
        (![machineName()isEqualToString:@"iPhone5,3"]) &&
        (![machineName()isEqualToString:@"iPhone5,4"]) &&
        (![machineName()isEqualToString:@"iPhone6,1"]) &&
        (![machineName()isEqualToString:@"iPhone6,2"]) &&
        (![deviceName isEqualToString:@"iPhone Simulator"]) &&
        ([machineName()rangeOfString:@"ipad"].location == NSNotFound)) {
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
            
            NSString *buttonTitle;
            if ([[incompleteSudoku objectAtIndex:cellCount]dug]) {
                buttonTitle = @"";
            } else {
                buttonTitle = [NSString stringWithFormat:@"%ld", (long)[[incompleteSudoku objectAtIndex:cellCount]number]];
                button.enabled = NO; // this is a given, so disable button
            }
            
            [button setTitle:buttonTitle forState:UIControlStateNormal];
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
    

    
    if ([[properties valueForKey:@"timeAttempts"]boolValue] == YES) {
        [timeDisplay setText:[NSString stringWithFormat:@"0:00"]];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    
    if ([[properties valueForKey:@"showHints"]boolValue] == NO) {
        [hintButton setEnabled:NO];
        [[hintButton titleLabel]setTextColor:[UIColor darkGrayColor]];
    }
    
    activeSudoku = [[NSMutableArray alloc] initWithArray:incompleteSudoku copyItems:YES];
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

- (void)updateTimer
{    
    duration++;
    // If updates timer every second. If seconds (duration % 60) is less than ten, include a 0 preceeding the seconds
    [timeDisplay setText:[NSString stringWithFormat:(long)duration % 60 < 10 ? @"%li:0%ld" : @"%li:%ld", (long)floor(duration / 60.0), (long)duration % 60]];
}

- (IBAction)numberPressed:(id)sender
{
    if (activeCell) {
        
        [[activeSudoku objectAtIndex:[activeCell tag]]setNumber:[[[sender titleLabel]text]integerValue]];
        [activeCell setTitle:[[sender titleLabel]text] forState:UIControlStateNormal];
        [activeCell setBackgroundColor:[UIColor clearColor]];
    
        if ([[properties valueForKey:@"showIncorrect"]boolValue] == YES) {
            if ([[[sender titleLabel]text]integerValue] == [[completeSudoku objectAtIndex:[activeCell tag]]number]) {
                [activeCell setTitleColor:correctColour forState:UIControlStateNormal];
            } else {
                [activeCell setTitleColor:incorrectColour forState:UIControlStateNormal];
            }
        } else {
            [activeCell setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        
        activeCell = nil;
        
        if ([Sudoku doesBoard:activeSudoku MatchBoard:completeSudoku]) {
            [self gameFinished];
        }
    }
}

- (IBAction)clearCell:(id)sender
{
    if (activeCell) {
        [activeCell setTitle:@"" forState:UIControlStateNormal];
        [activeCell setBackgroundColor:[UIColor clearColor]];
        [[activeSudoku objectAtIndex:[activeCell tag]]setNumber:0]; // update active sudoku with clear value
        activeCell = nil;
    }
}

- (IBAction)showHint:(id)sender {
    
    // randomly reveal one of the hidden numbers
    
    if ([[properties valueForKey:@"showHints"]boolValue] == YES) {
        
        bool run = NO;
        
        for (Cell *cell in activeSudoku) {
            if ([cell number] == 0) {
                run = YES;
                break;
            }
        }
        
        if (run) {
            BOOL done = NO;
            while (!done){
                NSInteger randomNumber = arc4random_uniform(81);
                if ([[activeSudoku objectAtIndex:randomNumber]number] == 0) {
                        [[activeSudoku objectAtIndex:randomNumber]setNumber:[[completeSudoku objectAtIndex:randomNumber]number]];
                
                        for(id button in [self.view subviews]) {
                            if ([button isKindOfClass:[UIButton class]]) {
                                if ([button tag] == randomNumber) {
                                
                                    [button setTitle:[NSString stringWithFormat:@"%ld", (long)[[completeSudoku objectAtIndex:randomNumber]number]] forState:UIControlStateNormal];
                                
                                
                                    if ([[properties valueForKey:@"showIncorrect"]boolValue] == YES) {
                                        [button setTitleColor:correctColour forState:UIControlStateNormal];
                                    } else {
                                        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                                    }
                                    done = YES;
                                
                                    if ([Sudoku doesBoard:activeSudoku MatchBoard:completeSudoku]) {
                                        [self gameFinished];
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
}

- (IBAction)reset:(id)sender {
    
    // reset all the numbers user has entered to blank
    for (int i = 0; i <= 80; i++) {
        if ([[activeSudoku objectAtIndex:i]number] != [[incompleteSudoku objectAtIndex:i]number]) {
            [[activeSudoku objectAtIndex:i]setNumber:0];
            for (id object in [self.view subviews]) {
                if ([object isKindOfClass:[UIButton class]]) {
                    if ([object tag] == i) {
                        [object setTitle:@"" forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}

- (void)gameFinished {
    
    // stop timer
    [timer invalidate];
    
    // save time if it's a new best time for this difficulty
    if ([[properties valueForKey:@"timeAttempts"]boolValue] == YES) {
        if (duration < [[properties valueForKey:[NSString stringWithFormat:@"%@Time", difficulty]]integerValue]) {
            [properties setValue:[NSNumber numberWithInteger:duration] forKey:[NSString stringWithFormat:@"%@Time", difficulty]];
        }
    }
    
    // increment number of puzzles completed
    [properties setValue:[NSNumber numberWithInteger:[[properties valueForKey:@"puzzlesCompleted"]integerValue] + 1] forKey:@"puzzlesCompleted"];
    
    [properties writeToFile:path atomically:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Well done!"
                                                   message: @"You have completed this Sudoku"
                                                  delegate: self
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:NO,nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"returnToMainMenu" sender:nil];
    }
}

@end
