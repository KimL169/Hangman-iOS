//
//  MainViewController.m
//  HangManApp
//
//  Created by Kim on 24/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "MainViewController.h"



@interface MainViewController ()

@property (strong, nonatomic) HangManGame *game;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *incorrectGuessesLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *guessedLettersLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;

@property (nonatomic, retain) IBOutlet UIImageView * hangmanImage;
@property (weak, nonatomic) IBOutlet UITextField *letterInputTextfield;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (nonatomic) float colorSetting;


@end

@implementation MainViewController

//initialize the game
- (HangManGame *)game {
    
    if (!_game) _game = [[HangManGame alloc]init];
    return _game;
}

//method to start a new game.
- (void) restartGame {
    
    // initialize a new game
    self.game = [[HangManGame alloc]init];

    //set up a newWord
    [self.game setupNewMatch:[self.game returnRandomWord]];
    
    //update the UI
    [self updateUI:YES];
    
    //make keyboard appear
    [self.letterInputTextfield becomeFirstResponder];
    
    //set the settingsbutton title back to settings.
    [self.settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [self.settingsButton setTag:1];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //hide the text input field.
    [self.letterInputTextfield setHidden:YES];
    //set up a new word.
    [self.game setupNewMatch:[self.game returnRandomWord]];

    //call updateUI to reset the images.
    [self updateUI:YES];
    
    //set the settingsbuttontag to 1 so it links to the settings menu.
    [self.settingsButton setTag:1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // load the keyboard in screen when the view appears so the user doesn't have to first click on the text field before entering a letter.
    [self.letterInputTextfield becomeFirstResponder];

}


#pragma mark - text field
//perhapse change this name or seperate functions.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)inputLetter {
    
    // make sure the user can only input letters.
    NSMutableCharacterSet *cs = [[[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet] mutableCopy];

    //add already guessed wrong letters to the characterset.
    [cs addCharactersInString:self.game.wrongLetters];
    
    NSString *filtered = [[inputLetter componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if ([inputLetter isEqual:filtered]) {
        
        //change the settings/new game button.
        [self.settingsButton setTitle:@"New Game" forState:UIControlStateNormal];
        [self.settingsButton setTag:2];
        
        
        //convert to lower case and check letter
        inputLetter = [inputLetter lowercaseString];
        [self.game checkLetter:inputLetter];
        
        //if no match was found
        if (self.game.match == NO) {
            
            //if this was the player's last guess.
            if (self.game.incorrectGuessesLeft == 0) {
                
                //check if new high score was reached, if so:
                if ([self.game.history newHighScore:self.game.gameScore
                                         difficulty:self.game.difficultyRating
                                         matchCount:self.game.currentMatchNumber] == YES) {
                    
                    self.game.newHighScore = YES;
                    [self updateUI:NO];
                } else {
                    [self updateUI:NO];
                    
                    [self gameOverMessage];
                }

            } else {
                //update the UIimages and guessedLetterLabel
                [self updateGuessedLetterLabel:inputLetter];
                [self updateUI:NO];
            }
            
        } else if (self.game.match == YES){
            
            self.wordLabel.text = self.game.updatedWordToGuess;
            
            //check if the player has won a match or has won the game, else update guessedletterlabel.
            if (self.game.matchWon == YES){
                [self matchWonMessage];
            } else {
                //moet de UI update method dit niet doen.
                [self updateGuessedLetterLabel:inputLetter];
            }
        }
    }
    
    return NO;
    
}


#pragma mark - updateUI

//updates the UI images and adjusts the labels
- (void)updateUI:(BOOL)newGame {
    
    self.scoreLabel.text = [NSString stringWithFormat:@"score: %ld", (long)self.game.matchScore];
    
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
        
        [self newHighScoreMessage];
        
    //if game was lost
    } else if (self.game.gameLost == YES) {
        
        UIImage *hangManImage = [[UIImage alloc]initWithContentsOfFile:@"moon-01.png"];
        self.hangmanImage.image = hangManImage;
        
    } else if (self.game.match == NO) {
        
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
        self.incorrectGuessesLeftLabel.text = [NSString stringWithFormat:@"Guesses left: %lu",(unsigned long)self.game.incorrectGuessesLeft];
    }
    
    if (newGame == YES) {

        //change the colors to the starting colors.
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
        self.wordLabel.text = self.game.updatedWordToGuess;
        self.guessedLettersLabel.text = @"abcdefghijklmnopqrstuvwxyz";
        self.incorrectGuessesLeftLabel.text = [NSString stringWithFormat:@"Guesses left: %lu",(unsigned long)self.game.incorrectGuessesSetting];
        
        if (self.game.gameMode == 1) {
            self.difficultyLabel.text = [NSString stringWithFormat:@"Difficulty: %@", [self difficulties:self.game.difficultyRating]];
        } else if (self.game.gameMode == 2) {
            self.difficultyLabel.text = @"Difficulty: Custom";
        }

    }
}

- (void)updateGuessedLetterLabel:(NSString *)letter {
    
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc]initWithAttributedString:self.guessedLettersLabel.attributedText];
    
    
    //get the range of the guessed letter in the labelstring, create an Attributed string with the label text to change the colour of the letter.
    NSRange range = [self.guessedLettersLabel.text rangeOfString:letter];
    
    if (self.game.match == NO) {
        
        //replace letter in label with a red coloured one
        [labelText setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
        
    } else if (self.game.match == YES) {
        
        //replace letter in label with a green coloured one.
        [labelText setAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor]} range:range];
        
    }
    //update the label
    self.guessedLettersLabel.attributedText = labelText;
    
    
}


