#!/bin/bash

echo -e "\e[0;97m _   _      _                 ____  _      _   \e[0m   \e[1;33m   _ \e[0m    
\e[0;97m| | | |_ __| |__   __ _ _ __ |  _ \(_) ___| |_  \e[0m\e[1;33m ___| |__  \e[0m
\e[0;97m| | | | '__| '_ \ / _\` | '_ \| | | | |/ __| __| \e[0m\e[1;33m/ __| '_ \ \e[0m
\e[0;97m| |_| | |  | |_) | (_| | | | | |_| | | (__| |_ \e[0m\e[1;33m_\__ \ | | |\e[0m
\e[0;97m \___/|_|  |_.__/ \__,_|_| |_|____/|_|\___|\__\e[0m\e[1;33m(_)___/_| |_|\e[0m                                                          
"
#That is called ASCII Art and I generated it with figlet 

#Colors codes and functions to change them in-line
cwhite='\e[0;97m'
cyellow='\e[1;33m'
clear='\e[0m'

colWhite(){
    echo -ne $cwhite$1$clear
}
colYellow(){
    echo -ne $cyellow$1$clear
}

echo -e "\e[32mType 'yolo' to leave. Because you only live once.\e[0m"
echo -e "\e[32mStandart format to search is \"$(colWhite UrbanDict)$(colYellow '.sh>') word number_of_results\e[32m\"\e[0m"
echo -e "\e[32mBut it is also okay if you write \"$(colWhite UrbanDict)$(colYellow '.sh>') word\e[32m\" number_of_results will be max number as default\e[0m"
echo -e "\e[32mIf the phrase you are searching for has more than 1 word please insert '+' between words.\e[0m"
echo -e "\e[32mex:'Rush B Cyka Blyat' must be searched as 'rush+b+cyka+blyat' or 'Rush+B+Cyka+Blyat'\e[0m"
echo -e "\e[0;31mSome words may be shown red because these result's words are diffirent.\e[0m"
#Some tutorial and a warning
printf "\n"

#Program wont work if you don't put the key below
#And make sure you write your api key adjacent to 'API_KEY=' It should be looking like : API_KEY=1234 or API_KEY='1234'
API_KEY= #Your API KEY here if you don't know what you should instert please just check the Readme.md


#THE FUNCTION 
main(){
    echo -n "$(colWhite UrbanDict)$(colYellow '.sh>') "
	read query count #Getting the query word or phrase, and getting the number of queries that the user want to see
    
    if [[ $query == yolo ]] #Checks if the user wants to leave the program
    then
        exit 0
    fi

    count=${count:-100} #I assumed there wont be more than 100 answers :D  

    #API does it's thing I made a GET request in silent mode to get the JSON data
	output=$(curl -s --request GET --url "https://mashape-community-urban-dictionary.p.rapidapi.com/define?term=${query}"  --header 'x-rapidapi-host: mashape-community-urban-dictionary.p.rapidapi.com' --header "x-rapidapi-key: ${API_KEY}" | jq .list)
    #Building output dictionary including only necessary parts
    output=$(echo $output | jq .[0:${count}] | jq '[.[] | {def: .definition, author: .author, word: .word}]')
    
    #Formatting the query to check if the phrase or word is matching with the result
    query=${query//+/ } #Changing plusses into spaces
    query=${query,,} #Lowercase

    printf "\n"
    counter=0
    #You have to be familiar with jq to understand how I parsed the JSON (https://stedolan.github.io/jq/) here is the link
    while [[ $counter -lt $count ]] && [[ $(echo $output | jq .[$counter]) != null ]] 
    do #Counter goes 0 to $count, and we are also checking if we are at the last entry or not
        formatted=$(echo $output | jq .[$counter].word) 
        formatted=${formatted:1:-1} #Removing Apostrophes coming with jq
        formatted=${formatted,,}
        if [[ $formatted != $query ]] #If query and answer are not same it shows the word
        then
            echo -e "\e[0;31mWord: \"$formatted\"\e[0m"
        fi
        formatted=$(echo $output | jq .[$counter].def)
        echo "$((counter+1))) ${formatted:1:-1}" #Removing Apostrophes coming with jq
        echo -e $(colYellow "Author: $(echo $output | jq .[$counter].author)") #Showing the Author of the entry
        ((counter++))
        printf "\n"
    done
    main
}
main
                                                                                  
