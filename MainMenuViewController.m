//
//  ViewController.m
//  Sudoku
//
//  Created by John on 24/02/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController (){
    NSMutableDictionary *properties;
    NSString *path;
}
@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainMenuBackground.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"blue"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainMenuBackgroundBlue.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"brown"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainMenuBackgroundBrown.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"purple"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainMenuBackgroundPurple.jpg"]];
        } else if ([[properties valueForKey:@"colourScheme"]isEqualToString:@"black"]){
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainMenuBackgroundBlack.jpg"]];
        }
        
    } else {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainMenuBackgroundBrown.jpg"]];

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

@end
