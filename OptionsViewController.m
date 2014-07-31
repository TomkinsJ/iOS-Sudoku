//
//  OptionsViewController.m
//  Sudoku
//
//  Created by John on 26/02/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import "OptionsViewController.h"
#import "AppDelegate.h"

@interface OptionsViewController (){
    NSMutableDictionary *properties;
    NSString *path;
    UIImageView *background;
}

@end

@implementation OptionsViewController

@synthesize showIncorrectSwitch;
@synthesize showHintsSwitch;
@synthesize timeAttemptsSwitch;
@synthesize colourSegmentedControl;

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
    
    UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [colourSegmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
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
 
    if ([properties objectForKey:@"colourScheme"]) {

        // choose background from options plist
        if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"original"]) {
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackground.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"blue"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackgroundBlue.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"brown"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackgroundBrown.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"purple"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackgroundPurple.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"black"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackgroundBlack.jpg"]];
        }
        
    } else {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackgroundBrown.jpg"]];
        [colourSegmentedControl setSelectedSegmentIndex:2];
        
    }
    
    [self.view addSubview: background];
    background.frame = self.view.bounds;
    [self.view sendSubviewToBack: background];
    self.view.backgroundColor = [UIColor clearColor];

 
    
    if ([[properties valueForKey:@"showIncorrect"]boolValue] == YES) {
        [showIncorrectSwitch setOn:YES];
    } else {
        [showIncorrectSwitch setOn:NO];
    }
    
    if ([[properties valueForKey:@"showHints"]boolValue] == YES) {
        [showHintsSwitch setOn:YES];
    } else {
        [showHintsSwitch setOn:NO];
    }
    
    if ([[properties valueForKey:@"timeAttempts"]boolValue] == YES) {
        [timeAttemptsSwitch setOn:YES];
    } else {
        [timeAttemptsSwitch setOn:NO];
    }
    
    NSString *colourScheme = [properties valueForKey:@"colourScheme"];
    if ([colourScheme isEqualToString:@"original"]) {
        [colourSegmentedControl setSelectedSegmentIndex:0];
    } else if ([colourScheme isEqualToString:@"blue"]){
        [colourSegmentedControl setSelectedSegmentIndex:1];
    } else if ([colourScheme isEqualToString:@"brown"]){
        [colourSegmentedControl setSelectedSegmentIndex:2];
    } else if ([colourScheme isEqualToString:@"purple"]){
        [colourSegmentedControl setSelectedSegmentIndex:3];
    } else if ([colourScheme isEqualToString:@"black"]){
        [colourSegmentedControl setSelectedSegmentIndex:4];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveOptions:(id)sender{
    // get the settings of the switches and save them into plist
    if (showIncorrectSwitch.on) {
        [properties setValue:[NSNumber numberWithBool:YES] forKey:@"showIncorrect"];
    } else {
        [properties setValue:[NSNumber numberWithBool:NO] forKey:@"showIncorrect"];
    }
    
    if (showHintsSwitch.on) {
        [properties setValue:[NSNumber numberWithBool:YES] forKey:@"showHints"];
    } else {
        [properties setValue:[NSNumber numberWithBool:NO] forKey:@"showHints"];
    }
    
    if (timeAttemptsSwitch.on) {
        [properties setValue:[NSNumber numberWithBool:YES] forKey:@"timeAttempts"];
    } else {
        [properties setValue:[NSNumber numberWithBool:NO] forKey:@"timeAttempts"];
    }
    
    switch ([colourSegmentedControl selectedSegmentIndex]) {
        case 0:
            [properties setValue:@"original" forKey:@"colourScheme"];
            break;
        case 1:
            [properties setValue:@"blue" forKey:@"colourScheme"];
            break;
        case 2:
            [properties setValue:@"brown" forKey:@"colourScheme"];
            break;
        case 3:
            [properties setValue:@"purple" forKey:@"colourScheme"];
            break;
        case 4:
            [properties setValue:@"black" forKey:@"colourScheme"];
            break;
        default:
            break;
    }

    [properties writeToFile:path atomically:YES];
}

-(IBAction)changeColourScheme:(id)sender{
    UISegmentedControl *colourPicker = (UISegmentedControl *)sender;
    
    UIImageView *newbackground;
    
    switch ([colourPicker selectedSegmentIndex]) {
        case 0:
            newbackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackground.jpg"]];
            break;
        case 1:
            newbackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackgroundBlue.jpg"]];
            break;
        case 2:
            newbackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackgroundBrown.jpg"]];
            break;
        case 3:
            newbackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackgroundPurple.jpg"]];
            break;
        case 4:
            newbackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GenericBackgroundBlack.jpg"]];
            break;
        default:
            break;
    }
    
    [background removeFromSuperview];
    [self.view addSubview: newbackground];
    newbackground.frame = self.view.bounds;
    [self.view sendSubviewToBack: newbackground];
    self.view.backgroundColor = [UIColor clearColor];
    background = newbackground;
    
}

@end
