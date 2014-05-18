//
//  FlipsideViewController.m
//  HangManApp
//
//  Created by Kim on 24/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"
#import "HangManGame.h"

@interface FlipsideViewController ()

@property (weak, nonatomic) IBOutlet UILabel *maximumWordLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGuessesAllowedLabel;
@property (weak, nonatomic) IBOutlet UISlider *maximumWordLengthSlider;
@property (weak, nonatomic) IBOutlet UISlider *numberOfGuessesAllowedSlider;
@property (weak, nonatomic) IBOutlet UIButton *saveSettingsButton;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UISlider *difficultySlider;
@property (nonatomic, strong) UIAlertView *alertView;



@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSwitch;

@property (nonatomic) NSInteger gameMode;

@end

@implementation FlipsideViewController

@synthesize currentHistory;

#define kSTEPFRACTION 1

- (IBAction)changeMaximumWordLength:(UISlider *)sender {
    //get current value of slider, round the number.
    UISlider *slider = (UISlider *)sender;
    slider.value = lround(slider.value);
    
    //set slider label
    NSInteger val = slider.value;
    self.maximumWordLengthLabel.text = [NSString stringWithFormat:@"Maximum word length: %d", (int)val];
    
}
- (IBAction)resetHighScores:(UIButton *)sender {
    //show alert message
    [self resetHighScoreMessage];
}

// if retry button is pressed, set up a new game else Show High Score
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == [alertView cancelButtonIndex]) {
        // nothing
    } else {
        //delete all high scores
        [self.currentHistory deleteAllScores];
    }

}


- (IBAction)resetHighScoreMessage {
    
    self.alertView = [[UIAlertView alloc]initWithTitle:@"Reset All High Scores"
                                               message:@"Do you wish to delete all your previous high scores?"
                                              delegate:self
                                     cancelButtonTitle:@"No"
                                     otherButtonTitles:@"Yes", nil];

    [self.alertView show];
}

- (IBAction)changeDifficulty:(UISlider *)sender {
    UISlider *slider = (UISlider *)sender;
    slider.value = lround(slider.value);
    
    //set slider label
    NSInteger val = slider.value;
    self.difficultyLabel.text = [NSString stringWithFormat:@"Difficulty: %@", [self difficulties:val]];
}



- (NSString *)difficulties: (NSInteger)value {
    return @[@"Noob", @"Very easy", @"Easy", @"Moderate",@"Hard", @"Very hard",@"Deity"][value-1];
    
}

- (IBAction)numberOfGuessesSlider:(UISlider *)sender {
    //get current value of slider, round the number.
    UISlider *slider = (UISlider *)sender;
    slider.value = lround(slider.value);
    
    //set slider label
    NSInteger val = slider.value;
    self.numberOfGuessesAllowedLabel.text = [NSString stringWithFormat:@"Number of guesses allowed: %d", (int)val];
}



//when save settings is pressed
- (IBAction)saveSettingsButton:(UIButton *)sender {
    
    // save the selected settings.
    [self saveSettings];
}


- (void)saveSettings {

    // create user defaults to store settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //set the user default settings from the slider values.
    [defaults setInteger:(int)self.maximumWordLengthSlider.value forKey:@"maximumWordLength"];
    [defaults setInteger:(int)self.numberOfGuessesAllowedSlider.value forKey:@"numberOfGuessesAllowed"];
    [defaults setInteger:(int)self.difficultySlider.value forKey:@"gameDifficulty"];
    [defaults setInteger:(int)self.gameMode forKey:@"gameMode"];
    
    //save the data.
    [defaults synchronize];
    
    //go back to the MainViewController
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

//match mode segment control.
- (IBAction)changeMatchMode:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.gameMode = 1;
    } else {
        self.gameMode = 2;
    }
    [self gameModeUISettings];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //set slider minimum and maximum values.
    self.maximumWordLengthSlider.maximumValue = 20;
    self.maximumWordLengthSlider.minimumValue = 1;
    self.numberOfGuessesAllowedSlider.maximumValue = 26;
    self.numberOfGuessesAllowedSlider.minimumValue = 1;
    self.difficultySlider.minimumValue = 1;
    self.difficultySlider.maximumValue = 7;
    
    //load user defaults and set the UI elements to the right values.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults integerForKey:@"gameMode"]) {
        self.gameMode = [defaults integerForKey:@"gameMode"];
    } else {
        self.gameMode = 1;
    }
    
    //get the User Default values.
    NSUInteger maxLength = [defaults integerForKey:@"maximumWordLength"];
    NSUInteger numberOfGuesses = [defaults integerForKey:@"numberOfGuessesAllowed"];
    NSUInteger gameDifficulty = [defaults integerForKey:@"gameDifficulty"];

    //set the sliders to the right amount
    self.maximumWordLengthSlider.value = maxLength;
    self.numberOfGuessesAllowedSlider.value = numberOfGuesses;
    self.difficultySlider.value = gameDifficulty;
    
    //set the labels to the right text.
    self.maximumWordLengthLabel.text = [NSString stringWithFormat:@"Maximum word length: %d", (int)maxLength];
    self.numberOfGuessesAllowedLabel.text = [NSString stringWithFormat:@"Number of guesses allowed: %d", (int)self.numberOfGuessesAllowedSlider.value];
    self.difficultyLabel.text = [NSString stringWithFormat:@"Difficulty: %@", [self difficulties:gameDifficulty]];
    //set the match mode segment control to right value.
    self.gameModeSwitch.selectedSegmentIndex = (self.gameMode-1);
    
    



    
    //check the game mode and adjust the UI accordingly
    [self gameModeUISettings];
}

- (void)gameModeUISettings {
    if (self.gameMode == 1) {
        [self.maximumWordLengthSlider setUserInteractionEnabled:NO];
        [self.numberOfGuessesAllowedSlider setUserInteractionEnabled:NO];
        [self.maximumWordLengthLabel setTextColor:[UIColor grayColor]];
        [self.numberOfGuessesAllowedLabel setTextColor:[UIColor grayColor]];
        [self.difficultyLabel setTextColor:[UIColor whiteColor]];
        [self.difficultySlider setUserInteractionEnabled:YES];
    } else if (self.gameMode == 2) {
        [self.maximumWordLengthSlider setUserInteractionEnabled:YES];
        [self.numberOfGuessesAllowedSlider setUserInteractionEnabled:YES];
        [self.maximumWordLengthLabel setTextColor:[UIColor whiteColor]];
        [self.numberOfGuessesAllowedLabel setTextColor:[UIColor whiteColor]];
        [self.difficultyLabel setTextColor:[UIColor grayColor]];
        [self.difficultySlider setUserInteractionEnabled:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

//make sure the user can only play the game in portrait mode
- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}

@end
