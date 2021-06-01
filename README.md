# ![UrbanDict.sh](img/UrbanDictsh.png)
## What is UrbanDict.sh?
It is a very simple bash tool in wich you can query words in Urban Dictionary, and get definitions via using Unofficial Urban Dictionary API from rapidapi.

## How to use UrbanDict.sh?
After following installation proccess you will already be able to open the program. So there are two types of inputs in program one of them is. word: Query String, number_of_results: Integer number of results user wants to see.
```shell
UrbanDict.sh> word number_of_results
```
Or a lazy user can just type the word and list all the available definitions.
```shell
UrbanDict.sh> word
```
### Single Word Query
**Lazy user:**  
![example1](img/example1.png)  
**Hardworking nerd user:**  
![example2](img/example2.png)  
### Multi Word Query
Sometimes you might want to search for word phrase, and you can but there is only rule you have to combine words with '+' ex:'``Rush B Cyka Blyat``' must be searched as '``rush+b+cyka+blyat``' or '``Rush+B+Cyka+Blyat``'.
**Lazy user:**  
![example_multi1](img/multi-ex1.png)
**Hardworking nerd user:**  
![example_multi2](img/multi-ex2.png)
### What are those red words?
Sometimes your query doesn't match with exact word, or there are high rated and semanticly/syntacticly close word(s) to your query so in this case these close words shows up with their definitions below. 
![example_red](img/red-text.png)
## How to install UrbanDict.sh?
I am programming bash for 2 days so I will only be able to show how I use it like a real noob 😎.  
Firstly clone the repo to your local.
```git
$ git clone https://github.com/patern0ster/UrbanDict.sh.git
```

After cloning, you have to get an API key from [this link](https://rapidapi.com/community/api/urban-dictionary). Which takes you to urban dictionaries' unofficial API on [RapidAPI](https://rapidapi.com). You have to sign up or sign in to get your X-RapidAPI-Key, after signing in make sure you copy your API key on your clipboard. Now you are about to be ready to start using the UrbanDict.sh.  

As 3rd step open the ``UrbanDict.sh`` on your favorite text editor. And add your X-RapidAPI-Key to specified place and in specified format.
```shell
#Program wont work if you don't put the key below
#And make sure you write your api key adjacent to 'API_KEY=' 
#It should be looking like : API_KEY=1234 or API_KEY='1234'
API_KEY=

```

Now you are ready to use the program. As first way you have to go to the directory where you cloned the UrbanDict.sh and giving every permission to the program.  
```shell
$ chmod 777 UrbanDict.sh
$ ./UrbanDict.sh
```

Or you can simply do:

```shell
$ bash UrbanDict.sh
```
## Conclusion
I hope this little project can help you to improve your skills as well, I definitely had fun while writing code for this project. It is completely okay if you want to use the code on another project. Thank you for reading.