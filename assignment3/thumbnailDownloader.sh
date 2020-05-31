#Assignment: Software Based Solution
#Name: Isabella Marchenkov
#Student ID: 10448872

#!/bin/bash

#-----------------------------------------------------------------------------------------------------
#Main Menu Fucntion
function mainMenu(){
    #Print main menu title
    echo -e "Main Menu\n"
    #Prompt user for thier input being a number 1-5
    PS3='Please enter your choice (1-5):'
    #The name of the functions are stored in a variable called options
    options=("Download a specific thumbnail" "Download all thumbnails" "Download a range of thumbnails" "Download a specific number of random thumbnails" "Quit program")
    select opt in "${options[@]}"
    do
        case $opt in
            #When user inputs "1" they will choose specific thumbnail download
            "Download a specific thumbnail")
                specificThumbnail #Call the specific thumbnail function
                break #Break from the menu function
                ;;
            #When user inputs "2" they will choose all thumbnail download
            "Download all thumbnails")
                allThumbnails #Call all thumbnail function
                break #Break out of menu function
                ;;
            #When user inputs "3" they will choose range thumbnail download
            "Download a range of thumbnails")
                rangeThumbnail #Call range thumbnail function
                break #break out of the menu function 
                ;;
            #When user inputs "4" they will choose random thumbnail download
            "Download a specific number of random thumbnails")
                randomThumbnail #Call random thumbnail function
                break #Break from the menu function
                ;;
            #When user inputs "5" they will choose to quit the program
            "Quit program")
                #Print exit message
                echo -e "\nQuitting Program"
                echo "Goodbye!"
                break #break from main menu function, which ends program
                ;;
            #When the user inputs anything other than the numbers 1-5, it will print an error message
            *) 
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

#------------------------------------------------------------------------------------------------------
#Function for downloading a specific thumbnail
function specificThumbnail(){
    #Prompt user to input the name of the specific thumbail
    echo "Please enter the full name of the specific thumbnail you wish to download: "
    read specificChoice #Read the users input and store it in variable

    #Search for the user's input in the url.txt file
    if grep -q "$specificChoice" ./url.txt 
    then
        #If the user's input is found, insert the choice into the URL's format from url.txt and move is to a new file
        if grep -io "https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/${specificChoice}.jpg$" url.txt >toBeDownloaded.txt
        then
            #Download the thumbnail from the url stored in toBeDownloaded.txt into the thumbnail folder
            if wget -q -i toBeDownloaded.txt -P ECU_Cyber_Thumbnails
            then
                #Search for the file (Content-Length) size using wget and spider and storing in variable
                fileSize="$(wget -i toBeDownloaded.txt --spider --server-response -qO - 2>&1 | sed -ne '/Content-Length/{s/.* //;p}')"
                #Divide the file size by 1024, with 2 decimal points using bc, to convert the byte size of the image to KBs
                fileSizeKB=`echo "scale=2; $fileSize / 1024" | bc`
                #Print out the thumbnail thats being downloaded, along with the thumbnails filesize in KB
                echo -e "\nDownloading $specificChoice, with the file name $specificChoice.jpg, with the file size of $fileSizeKB K ..."
                echo -e "File Download Complete\n"
            else
                #Error message if the specific thumbnail couldnnt be downloaded
                echo -e "\nError: $specificChoice could not be downloaded.\n"
            fi
        else
            #Error message and exit if the transfering of the specific choice URL into the toBeDOwnloaded file didnt work.
            echo -e "\nTransfer did not work. Try again.\n"
            exit 1
        fi
    else
        #Error message if user enters an invalid thumbnail name
        echo -e "\nThis thumbnail doesnt exsit. Returning to menu...\n"
    fi
    #Call the main menu function to start again. 
    mainMenu
}

#-----------------------------------------------------------------------------------------------------
#Fucntion for downloading all thumbnails
function allThumbnails(){
    #Using sed, input all the urls (urls starting with "https"), in new file toBeDownloaded.txt
    sed -n '/^https/p' url.txt > toBeDownloaded.txt
    #Print confirmation message of the user's choice
    echo -e "\nYou've chosen to download all thumbnails. Please wait..."
    
    #Download the thumbnail from the urls stored in toBeDownloaded.txt into the thumbnail folder
    if wget -q -i toBeDownloaded.txt -P ECU_Cyber_Thumbnails
    then
        #If successful, print a message confirming the download
        echo -e "\nAll thumbnails have been downloaded.\n"
    else
        #If failed, print error message that the download fail. 
        echo -e "\nError: All thumbnails could not be downloaded. Returning to menu...\n"
    fi
    #Call the main menu function to start again. 
    mainMenu
}

