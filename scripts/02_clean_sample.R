# Cleaning all the sample files

library(tm)
library(SnowballC)

# set working directory to root of the project folder
setwd("~/Coursera/DataScience/data-science-project/TextPredictionApp")

for (corpus in c("test", "devtest", "train")) {

  docs <- readRDS(sprintf("./sampleData/%s.rds", corpus))
  #docs <- docs[1:2]
  docs <- Corpus(VectorSource(docs))

  print("file loaded")
    # pre processing
  #docs <- tm_map(docs, removePunctuation)
  #removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
  #docs <- tm_map(docs, content_transformer(removeURL))

  docs <- tm_map(docs, removeNumbers)
  docs <- tm_map(docs, content_transformer(tolower))
  # commented stopword removal
  docs <- tm_map(docs, removeWords, stopwords("english"))
  
  print("remvoing profanity")
  # remove profanity words as found in the url
  # https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en
  profanityWords <- readLines("https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en")
  docs <- tm_map(docs, removeWords, profanityWords)

  print("stemming and whitespace stripping")
  #rest of pre processsing - stripping white spaces
  # stemming
  docs <- tm_map(docs, stemDocument, language = "english")
  docs <- tm_map(docs, stripWhitespace)
  
  print("saving RDS after cleaning")
  #save cleaned samples
  saveRDS(docs , sprintf("./sampleData/%s_clean.rds", corpus))
}
