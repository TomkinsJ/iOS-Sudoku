//
//  StatisticsViewController.m
//  Sudoku
//
//  Created by John on 26/02/2014.
//  Copyright (c) 2014 John Tomkins. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController (){
    NSMutableDictionary *properties;
    NSString *path;
}

@end

@implementation StatisticsViewController

@synthesize puzzlesCompletedLabel;
@synthesize easyTimeLabel;
@synthesize mediumTimeLabel;
@synthesize hardTimeLabel;

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
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StatsBackground.jpg"]];
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
    
    [puzzlesCompletedLabel setText:[NSString stringWithFormat:@"%@", [properties valueForKey:@"puzzlesCompleted"]]];

    if ([[properties valueForKey:@"easyTime"]integerValue] < 10000000) {
        [easyTimeLabel setText:[NSString stringWithFormat:(long)[[properties valueForKey:@"easyTime"]integerValue] % 60 < 10 ? @"%li:0%ld" : @"%li:%ld", (long)floor([[properties valueForKey:@"easyTime"]integerValue] / 60.0), (long)[[properties valueForKey:@"easyTime"]integerValue] % 60]];
    }
    
    if ([[properties valueForKey:@"mediumTime"]integerValue] < 10000000){
        [mediumTimeLabel setText:[NSString stringWithFormat:(long)[[properties valueForKey:@"mediumTime"]integerValue] % 60 < 10 ? @"%li:0%ld" : @"%li:%ld", (long)floor([[properties valueForKey:@"mediumTime"]integerValue] / 60.0), (long)[[properties valueForKey:@"mediumTime"]integerValue] % 60]];
    }
    
    if ([[properties valueForKey:@"hardTime"]integerValue] < 10000000) {
        [hardTimeLabel setText:[NSString stringWithFormat:(long)[[properties valueForKey:@"hardTime"]integerValue] % 60 < 10 ? @"%li:0%ld" : @"%li:%ld", (long)floor([[properties valueForKey:@"hardTime"]integerValue] / 60.0), (long)[[properties valueForKey:@"hardTime"]integerValue] % 60]];
    }
}

- (IBAction)clearStats:(id)sender{

    [properties setValue:[NSNumber numberWithInteger:10000000] forKey:@"easyTime"];
    [properties setValue:[NSNumber numberWithInteger:10000000] forKey:@"mediumTime"];
    [properties setValue:[NSNumber numberWithInteger:10000000] forKey:@"hardTime"];
    [properties setValue:[NSNumber numberWithInteger:0] forKey:@"puzzlesCompleted"];
    
    [puzzlesCompletedLabel setText:@"0"];
    [easyTimeLabel setText:@"Not set"];
    [mediumTimeLabel setText:@"Not set"];
    [hardTimeLabel setText:@"Not set"];

    [properties writeToFile:path atomically:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
