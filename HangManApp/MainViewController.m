//
//  MainViewController.m
//  HangManApp
//
//  Created by Kim on 24/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewController.h"


@interface MainViewController ()

@property (strong, nonatomic) HangManGame *game;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *incorrectGuessesLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *guessedLettersLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;

@property (nonatomic, retain) IBOutlet UIImageView *hangmanImage;
@property (weak, nonatomic) IBOutlet UITextField *letterInputTextfield;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic, weak) IBOutlet UIWebView *lookupWebView;

@property (nonatomic) float colorSetting;


@end

@implementation MainViewController


#define BUTTON_SETTINGSMODE 1
#define BUTTON_NEWGAMEMODE 2
#define DEFAULT_GAME_MODE 1
#define CUSTOM_GAME_MODE 2

#define GAME_OVER_MESSAGE 1
#define MATCH_WOM_MESSAGE 2
#define NEW_HIGHSCORE_MESSAGE 3
#define RESTART_GAME_MESSAGE 4

//initialize the game
- (HangManGame *)game {
    
    if (!_game) _game = [[HangManGame alloc]init];
    return _game;
}

//method to start a new game.
- (void) restartGame {
    
    // initialize a new game
    self.game = [[HangManGame alloc]init];

    //set up a newWord, update the UI and make the keyboard appear.
    [self.game setupNewMatch];
    [self updateUI:YES];
    [self.letterInputTextfield becomeFirstResponder];
    
    //set the settingsbutton title back to settings.
    [self.settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [self.settingsButton setTag:BUTTON_SETTINGSMODE];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //hide the text input field.
    [self.letterInputTextfield setHidden:YES];
    
    //set up a new match with a new word.
    [self.game setupNewMatch];

    //call updateUI to set the UILabels.
    [self updateUI:YES];
    
    //set the settingsbuttontag to 1 so it links to the settings menu.
    [self.settingsButton setTag:BUTTON_SETTINGSMODE];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // load the keyboard in screen when the view appears so the user doesn't have to first click on the text field before entering a letter.
    [self.letterInputTextfield becomeFirstResponder];

}


#pragma mark - text field
//perhapse change this name or seperate functions.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)inputLetter {
    
    //add already guessed wrong letters to the characterset.
    [self.game.validCharacterSet addCharactersInString:self.game.hangmanMatch.wrongLetters];
    
    NSString *filtered = [[inputLetter componentsSeparatedByCharactersInSet:self.game.validCharacterSet] componentsJoinedByString:@""];
    
    if ([inputLetter isEqual:filtered]) {
        
        //change the settings/new game button so it allows the user to start a new game and disables the settings menu.
        [self.settingsButton setTitle:@"New Game" forState:UIControlStateNormal];
        [self.settingsButton setTag:BUTTON_NEWGAMEMODE];
        
        //convert to lower case and check letter
        inputLetter = [inputLetter lowercaseString];
        [self.game checkLetter:inputLetter];
        
        //if no matching letter was found, check if the match was lost and if a new highscore was reached.
        if (self.game.hangmanMatch.match == NO) {
            
            if (self.game.hangmanMatch.matchLost == YES && self.game.newHighScore == NO) {
                //game over
                [self updateUI:NO];
                [self gameOverMessage];
            } else if (self.game.hangmanMatch.matchLost == YES && self.game.newHighScore == YES) {
                //new high score
                [self updateUI:NO];
                [self newHighScoreMessage];
            } else  {
                
                //the match wasn't lost: update the guessed letter label and the UI.
                [self updateGuessedLetterLabel:inputLetter];
                [self updateUI:NO];
            }
        
        //if a matching letter was found, update the wordlabel and check if the match is won, if so: display matchwon message.
        } else if (self.game.hangmanMatch.match == YES){
            
            self.wordLabel.text = self.game.hangmanMatch.updatedWordToGuess;
            [self updateGuessedLetterLabel:inputLetter];
            
            if (self.game.hangmanMatch.matchWon == YES){
                [self matchWonMessage];
            }
        }
    }
    
    return NO;
    
}


#pragma mark - updateUI

