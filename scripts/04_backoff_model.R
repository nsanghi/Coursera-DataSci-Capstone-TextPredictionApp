# prepare backoff model

# set working directory to root of the project folder
setwd("~/Coursera/DataScience/data-science-project/TextPredictionApp")
library(data.table)
library(tm)

#katzs backoff based on algorithm given by
#https://github.com/ThachNgocTran/KatzBackOffModelImplementationInR

unigram <- data.table(readRDS("./ngrams/1_gram_train.rds"))
bigram <- data.table(readRDS("./ngrams/2_gram_train.rds"))
trigram <- data.table(readRDS("./ngrams/3_gram_train.rds"))




backoff_trigram <- function(trigram, bigram, unigram, u, v, dis_tri = 0.5, dis_bi = 0.5) {
  uv <- paste(u, v, sep = " ")
  trigram_uv <- trigram[phrase == uv]
  count_uv <- trigram_uv[,sum(freq)]
  trigram_uv$prob <- (trigram_uv$freq - dis_tri)/count_uv
  
  alpha_tri = nrow(trigram_uv)*dis_tri / count_uv
  
  #now handle those words which do not appear with uv in trigram
  missing_words_trigram <- setdiff(unigram$ngram, trigram_uv$nextword)

  # of the missing words in trigram find the ones that apepar in bigram
  bigram_v <- bigram[phrase == v][nextword %in% missing_words_trigram]
  count_v <- bigram_v[,sum(freq)]
  bigram_v$prob <- (bigram_v$freq - dis_bi)/count_v
  
  alpha_bi = nrow(bigram_v)*dis_bi / count_v
  
  #also missing in bigram
  missing_words_bigram <- setdiff(missing_words_trigram, bigram_v$nextword)
  n <- length(missing_words_bigram)
  
  unigram_w <- unigram[ngram %in% missing_words_bigram]
  unigram_w$nextword <- unigram_w$ngram
  count_w <- unigram_w[,sum(freq)]
  unigram_w$prob <- alpha_bi * unigram_w$freq / count_w
  
  #merge uni and bi to get qbo(wi/wi-1)
  l <- list(bigram_v, unigram_w)
  biuni<- rbindlist(l, use.names=TRUE, fill=TRUE)

  #merge this with tri to get qbo(wi/wi-1,wi-2)
  biuni$prob <- alpha_tri* biuni$prob
  l=list(trigram_uv, biuni)
  tribiuni<- rbindlist(l, use.names=TRUE, fill=TRUE)  
  tribiuni <- tribiuni[order(prob, decreasing = TRUE)]
  return (tribiuni$nextword[1:5])
  
  
}
  
get_query_words <- function(s) {
  docs <- Corpus(VectorSource(s))
  removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
  docs <- tm_map(docs, content_transformer(removeURL))
  
  docs <- tm_map(docs, removePunctuation)
  docs <- tm_map(docs, removeNumbers)
  docs <- tm_map(docs, tolower)
  docs <- tm_map(docs, stripWhitespace)
  query <- docs[[1]]
  query <- as.character(query)
  query <- trimws(query)
  query <- unlist(strsplit(query, split = " "))
  return (tail(query, n=2))
} 

