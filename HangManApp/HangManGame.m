//
//  hangManGame.m
//  HangManApp
//
//  Created by Kim on 25/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "hangManGame.h"


@interface HangManGame()

@property (nonatomic, strong) NSArray *wordList;
@property (nonatomic) NSInteger scoreMultiplier;

@end

@implementation HangManGame


#pragma mark initialization

- (instancetype) init {
    
    self = [super init]; //super's designated initializer
    
    if (self) {
        
        //create the game settings.
        [self createDefaultGameSettings];
        
        // create the wordlist.
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"words" withExtension:@"plist"];
        self.wordList = [NSArray arrayWithContentsOfURL:url];
        //set game started to NO, game will start once a Player inserts his first letter to check.
        self.gameStarted = NO;
        self.newHighScore = NO;
        self.updatedWordToGuess = [[NSString alloc]init];
        self.currentMatchNumber = 0;
        
        //init a history object to manage highscores;
        self.history = [[History alloc]init];

    }
    return self;
}



#pragma mark - new match setup

- (void) setupNewMatch:(NSString *)newWord {
    
    //set game started to no.
    self.gameStarted = NO;
    
    //reset the wrong letters, the word to guess and guesses.
    self.matchWon = NO;
    self.gameLost = NO;
    self.match = NO;
    self.incorrectGuessesLeft = self.incorrectGuessesSetting;
    self.updatedWordToGuess = @"";
    self.correctWord = [newWord lowercaseString];
    self.wrongLetters = @"";
    self.currentMatchNumber += 1;
    
    //check unique letters in newWord to calculate the base score for a game.
    self.matchScore = [self setupBaseScore:[self checkUniqueCharactersInWord:self.correctWord]];
    
    //fill the wordLabel up with '_'* the length of the word to be quessed
    for (int i =0; i <newWord.length; i++) {
        self.updatedWordToGuess = [self.updatedWordToGuess stringByAppendingString: @"-"];
    }
    
}

#pragma mark - score setup

- (NSInteger) setupBaseScore: (NSInteger)charactersInWord {
    return charactersInWord * 30;
}

- (void) updateMatchScore {
    if (self.matchScore > 0) {
        self.matchScore -= 5;
    }
}

- (void) updateGameScore { self.gameScore += self.matchScore; }



#pragma mark - create game settings

//set up game settings, if there are user settings present, load them, otherwise create default settings.
- (void) createDefaultGameSettings {
    
    // create user defaults to store settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //check if maximumWordLength has been set, else, fill in default
    if ([defaults integerForKey:@"maximumWordLength"]) {
        self.wordLengthMaximum = [defaults integerForKey:@"maximumWordLength"];
    } else {
        // set default value and save to database
        self.wordLengthMaximum = 15;
        [defaults setInteger:self.wordLengthMaximum forKey:@"maximumWordLength"];
        NSLog(@"created new wordlength");
        
    }
    
    //check if a game difficulty setting has been set, else, set a default.
    if ([defaults integerForKey:@"gameDifficulty"]) {
        self.difficultyRating = [defaults integerForKey:@"gameDifficulty"];
    } else {
        //set default value and save default to database.
        self.difficultyRating = 3;
        [defaults setInteger:self.difficultyRating forKey:@"gameDifficulty"];
        NSLog(@"created new gameDifficulty");
        
    }
    
    //check if a gameMode has been selected (1 = default(difficulty mode), 2 = custom).
    if ([defaults integerForKey:@"gameMode"]) {
        self.gameMode = [defaults integerForKey:@"gameMode"];
    } else {
        //set default value and save to database.
        self.gameMode = 1;
        [defaults setInteger:self.gameMode forKey:@"gameMode"];
        NSLog(@"created new gameMode");
    }
    
    //if game mode is custom, set incorrect guessessetting to the user preferred or default, else use those according to difficulry.
    if (self.gameMode == 2) {
        if ([defaults integerForKey:@"numberOfGuessesAllowed"]) {
            self.incorrectGuessesSetting = [defaults integerForKey:@"numberOfGuessesAllowed"];
        } else {
            //Standard Default
            self.incorrectGuessesSetting = 6;
            [defaults setInteger:self.incorrectGuessesSetting forKey:@"numberOfGuessesAllowed"];
            NSLog(@"created new guessesAllowed");
        }
        
    } else {
        self.incorrectGuessesSetting = [self returnIncorrectGuessesAccordingToDifficulty];
    }
    
    //save the data to NSUserDefaults.
    [defaults synchronize];
    
}





