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

@property (weak, nonatomic) IBOutlet UILabel *numberOfMatchesInGameLabel;

@property (weak, nonatomic) IBOutlet UISlider *maximumWordLengthSlider;

@property (weak, nonatomic) IBOutlet UISlider *numberOfMatchesInGameSlider;

@property (weak, nonatomic) IBOutlet UISlider *numberOfGuessesAllowedSlider;

@property (weak, nonatomic) IBOutlet UIButton *saveSettingsButton;

@end

@implementation FlipsideViewController

#define kSTEPFRACTION 1

- (IBAction)changeMaximumWordLength:(UISlider *)sender {
    //get current value of slider, round the number.
    UISlider *slider = (UISlider *)sender;
    slider.value = lround(slider.value);
    
    //set slider label
    NSInteger val = slider.value;
    self.maximumWordLengthLabel.text = [NSString stringWithFormat:@"Maximum word length: %d", (int)val];
    
}

- (IBAction)numberOfMatchesInGameSlider:(UISlider *)sender {
    //get current value of slider, round the number.
    UISlider *slider = (UISlider *)sender;
    slider.value = lround(slider.value);
    
    //set slider label
    NSInteger val = slider.value;
    self.numberOfMatchesInGameLabel.text = [NSString stringWithFormat:@"Number of matches in a game: %d", (int)val];
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
    [defaults setInteger:(int)self.numberOfMatchesInGameSlider.value forKey:@"numberOfMatchesInGame"];
    [defaults setInteger:(int)self.numberOfGuessesAllowedSlider.value forKey:@"numberOfGuessesAllowed"];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set slider minimum and maximum values.
    self.maximumWordLengthSlider.maximumValue = 15;
    self.maximumWordLengthSlider.minimumValue = 1;
    
    self.numberOfMatchesInGameSlider.maximumValue = 10;
    self.numberOfMatchesInGameSlider.minimumValue = 1;
    
    self.numberOfGuessesAllowedSlider.maximumValue = 24;
    self.numberOfGuessesAllowedSlider.minimumValue = 1;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSUInteger maxLength = [defaults integerForKey:@"maximumWordLength"];
    NSUInteger matchesInGame = [defaults integerForKey:@"numberOfMatchesInGame"];
    NSUInteger numberOfGuesses = [defaults integerForKey:@"numberOfGuessesAllowed"];
    
    //set maximum word length slider and label to right amount
    self.maximumWordLengthSlider.value = maxLength;
    self.maximumWordLengthLabel.text = [NSString stringWithFormat:@"Maximum word length: %d", (int)maxLength];
    
    //set minimum word length slider and label to right amount
    self.numberOfMatchesInGameSlider.value = matchesInGame;
    self.numberOfMatchesInGameLabel.text = [NSString stringWithFormat:@"Number of matches in a game: %d", (int)self.numberOfMatchesInGameSlider.value];
    
    self.numberOfGuessesAllowedSlider.value = numberOfGuesses;
    self.numberOfGuessesAllowedLabel.text = [NSString stringWithFormat:@"Number of guesses allowed: %d", (int)self.numberOfGuessesAllowedSlider.value];

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

@end
