Hangman Design Doc
===========


## Features 
These are the features that may differ from the original assignment.

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

######custom
When the custom game mode is selected, the user may select his own maximum word length and the amount of incorrectguesses he is allowed to make.

#### Reset High Scores
The user can reset all his current high scores. He may also delete individual scores from the high score list should he wish to clean his list of all the 'noob difficulty' high scores he has set.



### Other Features

Gameplay must starts immediately upon launch. (unless the app was simply backgrounded, in which case gameplay, if in progress prior to backgrounding, should resume).

The app's front side must display placeholders (e.g., hyphens) for yet-unguessed letters that make clear the word’s length.

The app inform the user how many incorrect guesses he or she can still make before losing through a label as well as through progressive changes in the ui colors.

The app indicate to the user which letters he or she has and hasn't guessed through an Attributed label that marks the guessed letters with a color (red for incorrect guess, green for correct).

The user must be able to input guesses via an on-screen keyboard.

The app accepts only non-numeric case-insensitive user input.

Invalid input is ignored.

The app has a new game button and a settings button, the new game button wil appear once a player has made his first guess. At this time the settings button will disappear. Players can only adjust settings at the beginning of each game.

The player is congratulated upon setting a new high score. An image is shown when he loses a game and a gif animation is played upon setting a high score. Alert messages will allow the user to start a new game or view the highscores.

##Database

The database is implemented using Core Data and contains two models: 'GameScore' and 'MatchScore'.
For a visual representation of the database models please refer to the 'datamodel design mockup' file in this folder.

The User settings are saved in NSUserDefaults.

#### GameScore
-->> has_many matchscores

- difficulty  (int)
- gameScore     (int)
- numberOfMatches   (int)

#### MatchScore
--> belongs_to one gamescore

- incorrectGuesses (int)
- matchScore (int)
- word (string)



##Classes and methods


### Models

#### HangManGame
**This class implements the gameplay**

- (void) checkLetter: (NSString *) letterToCheck;
- (void) setupNewMatch: (NSString *) newWord;
- (NSInteger) checkUniqueCharactersInWord: (NSString *)word;
- (NSInteger) setupBaseScore: (NSInteger)charactersInWord;
- (NSUInteger) returnIncorrectGuessesAccordingToDifficulty;
- (NSString *) returnRandomWord;

#### History
**This class implements the methods for storage, retrieval and deletion of high scores.**

- (BOOL) newHighScore: (NSInteger)score
          difficulty:(NSInteger)difficulty
          matchCount:(NSInteger)matchCount;
- (void) createScore;
- (NSArray *) fetchScores;
- (void) deleteAllScores;
- (void) deleteLastScore;


### Controllers

#### MainViewController
This controller controlsthe main view of the hangman game, it initializes the HangManGame.

#### FlipsideViewController
This is controller controls the settings view of the hangman game it uses NSUserDefaults to store settings

#### HighScoreTableViewController
This controller controls the high score table view. It shows the users high scores and associated data.

#### HighScoreDetailTableViewController
This controller controls the detail view that is pushed in when the player taps on a high score in the high 
score view controller. It shows the contents of the high score (a list of the words it contains with the seperate scores).

#### CoreDataTableViewController
This is a controller that is used as a parent for the HighScore and HighScoreDetail viewcontrollers.
It contains logic pertaining to the FetchedResultsViewController that is used to access core data objects in the table view.

Objective - C Style Guide 
========

#### Spacing And Formatting

###### Spaces vs. Tabs
Use only spaces, and indent 4 spaces at a time.

###### Line Length
The maximum line length for Objective-C and Objective-C++ files is 100 columns.

###### Method Declarations and Definitions
One space should be used between the - or + and the return type, and no spacing in the parameter list except between parameters.

###### Method Invocations
Method invocations should be formatted much like method declarations. When there's a choice of formatting styles, follow the convention already used in a given source file.

###### Exceptions
Format exceptions with each @ label on its own line and a space between the @ label and the opening brace ({), as well as between the @catch and the caught object declaration.

###### Protocols
There should not be a space between the type identifier and the name of the protocol encased in angle brackets.

###### Blocks
Code inside blocks should be indented four spaces.

#### Naming

###### File Names
File names should reflect the name of the class implementation that they contain—including case. Follow the convention that your project uses. 

###### Class Names
Class names (along with category and protocol names) should start as uppercase and use mixed case to delimit words.

###### Category Names
Category names should start with a 2 or 3 character prefix identifying the category as part of a project or open for general use. The category name should incorporate the name of the class it's extending.

###### Objective-C Method Names
Method names should start as lowercase and then use mixed case. Each named parameter should also start as lowercase.

###### Variable Names
Variables names start with a lowercase and use mixed case to delimit words. Instance variables have leading underscores. For example: myLocalVariable, _myInstanceVariable.

####Comments
Try writing sensible names to types and variables so your code is self explainatory. 
When writing your comments, write for your audience: the next contributor who will need to understand your code. Be generous—the next one may be you!

######File Comments
A file may optionally start with a description of its contents.

######Declaration Comments
Every interface, category, and protocol declaration should have an accompanying comment describing its purpose and how it fits into the larger picture.

######Implementation Comments
Use vertical bars to quote variable names and symbols in comments rather than quotes or naming the symbol inline.

######Object Ownership
Make the pointer ownership model as explicit as possible when it falls outside the most common Objective-C usage idioms.




####Cocoa and Objective-C Features

######Instance Variables In Headers Should Be @private
Instance variables should typically be declared in implementation files or auto-synthesized by properties. When ivars are declared in a header file, they should be marked @private.

######Identify Designated Initializer
Comment and clearly identify your designated initializer.

######Override Designated Initializer
When writing a subclass that requires an init... method, make sure you override the superclass' designated initializer.

######Overridden NSObject Method Placement
It is strongly recommended and typical practice to place overridden methods of NSObject at the top of an @implementation.

######Initialization
Don't initialize variables to 0 or nil in the init method; it's redundant.

######Keep the Public API Simple
Keep your class simple; avoid "kitchen-sink" APIs. If a method doesn't need to be public, don't make it so. Use a private category to prevent cluttering the public header.

######Use Root Frameworks
Include root frameworks over individual files.

######Properties
Use of the @property directive is preferred, with the following caveat: properties are an Objective-C 2.0 feature which will limit your code to running on the iPhone and Mac OS X 10.5 (Leopard) and higher. Dot notation is allowed only for access to a declared @property.

######Interfaces Without Instance Variables
Omit the empty set of braces on interfaces that do not declare any instance variables.

######Automatically Synthesized Instance Variables
Use of automatically synthesized instance variables is preferred. Code that must support earlier versions of the compiler toolchain (Xcode 4.3 or earlier or when compiling with GCC) or is using properties inherited from a protocol should prefer the @synthesize directive.



