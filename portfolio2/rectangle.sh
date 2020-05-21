#Portfolio 2 - Rectangle Script
#Name: Isabella Marchenkov
#Student ID; 10448872

#!/bin/bash 

#If statement 
if ! [ -f rectangle.txt ]; #If 'rectangle.txt' file does not exist
    #Then print error message to terminal and exit
    then
    echo "The rectangle.txt file does not exist."
    exit 0

#The following code will run if the 'rectangle.txt' file does exist
#Each sed commands will be descibed in the below comments respectively:
# 1. At the beginning of the line, add 'Name: '
# 2. Replace the first comma with a tab and 'Height: '
# 3. Replace the next comma with a tab and 'Width: '
# 4. Replace the next comma with a tab and 'Area: '
# 5. Replace the next comma with a tab and 'Colour: '
else 
    sed -e '1d'\
        -e 's/^/Name: /' \
        -e 's/,/\tHeight: / ' \
        -e 's/,/\tWidth: /'\
        -e 's/,/\tArea: /'\
        -e 's/,/\tColour: /' rectangle.txt > rectangle_f.txt #Output the manipulated data from 'rectangle.txt' into 'rectangle_f.txt'
fi