# pragma mark - alert messages

// if retry button is pressed, set up a new game else Show High Score
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //tag 1 = 'gameOverMessage, tag 2 = 'matchWonMessage', tag 3 = 'newHighScoreMessage', tag 4 = 'restartGameMessage'
    if (alertView.tag == 1) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            
            //show the high scores and restart game.
            [self performSegueWithIdentifier:@"showHighScore" sender:self];
            [self restartGame];
        } else {
            NSLog(@"Incorrect guessses left : %lu", (unsigned long)self.game.incorrectGuessesLeft);
            //start a new game
            [self restartGame];
        }
    } else if (alertView.tag == 2) {
        //set up a new word, update ui and retrieve keyboard.
        [self.game setupNewMatch:[self.game returnRandomWord]];
        [self updateUI:YES];
        [self.letterInputTextfield becomeFirstResponder];
        
    } else if (alertView.tag == 3) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [self performSegueWithIdentifier:@"showHighScore" sender:self];
            [self restartGame];
        } else {
            //start a new game.
            [self restartGame];
        }
    } else if (alertView.tag == 4) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            //show the keyboards again
            [self.letterInputTextfield becomeFirstResponder];
        } else {
            [self restartGame];
        }
    }
    
}

- (IBAction)gameOverMessage {
    
    NSString *message = [NSString stringWithFormat:@"The correct word was: %@", self.game.correctWord];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GAME OVER"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"High Scores"
                                          otherButtonTitles:@"Retry", nil];
    [alert setTag:1];
    [alert show];
    [self.letterInputTextfield resignFirstResponder];
}

- (IBAction)matchWonMessage {
    
    NSString *message = [NSString stringWithFormat:@"Match Score: %ld  Total score: %ld", (long)self.game.matchScore, (long)self.game.gameScore];
    
    NSString *title = [NSString stringWithFormat:@"Match %ld won!", (long)self.game.currentMatchNumber];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Next Match", nil];
    [alert setTag:2];
    [alert show];
    [self.letterInputTextfield resignFirstResponder];
}

- (IBAction)newHighScoreMessage {
    
    NSString *message = [NSString stringWithFormat:@"Score: %ld", (long)self.game.gameScore];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New HIGH SCORE!!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"High Scores"
                                          otherButtonTitles:@"New Game", nil];
    [alert setTag:3];
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
    [alert setTag:4];
    [alert show];
    [self.letterInputTextfield resignFirstResponder];
}



#pragma mark - Flipside View Controller

- (IBAction)settingsAndRestartButton:(id)sender {
    
    //if tag is 1: SettingsAndNewGameButton = 'Settings' else: 'New Game'.
    if (self.settingsButton.tag == 1) {
        //perform segue to the flipside viewcontroller.
        [self performSegueWithIdentifier:@"showAlternate" sender:self];
    } else if (self.settingsButton.tag == 2) {
        
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
