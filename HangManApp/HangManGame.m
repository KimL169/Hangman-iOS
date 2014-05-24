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

//default game mode means player can set difficulty which will determine unique characters in words
//to guess as well as the number of incorrect guesses that the player is allowed to make.
//custom game setting means the player can select a maximum wordl ength and incorrect guesses allowed.
#define DEFAULT_GAME_MODE 1
#define CUSTOM_GAME_MODE 2

#pragma mark initialization

- (instancetype) init {
    
    self = [super init]; //super's designated initializer
    
    if (self) {
        
        //create the game settings.
        [self createDefaultGameSettings];
        
        // create the wordlist.
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"words" withExtension:@"plist"];
        self.wordList = [NSArray arrayWithContentsOfURL:url];
        self.newHighScore = NO;
        self.currentMatchNumber = 0;
        
        //init a history object to manage highscores;
        self.history = [[History alloc]init];
    }
    return self;
}



#pragma mark - new match setup

- (void) setupNewMatch {
    
    //keep track of the number of matches in a game.
    self.currentMatchNumber += 1;
    
    //set up a new match with the correct parameters.
    self.hangmanMatch = [[Match alloc] initWithCorrectWord:[self returnRandomWord] incorrectGuessesSetting:self.incorrectGuessesSetting];

    //make a valid character set so the user input can be checked for valid letters and ignored if not valid.
    self.validCharacterSet = [[[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet] mutableCopy];
}


#pragma mark - score

- (void) updateGameScore { self.gameScore += self.hangmanMatch.matchScore; }


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
    }
    
    //check if a game difficulty setting has been set, else, set a default.
    if ([defaults integerForKey:@"gameDifficulty"]) {
        self.difficultyRating = [defaults integerForKey:@"gameDifficulty"];
    } else {
        //set default value and save default to database.
        self.difficultyRating = 3;
        [defaults setInteger:self.difficultyRating forKey:@"gameDifficulty"];
    }
    
    //check if a gameMode has been selected..
    if ([defaults integerForKey:@"gameMode"]) {
        self.gameMode = [defaults integerForKey:@"gameMode"];
    } else {
        //set default value and save to database.
        self.gameMode = DEFAULT_GAME_MODE;
        [defaults setInteger:self.gameMode forKey:@"gameMode"];
    }
    
    //if game mode is custom, set incorrect guessessetting to the user preferred or default, else use those according to difficulry.
    if (self.gameMode == CUSTOM_GAME_MODE) {
        if ([defaults integerForKey:@"numberOfGuessesAllowed"]) {
            self.incorrectGuessesSetting = [defaults integerForKey:@"numberOfGuessesAllowed"];
        } else {
            //Standard Default
            self.incorrectGuessesSetting = 6;
            [defaults setInteger:self.incorrectGuessesSetting forKey:@"numberOfGuessesAllowed"];
        }
        
    } else {
        self.incorrectGuessesSetting = [self returnIncorrectGuessesAccordingToDifficulty];
    }
    
    //save the data to NSUserDefaults.
    [defaults synchronize];
    
}


#pragma mark - word setup

- (NSString *) returnRandomWord {
    
    NSString *word = [[NSString alloc]init];
    
    //if the game mode is 1 select a word with the right difficulty
    //else select a word with the user specified max-length.
    
    if (self.gameMode == DEFAULT_GAME_MODE) {
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
                return [word lowercaseString];
            }
            
        }
    } else if (self.gameMode == CUSTOM_GAME_MODE) {

        while (true) {
            // pull a random word from the wordList.
            uint32_t rnd = arc4random_uniform((int)[self.wordList count]);
            word = self.wordList[rnd];
            
            //check if the word is the correct length and return.
            if (word.length <= self.wordLengthMaximum) {
                return [word lowercaseString];
            }
        }

    }
    
       //return a random word from the list
    return [word lowercaseString];
    
}

- (void) checkLetter:(NSString *)letterToCheck {
    
    [self.hangmanMatch checkLetter:letterToCheck];

    //if the match has been won, update the game score and store the match.
    //if the match was lost, check if a new high score was found, if so, let the controller know.
    if (self.hangmanMatch.matchWon == YES) {
        [self updateGameScore];
        [self storeMatchScore];
    } else if (self.hangmanMatch.matchLost == YES) {
        if ([self.history newHighScore:self.gameScore
                            difficulty:self.difficultyRating
                            matchCount:self.currentMatchNumber] == YES) {
            
            self.newHighScore = YES;
        }
        
    }
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
    return [uniqueCharactersInWord length];
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

- (void)storeMatchScore {
    [self.history newMatchScore:self.hangmanMatch.matchScore
                           word:self.hangmanMatch.correctWord
               incorrectGuesses: (self.incorrectGuessesSetting - self.hangmanMatch.incorrectGuessesLeft)];
}
@end