#pragma mark - letter check

- (void) checkLetter:(NSString *)letterToCheck {
    
    //set game started to YES to not allow user to change settings at this point.
    self.gameStarted = YES;
    self.match = NO;
    NSRange letterRange;

    // check each letter in the word for a match.
    char check = [letterToCheck characterAtIndex:0];
    for (int i=0; i < self.correctWord.length; i++) {
        char temp = [self.correctWord characterAtIndex:i];

        //if match is found add matching letter to letter label.
        if (check == temp) {

            self.match = YES;
            letterRange = NSMakeRange(i, 1);//location, length
            
            //update the word to guess.
            self.updatedWordToGuess = [self.updatedWordToGuess stringByReplacingCharactersInRange:letterRange
                                                                                       withString:letterToCheck];
        }
    }
    //if match is NO: update the wrongletter variable, the incorrect guesses left and the match score.
    if (self.match == NO) {
        if (self.incorrectGuessesLeft == 1) {
            self.gameLost = YES;
        }
        //remore the occurence of the character in the wrong letter string if it already exists then append wrong letter.
        self.wrongLetters = [self.wrongLetters stringByReplacingOccurrencesOfString:letterToCheck withString:@""];
        self.wrongLetters = [self.wrongLetters stringByAppendingString:letterToCheck];
        
        //update the guesses the player has left
        self.incorrectGuessesLeft = self.incorrectGuessesSetting - [self.wrongLetters length];
        
        //update the matchScore
        [self updateMatchScore];

    } else {
        
        //check if the the match is won.
        if ([self.correctWord isEqualToString:self.updatedWordToGuess]) {

            self.matchWon = YES;
 
            //update the gameScore with the matchScore
            [self updateGameScore];
        }
    }
}



#pragma mark - word setup

- (NSString *) returnRandomWord {
    
    NSString *word = [[NSString alloc]init];
    
    //if the game mode is 1 select a word with the right difficulty
    //else select a word with the user specified max-length.
    
    if (self.gameMode == 1) {
        while (true) {
            // pull a random word from the wordlist.
            u_int32_t rnd = arc4random_uniform((int)[self.wordList count]);
            word = self.wordList[rnd];
            
            //check the number of unique characters in the word, it should be self.difficultyRating * 2 (with a +1 -1 margin).
            [self checkUniqueCharactersInWord:word];
            
            if ([self checkUniqueCharactersInWord:word] > ((self.difficultyRating *2)+1)
                || [self checkUniqueCharactersInWord:word] < ((self.difficultyRating * 2)-1)) {
                
                continue;
            } else {
                return word;
            }
            
        }
    } else if (self.gameMode == 2) {

        while (true) {
            // pull a random word from the wordList.
            uint32_t rnd = arc4random_uniform((int)[self.wordList count]);
            word = self.wordList[rnd];
            
            //check if the word is the correct length.
            if (word.length <= self.wordLengthMaximum) {
                return word;
            }
        }

    }
    
       //return a random word from the list
    return word;
    
}

#pragma mark - utility functions.

//returns the number of unique characters in a word.
- (NSInteger) checkUniqueCharactersInWord: (NSString *)word {
    //get all the unique characters in a string.
    NSString *uniqueCharactersInWord = [[NSString alloc]init];
    
    for (int i = 0; i<word.length; i++) {
        char correctChar = [word characterAtIndex:i];
        bool match = NO;
        
        for (int j = 0; j<uniqueCharactersInWord.length; j++) {
            char uniqueChar = [uniqueCharactersInWord characterAtIndex:j];
            if (uniqueChar == correctChar) {
                match = YES;
            }
        }
        //if the letter is not already encountered: append to uniqueCharactersInWord.
        if (match == NO) {
            NSString *str = [NSString stringWithFormat:@"%c", correctChar];
            uniqueCharactersInWord = [uniqueCharactersInWord stringByAppendingString:str];
        }
    }
    //return the number of unique characters.
    return [uniqueCharactersInWord length];;
}

//return the right incorrectGuessesSetting for the difficulty level.
- (NSUInteger) returnIncorrectGuessesAccordingToDifficulty {
    
    switch (self.difficultyRating) {
        case 1:
            return 20;
            break;
        case 2:
            return 16;
        case 3:
            return 12;
        case 4:
            return 9;
        case 5:
            return 7;
        case 6:
            return 3;
        case 7:
            return 1;
        default:
            break;
    }
    return 10;
}

@end
