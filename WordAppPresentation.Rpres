Word Auto Suggestion App Presentation
========================================================
author: Nimish Sanghi
date: December 5, 2016
autosize: true

Approach to Solution
========================================================

- The application is meant to predict the next best word for English Language. 
- The corpus was provided as part of the exercise and can be found at [Capstone Dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)
- The Application uses a language model built using the above corpus. I first tried to use **"tm"** package but due to speed shifted to **"qunateda"** package for building n-grams.
- Language Model is built using uni, bi and trigrams on the given corpus.  
- Complete code (language model and shiny app) is hosted at github [Code](https://github.com/nsanghi/TextPredictionApp).

Algorithm Used for word Prediction
========================================================

- Prediction is based on Katz's back off algorithm. 
- A discount rate of 0.5 is used in the model.
- While predicting next next word, the algorithm uses Katz's backoff to first find the existence of the trigram. In case it is not found, it backs off to bigram model to predict the next word failing which it again backs off to unigram model to predict the word. 
- Calculation of probabilities for next word based on trigram. bigram or unigram is done according to the explanation given in two videos  - [Discounting Methods Part 1](https://www.youtube.com/watch?v=hsHw9F3UuAQ&index=3&list=PLO9y7hOkmmSHE2v_oEUjULGg20gyb-v1u) and [Discounting Methods Part 2](https://www.youtube.com/watch?v=FedWcgXcp8w&index=4&list=PLO9y7hOkmmSHE2v_oEUjULGg20gyb-v1u)
- Originally while building tri/bi and unigrams, phrases with frequency count of 1 were retained in the model. However, this made the model very heavy in terms of dataset size. Accordingly, the final deployment of app removed all these trigrams and bigrams which had a frequency of 1. 

How to use
========================================================

- The word suggestion application in form of a shiny app is hosted here [Next Word Predictor](https://nsanghi.shinyapps.io/WordSuggest/).
- Please go to the link and in the top left side, enter a phrase in the input text area.
- The app will suggest next best 5 words in the order of priority. 
- The app will also display a word cloud of these five recommendations with size of words proportional to the relative probability of suggestion. 
- First time query may take a little longer (45-60 secs). However, it is pretty responsive after first query. 
- In case no word is found, it displays "None" to inform the user that it has no recommendation for next word at this point in time. 

Future Improvements
========================================================

- The trigram and bigram models are built using stop words so that the suggestions can complete the sentence properly with articles and prepositions. However, this overwhelms the model as frequently the suggestion for next work is a stop word. This needs to be improved.
- Currently the model uses trigram as the biggest construct. For better contextuality, the model needs to have skip gram models or higher order ngrams. 
- The model uses a fixed discount probability of 0.5. In next iteration, the discount rate could be tuned using a validation model. 
- The prediction model instead of using Katz's backoff could be built using more sophisticated prediction models. A comparative study of various language and prediction models are given in the paper [An empirical study of smoothing techniques for language modeling] (http://u.cs.biu.ac.il/~yogo/courses/mt2013/papers/chen-goodman-99.pdf). I got the link from Course discussion forums. 
