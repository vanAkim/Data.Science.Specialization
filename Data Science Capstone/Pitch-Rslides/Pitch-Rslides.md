Next word prediction: back-off model
========================================================
author: Akim van Eersel
date: 2021-01-14
autosize: true


Introduction
========================================================

This presentation is made to pitch my personal work for the [Data Science Capstone project from Johns Hopkins University Specialization on Coursera](https://www.coursera.org/learn/data-science-project).  
All codes, including this Rmd, are available on my [Github repository](https://github.com/vanAkim/DataScienceSpecialization-JohnsHopkins/tree/master/Data%20Science%20Capstone).  

These slides show a quick overview of my word prediction algorithm and the methodology used, from any input sentence/words.


Back-off model
========================================================

I chose back-off algorithm for:   

1. the simplicity of obtaining predictions once the database is created,  

2. the processing time and low memory allocation making a suitable deployment on various platforms and services.

For example with the partial sentence *"May the force"*, a word prediction algorithm suggests most probable coming words after *"force"*. 


Back-off model
========================================================

The back-off model takes from a dedicated database: 

1. searches for the same pattern (i.e. all words written) and if it exists among its data, delivers one or more possible outputs (i.e. words) related to that pattern.  

2. If that words sequence isn't stored, the pattern is reduced by eliminating the furthest word from the last, here the resulting sequence is then *"the force"*. Another search step is done. 

3. Without any results from previous steps, the pattern is reduce again, *"force"*, then an ultimate search is processed.


Database
========================================================

<small>To fully understand the back-off model, it's important to know how the database is created.

The back-off model is one of many n-grams language models. n-grams are sequences of n consecutive words. From our previous example:  
* 1-grams: *"May"*, *"the"*, *"force"*  
* 2-grams: *"May the"*, *"the force"*  
* 3-grams: *"May the force"*

Thus, the database is built by storing all sorts of n-grams from a corpus and how many times they've appeared in order to arrange them.  
Of course, to get high accuracy prediction the more n-grams the more inputs words are covered and possibly predicted, but leads to an enormous multi-gigabytes file. So compromises and cleaning steps are required. </small>


Database
========================================================

<small>I've built my database by getting 2, 3 and 4 grams from a corpus made of `899 288` blogposts, `1 010 242` news, and `2 360 148` tweets 

After some cleaning, and only taking into account the top 3 predictions for same patterns, I ended up with:  
* `192 630` 2-grams,  
* `1 377 305` 3-grams,  
* `1 524 442` 4-grams,  
* a total of `3 094 377` n-grams, for a `34.6 MB` rds file.

Now, let's try to see the predicted words for our example.</small>




```r
predict_nextword("May the force")
```

```
[1] "be" "of" "is"
```


Performances and proof of concept
========================================================

The below table shows some benchmark results of my model accuracy.  
A 22.5% accuracy for the common top 3 predictions output configuration is quite satisfying and relatively good.  
Having even better cleaning process, and getting different ngrams from other sources would help to get some ~ 5-10% accuracy increase. 


```
                             Scores
1: Overall top-1 precision: 14.01 %
2: Overall top-3 precision: 22.57 %
```


To conclude, I've hosted the data and algorithm to a [web app (shinyapps)](https://vanakim.shinyapps.io/SwiftKey_Proof-of-concept/) where an input text box is available to type any words an get some predictions.
