# build uni, bi and tri grams

library(data.table)
library(quanteda)
library(tm)

# set working directory to root of the project folder
setwd("~/Coursera/DataScience/data-science-project/TextPredictionApp")
rm(list=ls())
gc()

for (data_type in c("test", "devtest", "train")) {

  docs <- readRDS(sprintf("./sampleData/%s.rds", data_type))
  docs <- corpus(docs)
  
  for (count in c (1:3)) {

    tokensAll <- dfm(docs, toLower = T, removeNumbers=T, removePunct = T, 
                     removeSeparators = T, removeTwitter = T, removeHyphens = T, 
                     removeURL = T, ngrams=count, concatenator = " ")
    
    ngram <- data.frame(colSums(tokensAll))
    names <- rownames(ngram)
    rownames(ngram) <- NULL
    ngram <- cbind(names, ngram)
    colnames(ngram) <- c("ngram","freq")
    ngram <- ngram[order(ngram$freq,decreasing = TRUE),]
    rownames(ngram) <- NULL
    
    if (count != 1) {
      ngram$ngram <- as.character(ngram$ngram)
      ngram_split <- data.table(do.call(rbind, strsplit(ngram$ngram, ' (?=[^ ]+$)', perl=TRUE)))
      colnames(ngram_split) <- c("phrase", "nextword") 
      ngram <- cbind(ngram_split, ngram)
    }
    
    print ("saving tokenizer dataframe")

    saveRDS(ngram, sprintf("./ngrams/%d_gram_%s.rds", count, data_type))
  }
}
rm(list=ls())
gc()
