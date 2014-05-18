Hangman Design Doc
===========


Features (that may differ from the assignment)
==========

### Matches and Games
A game consists of multiple matches (words that should be guessed). If a word is guessed than that counts as one match, afterwhich the player will automatically progress to the next word to be guessed. The scores of the individual matches are added to eachother and combined form the 'gamescore'. A player will continue guessing words until he either fails to guess a word or chooses to start a new game. If the user fails to guess a given word the game is over and the resulting score will be checked for a possible high score. If a highscore was reached the player will be rewarded with a message and some animation.

### High Scores
The game score will be appended to the high score database if that score is higher than the already existing High Scores.
The high score database only contains 10 scores. If an 11th score is added to it, the lowest score will be removed.

The high scores are shown in a table view. Each cell showing: the score, the number of words guessed and the difficulty. If the player taps on a high score in the table he/she will be shown another table view that contains a list of the words that the player has guessed in the selected game together with the amount of incorrect guesses for each word.

###Settings

#### Difficulty Setting

######default
This hangman game has two setting types: custom and default. Default mode means that the type of words and the amount of incorrect guesses the player can make are dependent on a difficulty level.

The difficulty levels are: noob, very easy, easy, moderate, hard, very hard, deity.

Because the word length does not determine the difficulty this setting will take the number of unique characters in each word into account instead of just the length.
The higher the difficulty the higher the amount of unique characters in the words the player has to guess and the lower the amount of incorrect guesses he can make.
The words will be filtered accoring to unique characters.

#####custom
When the custom game mode is selected, the user may select his own maximum word length and the amount of incorrectguesses he is allowed to make.

#### Reset High Scores
The user can reset all his current high scores. He may also delete individual scores from the high score list should he wish to clean his list of all the 'noob difficulty' high scores he has set.


Database
==========
The database is implemented using Core Data and contains two models: 'GameScore' and 'MatchScore'.
For a visual representation of the database models please refer to the 'databasemockup.png' file in this folder.

#### GameScore
-->> has_many matchscores

- difficulty  (int)
- gameScore     (int)
- numberOfMatches   (int)

#### MatchScore
--> belongs_to one gamescore

- incorrectGuesses (int)
- matchScore (int)
- word (string



Classes and methods
========

#### HangManGame
This class implements the gameplay

- (void) checkLetter: (NSString *) letterToCheck;
- (void) setupNewMatch: (NSString *) newWord;
- (NSInteger) checkUniqueCharactersInWord: (NSString *)word;
- (NSInteger) setupBaseScore: (NSInteger)charactersInWord;
- (NSUInteger) returnIncorrectGuessesAccordingToDifficulty;
- (NSString *) returnRandomWord;

#### History
This class implements the methods for storage, retrieval and deletion of high scores.

- (BOOL)newHighScore: (NSInteger)score
          difficulty:(NSInteger)difficulty
          matchCount:(NSInteger)matchCount;

- (void)createScore;
- (NSArray *)fetchScores;

- (void)deleteAllScores;


Objective - C Style Guide 
========

#### Spacing And Formatting

- Spaces vs. Tabs

Use only spaces, and indent 4 spaces at a time.

- Line Length

The maximum line length for Objective-C and Objective-C++ files is 100 columns.

- Method Declarations and Definitions

One space should be used between the - or + and the return type, and no spacing in the parameter list except between parameters.

- Method Invocations

Method invocations should be formatted much like method declarations. When there's a choice of formatting styles, follow the convention already used in a given source file.

- Exceptions

Format exceptions with each @ label on its own line and a space between the @ label and the opening brace ({), as well as between the @catch and the caught object declaration.

- Protocols

There should not be a space between the type identifier and the name of the protocol encased in angle brackets.

- Blocks

Code inside blocks should be indented four spaces.

#### Naming

- Any class, category, method, or variable name may use all capitals for initialisms within the name.


- File Names

File names should reflect the name of the class implementation that they contain—including case. Follow the convention that your project uses. 

- Class Names

Class names (along with category and protocol names) should start as uppercase and use mixed case to delimit words.

- Category Names

Category names should start with a 2 or 3 character prefix identifying the category as part of a project or open for general use. The category name should incorporate the name of the class it's extending.

- Objective-C Method Names

Method names should start as lowercase and then use mixed case. Each named parameter should also start as lowercase.

Variable Names

Variables names start with a lowercase and use mixed case to delimit words. Instance variables have leading underscores. For example: myLocalVariable, _myInstanceVariable.



