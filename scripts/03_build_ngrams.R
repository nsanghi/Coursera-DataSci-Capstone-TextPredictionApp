# build uni, bi and tri grams
library(tm)
library(SnowballC)
library(rJava) 
.jinit(parameters="-Xmx8g")
library(RWeka)
library(data.table)

# set working directory to root of the project folder
setwd("~/Coursera/DataScience/data-science-project/TextPredictionApp")
rm(list=ls())
gc()

#for (corpus in c("test", "devtest", "train")) {
for (corpus in c("train")) {
    
  docs <- readRDS(sprintf("./sampleData/%s_clean.rds", corpus))
  print (sprintf("read clean file for %s", corpus))

    for (count in c (1:3)) {
  
    print (sprintf("Starting tokennizer-%d", count))
    ngram <- NGramTokenizer(docs, Weka_control(min = count, max = count, delimiters = " \\r\\n\\t.,;:\"()?!"))
    print ("Tokennizer done. converting to dataframe")
    ngram <- data.frame(table(ngram))
    print ("reordering dataframe by decreasing frequency")
    ngram <- ngram[order(ngram$Freq,decreasing = TRUE),]
    colnames(ngram) <- c("ngram","freq")
    if (count != 1) {
      ngram$ngram <- as.character(ngram$ngram)
      ngram_split <- data.table(do.call(rbind, strsplit(ngram$ngram, ' (?=[^ ]+$)', perl=TRUE)))
      colnames(ngram_split) <- c("phrase", "nextword") 
      ngram <- cbind(ngram_split, ngram)
    }
    print ("saving tokenizer dataframe")
    saveRDS(ngram, sprintf("./ngrams/%d_gram_%s.rds", count, corpus))
    rm(ngram)
    gc()

    }
  rm (docs)
  gc()
}
rm(list=ls())
gc()