#-----------------------------------------------------------------------------------------------------
#Fucntion for downloading a range of thumbnails
function rangeThumbnail(){
    #Prompt user to enter the last 4 digits of thumbail to be the start of the range
    echo -e "\nEnter the last 4 digits of the thumbnail at the start of the range: "
    read startRange #Store input in variable

    #Prompt user to enter the last 4 digits of thumbail to be the start of the range
    echo -e "\nEnter the last 4 digits of the thumbnail at the end of the range: "
    read endRange #Store input in variable

    #Usinf grep to find results after the startRange variable and before endRange variable with a buffer of 100 and store in toBeDownloaded.txt
    if grep -A100 $startRange url.txt | grep -B100 $endRange > toBeDownloaded.txt
    then
        #If successful, download the thumbnail from the urls stored in toBeDownloaded.txt into the thumbnail folder
        if wget -q -i toBeDownloaded.txt -P ECU_Cyber_Thumbnails
        then
            #Print message that the thumbnails have been downloaded
            echo -e "\nThumbnail range has been downloaded!\n"
        else
            #Print error message that the thumbnails couldnt be downloaded
            echo -e "\nError: Range of thumbnails could not be downloaded.\n"
        fi
    else
        #Error message and exit if the transfering of the range of URLs into the toBeDOwnloaded file didnt work.
        echo -e "\nTransfer fail. Returning to menu...\n"
    fi
    #Call the main menu function to start again
    mainMenu
}

#-----------------------------------------------------------------------------------------------------
#Fucntion for downloading a range of random thumbnails
function randomThumbnail(){
    #Prompt user to input number of random thumbails they's like to download
    echo -e "\nHow many random thumbnails would you like to download?\n"
    read randomChoice #Store input in variable
    #Confirmation message of how many they chose
    echo -e "\nYou chose to download $randomChoice thumbnail(s)\n"

    #Shuf command chooses random lines from a file
    #-n choses number of random lines, in this case it is the number that the user entered. The store them in toBeDownloaed.txt
    shuf -n $randomChoice url.txt >toBeDownloaded.txt
    #If successful, download the thumbnails from the urls stored in toBeDownloaded.txt into the thumbnail folder
    if wget -q -i toBeDownloaded.txt -P ECU_Cyber_Thumbnails
    then    
        #Print success message
        echo -e "\nThe random thumbnails have been downloaded\n"
    else
        #Print error message
        echo -e "\nError: Thumbnail(s) could not be downloaded. Returning to menu...\n"
    fi
    #Call main menu function to start again. 
    mainMenu
}
#------------------------------------------------------------------------------------------------------
#Connect to the gallery website (in silent mode and direct output to /dev/null) and store the http code in variable called status
status=$(curl -w %{http_code} -s -o /dev/null https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152)

#If the status does not equal 200 then print an error message displaying what the status code is
if [[ "$status" -ne 200 ]] ; 
    then
    echo "Website status code has changed to $status. Please try again."
    break
#If the status code does equal 200 then print message confirming connection
else
    echo -e "Connection request Successful. Program starting...\n"
fi

#------------------------------------------------------------------------------------------------------
#Use curl and sed to grab the thumbnail urls from the page's html and place them into a file called "page.html". 
curl 'https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152' -so 'page.html'
#Sed commmand searching for lines in page.html starting with "img" and includes "src=" 
#Input the lines into file called "url.txt' 
#-n creates new lines,
sed -E -n '/<img/s/.*src="([^"]*)".*/\1/p' page.html >url.txt

#Check if the directory in which the thumbnails will be downloaded exists
#Store the directory in a variable called DIR
DIR="./ECU_Cyber_Thumbnails/"
#If the directory doesnt exist...
if [ ! -d "$DIR" ];
    then
        mkdir ECU_Cyber_Thumbnails #make the directory in the current directory
fi

#Print the welcome message the main menu
echo -e "| = = = = Welcome to Thumbnail Downloader! = = = = = |\n" 

#Call mainMenu function
mainMenu