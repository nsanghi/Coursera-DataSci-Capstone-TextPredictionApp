# load tm library
library(tm)
library(SnowballC)
library(ggplot2)
library(rJava) 
.jinit(parameters="-Xmx128g")
library(RWeka)
#read ramdom samples from blogs text file
setwd("~/Coursera/DataScience/data-science-project/finalProject")
con <- file("./final/en_US/en_US.blogs.txt","r")
blogs <- readLines(con, skipNul = TRUE)
length(blogs)
set.seed(1310)
blogs <- blogs[sample(length(blogs),0.01*length(blogs))]
close(con)

#read random samples from news text file
con <- file("./final/en_US/en_US.news.txt","r")
news <- readLines(con, skipNul = TRUE)
length(news)
set.seed(1310)
news <- news[sample(length(news),0.01*length(news))]
close(con)

#read random samples from twitter text file
con <- file("./final/en_US/en_US.twitter.txt","r")
tweets <- readLines(con, skipNul = TRUE)
length(tweets)
set.seed(1310)
tweets <- tweets[sample(length(tweets),0.01*length(tweets))]
close(con)


#combine the samples into a single file and write it back on disk
docs <- c(blogs, news, tweets)
con <- file("samples.txt")
writeLines(docs, con)
close(con)

#clean workspace
rm(tweets, docs, blogs, news)

# do the above stuff only once to get a sample of data
# subsequent run needs to use this sample file for all future stuff

#read sample docs for text processing
setwd("~/Coursera/DataScience/data-science-project/finalProject")
con <- file("samples.txt","r")
docs <- VCorpus(VectorSource(readLines(con, skipNul = TRUE)))
close(con)


# pre processing
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, tolower)
docs <- tm_map(docs, removeWords, stopwords("english"))

# remove profanity words as found in the url
# https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en
profanityWords <- readLines("https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en")
docs <- tm_map(docs, removeWords, profanityWords)

#rest of pre processsing
docs <- tm_map(docs, stripWhitespace)
# stemming
docs <- tm_map(docs, stemDocument, language = "english")

# reformat documents to PlainTextDocument
docs <- tm_map(docs, PlainTextDocument)

# make Document Term Matrix
dtm <- DocumentTermMatrix(docs)

#organise terms by frequency
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)  
wf <- data.frame(word=names(freq), freq=freq)

# make word column as ordered to avoid ggplot sorting x axis
wf$word <- factor(wf$word, levels = wf$word)

#plot term frquency
ggplot(wf[1:20,], aes(x=word,y=freq)) + 
  geom_bar(stat="Identity", fill="#E69F00") +
  geom_text(aes(label=freq, angle=90), hjust=1.50) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Prepare and plot bi-grams
bigram <- NGramTokenizer(docs, Weka_control(min = 2, max = 2,delimiters = " \\r\\n\\t.,;:\"()?!"))
bigram <- data.frame(table(bigram))
bigram <- bigram[order(bigram$Freq,decreasing = TRUE),]
colnames(bigram) <- c("word","freq")
bigram$word <- factor(bigram$word, levels = bigram$word)

ggplot(bigram[1:20,], aes(x=word,y=freq)) + 
  geom_bar(stat="Identity", fill="#E69F00") +
  geom_text(aes(label=freq, angle=90), hjust=1.50) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Prepare and plot tri-grams
trigram <- NGramTokenizer(docs, Weka_control(min = 3, max = 3,delimiters = " \\r\\n\\t.,;:\"()?!"))
trigram <- data.frame(table(trigram))
trigram <- trigram[order(trigram$Freq,decreasing = TRUE),]
colnames(trigram) <- c("word","freq")
trigram$word <- factor(trigram$word, levels = trigram$word)

ggplot(trigram[1:20,], aes(x=word,y=freq)) + 
  geom_bar(stat="Identity", fill="#E69F00") +
  geom_text(aes(label=freq, angle=90), hjust=1.50) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))