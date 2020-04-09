#Portfolio Task 1 - Guess Age Script
#Isabella Marchenkov - 10448872

#!/bin/bash 

#Print welcome message in terminal
echo "----Welcome to Guess the Age!----" 

#Generate a random number between 20 and 70 using $RANDOM function and storing it in variable: randomage
randomage=$(((20+($RANDOM % 50))))
n='your'

#Create a while loop to carry out main part of program, user interation and error handling
while true; 
do
  #While loop for error handling
  while true;
  do
    read -p "Enter $n guess, between 20 and 70: " guess #Asks user to enter their guess and reads it.

    #Tests thats user has entered an integer for each of their guesses and if they havent, print error message.
    [[ $guess =~ ^[0-9]+$ ]] || { echo -e "You entered:\e[1;37m $guess\e[1;31m\nOnly enter a number please.\e[0m Try again."; continue; }
    #If the guess is equal or greater than 20 and equal or less than 70, print the guess the user has entered.
    if ((guess >= 20 && guess <= 70)); 
    then
      echo -e "You entered:\e[1;37m$guess\e[0m" #Guess coloured white
      break #Breaks out of loop to continue with user interataction
    #Else statement prints out the guess and that it it not in range between 20 and 70. Repeats until valid guess enetered.
    else
      echo -e "You entered:\e[1;37m$guess\e[0m" #Guess coloured white
      echo -e "\e[1;31mThat is out of the range.\e[0m Try again." #Coloured red
    fi
  done

  #If the guess equals the randomly generated age, Print that that user is correct, break loop and end program
  if [ $guess -eq $randomage ]; 
    then
    echo -e "\e[1;35mYou're right!\e[0m Thank you for playing." #Coloured magenta
    break; #Break loop

  #Else for anything where guess doesnt equal the random age
  else
    if [ $guess -lt $randomage ]; #If guess is less than the random age
      then
      echo -e "Your guess is too\e[1;34m low\e[0m. Keep going." # Print that their guess is too low #Coloured blue
    elif [ $guess -gt $randomage ]; #If guess is greater than the random age 
      then
      echo -e "Your guess is too\e[1;33m high\e[0m. Keep going." #Print that their guess is too high #Coloured yellow 
    fi
  fi
  n='another' #Changes "your" in the prompt to "another" after the first valid guess attmept. 
done