//updates the UI images and adjusts the labels
- (void)updateUI:(BOOL)newGame {
    
    self.scoreLabel.text = [NSString stringWithFormat:@"score: %ld", (long)self.game.hangmanMatch.matchScore];
    
    //if new high score was acheived, show animation and high score message.
    if (self.game.newHighScore == YES) {
        //TODO!!! animation when game is over!
        UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        animatedImageView.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"giphy1.png"],
                                             [UIImage imageNamed:@"giphy2.png"],
                                             [UIImage imageNamed:@"giphy3.png"],
                                             [UIImage imageNamed:@"giphy4.png"],
                                             [UIImage imageNamed:@"giphy5.png"],
                                             [UIImage imageNamed:@"giphy6.png"],
                                             [UIImage imageNamed:@"giphy7.png"],
                                             [UIImage imageNamed:@"giphy8.png"],
                                             [UIImage imageNamed:@"giphy10.png"],
                                             [UIImage imageNamed:@"giphy11.png"],
                                             [UIImage imageNamed:@"giphy12.png"],
                                             [UIImage imageNamed:@"giphy13.png"],
                                             [UIImage imageNamed:@"giphy14.png"],
                                             [UIImage imageNamed:@"giphy15.png"],
                                             [UIImage imageNamed:@"giphy16.png"],
                                             [UIImage imageNamed:@"giphy17.png"],
                                             [UIImage imageNamed:@"giphy18.png"], nil];
        animatedImageView.animationDuration = 1.0f;
        animatedImageView.animationRepeatCount = 2;
        [animatedImageView startAnimating];
        [self.view addSubview: animatedImageView];
        
    //if game was lost
    } else if (self.game.hangmanMatch.matchLost == YES) {
        self.hangmanImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.hangmanImage.image = [UIImage imageNamed:@"moon-01"];
        [self.view addSubview:self.hangmanImage];
        
    } else if (self.game.hangmanMatch.match == NO) {
        
        //adjust to the color to the guessedLeftSettings so the changerate is according to the amount of guessses left.
        self.colorSetting = self.colorSetting - (1.0 / self.game.incorrectGuessesSetting);
        self.view.backgroundColor = [UIColor colorWithRed:self.colorSetting
                                                    green:self.colorSetting
                                                     blue:self.colorSetting
                                                    alpha:self.colorSetting];
        
        //adjust the text color to white if background gets to below 0.5
        if (self.colorSetting < 0.5) {
            self.wordLabel.textColor = [UIColor whiteColor];
            self.scoreLabel.textColor = [UIColor whiteColor];
            self.matchCountLabel.textColor = [UIColor whiteColor];
            self.difficultyLabel.textColor = [UIColor whiteColor];
            
            self.incorrectGuessesLeftLabel.textColor = [UIColor whiteColor];
        }
        
        //Update guesses left
        self.incorrectGuessesLeftLabel.text = [NSString stringWithFormat:@"Guesses left: %lu",(unsigned long)self.game.hangmanMatch.incorrectGuessesLeft];
    }
    //if it's a new game, reset ui colors and update the labels.
    if (newGame == YES) {

        //change the colors to the starting colors (white background,
        self.colorSetting = 1;
        self.view.backgroundColor = [UIColor whiteColor];
        self.wordLabel.textColor = [UIColor blackColor];
        self.scoreLabel.textColor = [UIColor blackColor];
        self.matchCountLabel.textColor = [UIColor blackColor];
        self.guessedLettersLabel.textColor = [UIColor blackColor];
        self.incorrectGuessesLeftLabel.textColor = [UIColor blackColor];
        self.difficultyLabel.textColor = [UIColor blackColor];
        
        self.matchCountLabel.text = [NSString stringWithFormat:@"match: %lu", (unsigned long)self.game.currentMatchNumber];
        self.hangmanImage.image = nil;
        self.wordLabel.text = @"";
        self.wordLabel.text = self.game.hangmanMatch.updatedWordToGuess;
        self.guessedLettersLabel.text = @"abcdefghijklmnopqrstuvwxyz";
        self.incorrectGuessesLeftLabel.text = [NSString stringWithFormat:@"Guesses left: %lu",(unsigned long)self.game.incorrectGuessesSetting];
        
        if (self.game.gameMode == DEFAULT_GAME_MODE) {
            self.difficultyLabel.text = [NSString stringWithFormat:@"Difficulty: %@", [self difficulties:self.game.difficultyRating]];
        } else if (self.game.gameMode == CUSTOM_GAME_MODE) {
            self.difficultyLabel.text = @"Difficulty: Custom";
        }

    }
}

- (void)updateGuessedLetterLabel:(NSString *)letter {
    
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc]initWithAttributedString:self.guessedLettersLabel.attributedText];
    
    
    //get the range of the guessed letter in the labelstring, create an Attributed string with the label text to change the colour of the letter.
    NSRange range = [self.guessedLettersLabel.text rangeOfString:letter];
    
    if (self.game.hangmanMatch.match == NO) {
        
        //replace letter in label with a red coloured one
        [labelText setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
        
    } else if (self.game.hangmanMatch.match == YES) {
        
        //replace letter in label with a green coloured one.
        [labelText setAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor]} range:range];
        
    }
    
    self.guessedLettersLabel.attributedText = labelText;
    
    
}


# pragma mark - alert messages

