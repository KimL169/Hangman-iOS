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

- MAIN VIEW
-- word to be guessed label
-- text input
-- on screen keyboard
-- guessed-letter label
-- incorrect guesses left label
-- settings bar-button
-- high score bar-button
-- victory image (or gif animation)
-- game over image (or gif animation)
-- UIcolor change incrementally for each incorect guess 
-- alert view if match is won
--- show score for match and total score.
--- next match button.
-- alert view if game is over.
--- show correct word (that wasn't guessed)
--- button to view high scores
--- button to start new game

- SETTINGS VIEW
-- slider contRol for amount of incorrect guesses
-- slider control for maximum word length
-- reset button to reset high scores and user statistics (?)
--- alert view if user wants to reset scores  (?)

- HIGH SCORE VIEW
-- high score tabLe
--- shows total score
--- shows amount of words guessed
-- ability to click table items to go into detail view.
-- back button

- HIGH SCORE DETAIL VIEW
-- table view
--- show all guessed words in the game and their seperate scores.
-- back button


Framework and libraries.
===========
- Objective - C
- Foundation
- Cocoa Touch
-- Core Data (still uncertain, for high scores).
