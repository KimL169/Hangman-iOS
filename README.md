Hangman-iOS
===========

Hangman application for the iphone
This application will allow users to guess words that are randomly pulled from a dictionary. 
If the word is guessed within the allowed amount of guesses the user will progress to the next word
The game will end once the user isn't able to guess a word within the allowed amount of guesses.
A final score will consist of the combined scores of the words that the user guessed in one 'winning streak'.


? = ideas to implement if there is time left.

Features
===========

##### MAIN VIEW
1. word to be guessed label
2. text input
3. on screen keyboard
4. guessed-letter label
5. incorrect guesses left label
6. settings bar-button
7. high score bar-button
8. victory image (or gif animation)
9. game over image (or gif animation)
10. UIcolor change incrementally for each incorect guess 
11. alert view if match is won
** show score for match and total score.
** next match button.
12. alert view if game is over.
⋅⋅* show correct word (that wasn't guessed)
⋅⋅* button to view high scores
⋅⋅* button to start new game

##### SETTINGS VIEW
..* slider contRol for amount of incorrect guesses
..* slider control for maximum word length
..* reset button to reset high scores and user statistics (?)
...* alert view if user wants to reset scores  (?)

##### HIGH SCORE VIEW
..* high score tabLe
...* shows total score
...* shows amount of words guessed
..* ability to click table items to go into detail view.
..* back button

##### HIGH SCORE DETAIL VIEW
..* table view
...* show all guessed words in the game and their seperate scores.
...* back button


Framework and libraries.
===========
- Objective - C
- Foundation
- Cocoa Touch
..* Core Data (still uncertain, for high scores).