// if retry button is pressed, set up a new game else Show High Score
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == GAME_OVER_MESSAGE) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            
            //load the WebViewController to show a dictionary to look up the correct word.
            [self performSegueWithIdentifier:@"showWebView" sender:self];
            [self restartGame];
        } else {
            //start a new game
            [self restartGame];
        }
    } else if (alertView.tag == MATCH_WOM_MESSAGE) {
        if (buttonIndex == [alertView cancelButtonIndex]) {

            //load the WebViewController to show a dictionary to look up the correct word
            //then start a new match.
            [self performSegueWithIdentifier:@"showWebView" sender:self];
            [self.game setupNewMatch];
            [self updateUI:YES];
            [self.letterInputTextfield becomeFirstResponder];

        } else {
            //set up a new word, update ui and retrieve keyboard.
            [self.game setupNewMatch];
            [self updateUI:YES];
            [self.letterInputTextfield becomeFirstResponder];
        }
    } else if (alertView.tag == NEW_HIGHSCORE_MESSAGE) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [self performSegueWithIdentifier:@"showHighScore" sender:self];
            [self restartGame];
        } else {
            //start a new game.
            [self restartGame];
        }
    } else if (alertView.tag == RESTART_GAME_MESSAGE) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            //show the keyboards again
            [self.letterInputTextfield becomeFirstResponder];
        } else {
            [self restartGame];
        }
    }
    
}

//create a dictionary URL from the correct word.
- (NSString *)dictionaryLinkFromWord: (NSString *)word {
    
    NSString *url = [NSString stringWithFormat:@"http://dictionary.reference.com/browse/%@?s=t", word];
    return url;
}

- (IBAction)gameOverMessage {
    
    NSString *message = [NSString stringWithFormat:@"The correct word was: %@", self.game.hangmanMatch.correctWord];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GAME OVER"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Lookup Word"
                                          otherButtonTitles:@"Retry", nil];
    [alert setTag:GAME_OVER_MESSAGE];
    [alert show];
    [self.letterInputTextfield resignFirstResponder];
}

- (IBAction)matchWonMessage {
    
    NSString *message = [NSString stringWithFormat:@"Match Score: %ld  Total score: %ld", (long)self.game.hangmanMatch.matchScore, (long)self.game.gameScore];
    
    NSString *title = [NSString stringWithFormat:@"Match %ld won!", (long)self.game.currentMatchNumber];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Lookup Word"
                                          otherButtonTitles:@"Next Match", nil];
    [alert setTag:MATCH_WOM_MESSAGE];
    [alert show];
    [self.letterInputTextfield resignFirstResponder];
}

- (IBAction)newHighScoreMessage {
    
    NSString *message = [NSString stringWithFormat:@"Score: %ld \nCorrect word: %@", (long)self.game.gameScore, self.game.hangmanMatch.correctWord];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NEW HIGH SCORE!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"High Scores"
                                          otherButtonTitles:@"New Game", nil];
    [alert setTag:NEW_HIGHSCORE_MESSAGE];
    [alert show];
    [self.letterInputTextfield resignFirstResponder];
}

- (IBAction)restartGameMessage {
    
    NSString *message = @"Are you sure you want to start a new game?";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start New Game"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert setTag:RESTART_GAME_MESSAGE];
    [alert show];
    [self.letterInputTextfield resignFirstResponder];
}



#pragma mark - Flipside View Controller

- (IBAction)settingsAndRestartButton:(id)sender {
    
    //if tag is 1: SettingsAndNewGameButton = 'Settings' else: 'New Game'.
    if (self.settingsButton.tag == BUTTON_SETTINGSMODE) {
        //perform segue to the flipside viewcontroller.
        [self performSegueWithIdentifier:@"showAlternate" sender:self];
    } else if (self.settingsButton.tag == BUTTON_NEWGAMEMODE) {
        
        [self restartGameMessage];
    }
    
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
    //restart the game for settings to take effect.
    [self restartGame];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        FlipsideViewController *flipsideViewController = [segue destinationViewController];
        flipsideViewController.currentHistory = self.game.history;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
    
    if ([[segue identifier] isEqualToString:@"showWebView"])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        WebViewController *webViewController = (WebViewController *)navController.topViewController;
        
        // Pass URL
        webViewController.loadURL = [NSURL URLWithString:[self dictionaryLinkFromWord:self.game.hangmanMatch.correctWord]];
    }
}


- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}


#pragma mark - High Score View Controller

- (void)HighScoreViewControllerDidFinish:(HighScoreTableViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
    //restart the game for settings to take effect.
    [self restartGame];
}

- (NSString *)difficulties: (NSInteger)value {
    return @[@"Noob", @"Very easy", @"Easy", @"Moderate",@"Hard", @"Very hard",@"Deity"][value-1];
    
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
