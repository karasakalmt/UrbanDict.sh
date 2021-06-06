#!/bin/bash

echo -e "\e[0;97m _   _      _                 ____  _      _   \e[0m   \e[1;33m   _ \e[0m
\e[0;97m| | | |_ __| |__   __ _ _ __ |  _ \(_) ___| |_  \e[0m\e[1;33m ___| |__  \e[0m
\e[0;97m| | | | '__| '_ \ / _\` | '_ \| | | | |/ __| __| \e[0m\e[1;33m/ __| '_ \ \e[0m
\e[0;97m| |_| | |  | |_) | (_| | | | | |_| | | (__| |_ \e[0m\e[1;33m_\__ \ | | |\e[0m
\e[0;97m \___/|_|  |_.__/ \__,_|_| |_|____/|_|\___|\__\e[0m\e[1;33m(_)___/_| |_|\e[0m
"
#That is called ASCII Art and I generated it with figlet

#Checking if flags are used appropriately
if [[ $# -gt 0 ]] && [[ $1 != "--hidden-wise" ]]
then
  echo -e "\e[0;31mSorry there is no such flag called $1 try using '--hidden-wise' as first arguement instead.\e[0m"
  exit 0
fi
if [[ $# -gt 2 ]]
then
  echo -e "\e[0;31mAt most 2 arguement can be applicable '--hidden-wise' and no_of_queries.\e[0m"
  exit 0
fi

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

if [[ $# -eq 0 ]]
then
  echo -e "\e[32mType 'yolo' to leave. Because you only live once.\e[0m"
  echo -e "\e[32mStandart format to search is \"$(colWhite UrbanDict)$(colYellow '.sh>') word number_of_results\e[32m\"\e[0m"
  echo -e "\e[32mBut it is also okay if you write \"$(colWhite UrbanDict)$(colYellow '.sh>') word\e[32m\" number_of_results will be max number as default\e[0m"
  echo -e "\e[32mIf the phrase you are searching for has more than 1 word please insert '+' between words.\e[0m"
  echo -e "\e[32mex:'Rush B Cyka Blyat' must be searched as 'rush+b+cyka+blyat' or 'Rush+B+Cyka+Blyat'\e[0m"
  echo -e "\e[0;31mSome words may be shown red because these result's words are different.\e[0m"
  #Some tutorial and a warning
  printf "\n"
else #Showing text for hidden wise mode
  printf "\033[0;31mHidden Wise Mode:\033[0m In hidden wise mode you can query words in your screen by selecting them. You now have your hidden wise who searches deeps of Urban Dictionary for you instantly.\n"
  printf "\033[0;31mHidden Wise Mode:\033[0m use ^Z to leave this mode\n"
fi


#Program wont work if you don't put the key below
#And make sure you write your api key adjacent to 'API_KEY=' It should be looking like : API_KEY=1234 or API_KEY='1234'
API_KEY= #Your API KEY here if you don't know what you should instert please just check the Readme.md
#Checking if API key exists
if [[ -z $API_KEY ]]
then
  echo -e "\e[0;31mPlease put an API key and retry. If you dont know how to you can find it on (https://github.com/patern0ster/UrbanDict.sh#how-to-install-urbandictsh).\e[0m"
  exit 0
fi


#This function is for reading your selection with mouse as input
#hidden_wise is Forked from (https://github.com/bugaevc/wl-clipboard)
hidden_wise() {
  trap break INT
  if [ "$is_macos" = yes ]; then
    past=$(pbpaste)
  else
    if [ "$XDG_SESSION_TYPE" = wayland ]; then
      past=$(wl-paste -p)
    else
      past=$(xsel -o)
    fi
  fi
	while true; do
    if [ "$is_macos" = yes ]; then #If session macos use pbppaste
      current=$(pbpaste)
    else
      if [ "$XDG_SESSION_TYPE" = wayland ]; then #If
        current=$(wl-paste -p) #İf session wayland use wl-paste
      else
        current=$(xsel -o) #if session others use xsel
      fi
    fi
    if [ "$past" != "$current" ]; then #setting variables
      past=$current
      result=$current
      break
    fi
    sleep 1;
	done
  trap - INT
}

#THE FUNCTION
main(){
  echo -n "$(colWhite UrbanDict)$(colYellow '.sh>') " #Printing the UrbanDict.sh

  if [[ $# -eq 0 ]] #Checking the mode if it is normal mode takes the query and/or count
  then
  	read query count #Getting the query word or phrase, and getting the number of queries that the user want to see
    if [[ $query == yolo ]] #Checks if the user wants to leave the program
    then
      exit 0
    fi
  fi
	if [[ $# -ge 1 ]] #Checks if Hidden Wise mode on.
	then
	  hidden_wise #Executing select catching part
	  query=${result// /+} #Formatting query to be able to use in curl
    
    if [[ ${#result} -lt 2 ]]
    then
      main $1 $2
    fi
    
    if [[ $# -eq 2 ]] #Checking if $2 is set if set
    then
      count=$2
    fi
    echo $query
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
      formatted=${formatted,,} #Lowercase
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
  main $1 $2 #passing the arguements in main func again
}
main $1 $2 #passing the arguements in main func

