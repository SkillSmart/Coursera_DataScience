#Preprocessing the predictor variables

# Preprocessint becomes especially necessary and impactfull when using model based approaches, instead of non-parametric, linear Models
# like regression.

#Setting up the test dataset for this exercise
library(caret); library(kernlab); data(spam)
inTrain <-createDataPartition(y=spam$type, p=0.75, list=FALSE)
trn_mail <- data[inTrain, ]
test_mail <- data[-inTrain, ]

# Lets first look at the density parameters for the dataset (variable = Runlength of capital letters in a row in an email)
hist(trn_mail$capitalAve, main="", xlab="ave.capital run length")
# This variable is very skewed and therefore the model approaches will be strongly biased towards the outlying values
mean(trn_mail$capitalAve)
sd(trn_mail$CapitalAve)

# We can standardize the values by subtracting their mean and dividing them by their sd
trainCapAve <- trn_mail$capitalAve
tainCapAveS <- trainCapAve - mean(trainCapAve)/ sd(trainCapAve)
mean(trainCapAveS)
sd(trainCapAve)

# This is essentially the same procedure used in statistics to standardize PDFs in order to translate them into each other, 
# called z-transformation

# To avoid leakage of information from the test to the training set, we have to be strongly aware of the fact to never refer to the 
# density parameters of the testset when training our models. This will mean, that we will not get exactly mean=0 and sd=1 in the testset\
# when applying the final model. To ilustrate the difference:

testCapAve <- test_mail$capitalAve
testCapAve <- (testCapAve - mean(trainCapAve)/ sd(trainCapAve))
mean(testCapAve)
sd(testCapAve)

# To facilitate this process we can use the 'preProcess()' function from the 'caret' package.
# The two arguments passed ('center', 'scale') describe the preprocessing pipeline. We first center the data (subtract mean) and then 
# scale (divide by sd) to get the same result as above
preObj <- preProcess(trn_mail[,-58], method=c("center", "scale"))
trainCapAveS <- predict(preObj, trn_mail[,-58])$capitalAve
mean(trainCapAveS)


# The resulting object that got returned by the preProcess() can be used to transform the testset via the "predict" attribute. 
testCapAveS <- predict(preObj, test_mail[,-58])$capitalAve
mean(testCapAveS)
sd(testCapAveS)

# We can also directly pass the preProcessing function as an argument to the train function in caret
set.seed(23456)
modelFit <- train(type ~., data=trn_mail,
                  preProcess=c("center","scale"), method="glm")
modelFit

# Other kind of transformations to be used
## Box-Cox transforms
preObj <- preProcess(trn_mail[,-58], method=c('BoxCox'))
tainCapAveS <- predict(preObj, trn_mail[,-58])$capitalAve
par(mfrow=c(1,2)); hist(trainCapAveS); qqnorm(trainCapAveS)
# A set of continous transformation and make them look like normal data, by using the method of maximum-likelihood.
# Using the qqplot we can compare the theoretical quantiles of a normal distribution with the datapoints. Here we can clearly see
# that the datapoint do not follow the theoretical 45% slope in the upper and lower parts of the distribution. 
# As the Box-Cox is a continous transform, it can not take care of repeated values (as here we have a large amount of values = 0)


## Imputing Missing Data as part of the Standardization.
# One problem can result from missing data, which we have to impute before training the models. Model based approaches in ML are often
# built not to handle missing Data, as the information included in the dataset is to be followed closely.

# We can impute the data using k-nearest neighbors imputation. 
set.seed(35467)

#Create some missing values in the dataset
trn_mail$capAve <- trn_mail$capitalAve
selectNa <- rbinom(dim(trn_mail)[1],size=1,prob=0.05)==1
trn_mail$capAve[selectNa] <- NA

#Impute and standardize
preObj <- preProcess(training[,-58], method='knnImpute')
capAve <- predict(preObj, training[,-58])$capAve

#Standardize the true values
capAveTruth <- trn_mail$capitalAve
capAveTruth <- (capAveTruth - mean(capAveTruth)/sd(capAveTruth))

# Using the 10 nearest neighbors in the dataset, we get a very nice approximation of the imputed dataset when compared against 
# the real value as ground-truth.
quantile(capAve - capAveTruth)

# Looking closer at only the imputed values, the same result prevails. 
quanitle((capAve - capAveTruth)[selectNa])

# Especially when compared to the inherent difference in the dataset itself, looking at the not-imputed values, we see that the 
# imputation results in a trustworthy approximation of the trend in the data. Therefore we can trust to impute missing data in the range
# of 5 -10% of the data, without a large impact on model performance, given data is missing at random, and is not the result of an underlying
# factor that we missed to controll for.
quantile(capAve - capAveTruth)[!selectNa]


