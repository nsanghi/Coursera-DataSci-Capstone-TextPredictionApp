# Create sample files for traning, devtest and test

#read ramdom samples from blogs text file
setwd("~/Coursera/DataScience/data-science-project/TextPredictionApp")
con <- file("./final/en_US/en_US.blogs.txt","r")
blogs <- readLines(con, skipNul = TRUE)
length(blogs)
set.seed(1310)
blogs_train <- blogs[sample(length(blogs),0.10*length(blogs))]
blogs_devtest <- blogs[sample(length(blogs),0.01*length(blogs))]
blogs_test <- blogs[sample(length(blogs),0.01*length(blogs))]
close(con)

#read random samples from news text file
con <- file("./final/en_US/en_US.news.txt","r")
news <- readLines(con, skipNul = TRUE)
length(news)
set.seed(1310)
news_train <- news[sample(length(news),0.10*length(news))]
news_devtest <- news[sample(length(news),0.01*length(news))]
news_test <- news[sample(length(news),0.01*length(news))]
close(con)

#read random samples from twitter text file
con <- file("./final/en_US/en_US.twitter.txt","r")
tweets <- readLines(con, skipNul = TRUE)
length(tweets)
set.seed(1310)
tweets_train <- tweets[sample(length(tweets),0.10*length(tweets))]
tweets_devtest <- tweets[sample(length(tweets),0.01*length(tweets))]
tweets_test <- tweets[sample(length(tweets),0.01*length(tweets))]
close(con)


#combine the samples into a single file and write it back on disk
docs <- c(blogs_train, news_train, tweets_train)
docs_devtest <- c(blogs_devtest, news_devtest, tweets_devtest)
docs_test <- c(blogs_test, news_test, tweets_test)

# save combined files into a folder
saveRDS(docs , sprintf("./sampleData/train.rds"))
saveRDS(docs_devtest , sprintf("./sampleData/devtest.rds"))
saveRDS(docs_test , sprintf("./sampleData/test.rds"))


#clean workspace
rm(tweets, tweets_test, tweets_devtest, tweets_train)
rm(docs, docs_devtest, docs_test)
rm(blogs, blogs_test, blogs_devtest, blogs_train)
rm(news, news_test, news_devtest, news_train)


