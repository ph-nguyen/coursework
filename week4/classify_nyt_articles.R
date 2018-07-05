library(tidyverse)
library(tm)
library(Matrix)
library(glmnet)
library(ROCR)

########################################
# LOAD AND PARSE ARTICLES
########################################

# read in the business and world articles from files
# combine them both into one data frame called articles
business <- read_tsv('nyt_article_business.tsv', quote= "\'")
world <- read_tsv('nyt_article_world.tsv', quote= "\'")
articles <- rbind(business, world)

# create a corpus from the article snippets
# using the Corpus and VectorSource functions
corpus <- Corpus(VectorSource(articles$snippet))

# create a DocumentTermMatrix from the snippet Corpus
# remove stopwords, punctuation, and numbers
dtm <- DocumentTermMatrix(corpus, list(weighting=weightBin,
                                       stopwords=T,
                                       removePunctuation=T,
                                       removeNumbers=T))

# convert the DocumentTermMatrix to a sparseMatrix
X <- sparseMatrix(i=dtm$i, j=dtm$j, x=dtm$v, dims=c(dtm$nrow, dtm$ncol), dimnames=dtm$dimnames)

# set a seed for the random number generator so we all agree
set.seed(42)

########################################
# YOUR SOLUTION BELOW
########################################

# create a train / test split
index <- sample(1:nrow(X),floor(nrow(X)*0.8))

train <- X[index,]
section_name <- articles$section_name[index]

test <- X[-index,]

section_name_test <- as.data.frame(articles$section_name[-index])
names(section_name_test)[1]<-"actual"

# cross-validate logistic regression with cv.glmnet (family="binomial"), measuring auc
logit <- cv.glmnet(x=train, y= section_name,alpha=1, family="binomial", type.measure = "class")
summary(logit)


# plot the cross-validation curve
plot(logit)

# evaluate performance for the best-fit model
# note: it's useful to explicitly cast glmnet's predictions
# use as.numeric for probabilities and as.character for labels for this

section_name_test$prob <- as.numeric(predict(logit, test, type="response"))
section_name_test$label <- as.factor(predict(logit, test, type="class"))


# compute accuracy
mean(section_name_test$actual == section_name_test$label)

# look at the confusion matrix

library(caret)
confusionMatrix(section_name_test$actual, section_name_test$label)

# plot an ROC curve and calculate the AUC
# create a ROCR object
pred <- prediction(section_name_test$prob, section_name_test$actual)
perf_nb <- performance(pred, measure='tpr', x.measure='fpr')
plot(perf_nb)
performance(pred, 'auc')


predicted <- section_name_test$prob
actual <- section_name_test$actual == "business"
ndx_pos <- sample(which(actual == 1), size=1000, replace=T)
ndx_neg <- sample(which(actual == 0), size=1000, replace=T)
mean(predicted[ndx_pos] > predicted[ndx_neg])

# show weights on words with top 10 weights for business
# use the coef() function to get the coefficients
# and tidy() to convert them into a tidy data frame
library(broom)
tidy(coef(logit)) %>% filter(value<0) %>% arrange(value) %>% head(10)

# show weights on words with top 10 weights for world
tidy(coef(logit))%>% filter(value > 0) %>% arrange(value) %>% head(10)
