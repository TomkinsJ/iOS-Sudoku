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
}

@end

@implementation OptionsViewController

@synthesize showIncorrectSwitch;
@synthesize showHintsSwitch;
@synthesize timeAttemptsSwitch;

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
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OtherBackground.jpg"]];
    [self.view addSubview: background];
    background.frame = self.view.bounds;
    [self.view sendSubviewToBack: background];
    self.view.backgroundColor = [UIColor clearColor];
    
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
    [properties writeToFile:path atomically:YES];
    
}

@end
