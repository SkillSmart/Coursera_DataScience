library(caret); library(kernlab); data(spam)

# Splitting the data in test and training set 
inTrain <- createDataPartition(y=spam$type, p=0.75, list=FALSE)

# Assigning the datapartitions trough subsampling on the whole dataset
training <- spam[inTrain,]
test <- spam[-inTrain,]

# Training a linear model on the training set
#### Listing all available training options and describing the difference between them

##### 1.Training a General linear model (linear regression)
fit_glm <- train(type ~., training, method="glm")
fig_glm$finalModel




#These are the arguments that can be set using the train function
args(train.default)

# preprocess to set preprocessing optinons
# weights to up or downweight certain factor
# metric to set the standart measurement method ('Accuracy', 'RMSE', 'RSquared', 'Kappa')
# trControl where you have to pass a function trainControl() to set the parameters

# Using the train.control() allows for way more in depth controll of the model parameter settings
args(trainControl)
#method sets the method for resampling the data 
# * 'boot' for bootstrapping
# * 'boot632' bootstrapping with adjustment
# * 'cv' for cross validation
# * 'repeatedcv' repeated cross-validation (set number of times as second arg)
# * 'reasample" for resampling
# * 'LOOCV' for leave one out cross valdiation

# number tells how often to do sampling
# * For boot/cross validation
# * otherwise, number of subsamples to take from the data

# repeats sets the amount of repeat the whole process, for example in repeated cross validation
# p sets the size of the trainingset

#Special Setting for working with TimeData:
# initalWindow sets the inital size of the timeslices to be used in analyzing time relevant datasets
# horizon sets the number of timepoints to be predicted

# savePredictions(Bool) tells the system to actually return the different predictions while iterating over the training data
# summaryFunction sets the summary function to be displayed (ToDo!!!: Research the possibilities and list them here)
# seed lets you set the seed numbers for all the different resampling folds. Usefull when allowing parallel fitting of the models on multiple cores
# allowParallel assigns the prediction calculation to be split across multiple cores on the system

# Setting the Seed:
# to set an overall seed use a general seed like this
set.seed(12345)

# When using parallel computation set the seed in the seed arguments within the trainControl Function


## TODO !!!  />> Insert training exercises for all different Model types. 


### Regression Models

## General Linear Model - univariate Regression 

## General Linear Model - multivariate Regression


## General Linear Model - "punished" GLM for high-dimensional multivariate Regression & Classification


## General Linear Model - Regression Models for binary Classification - Logistic binary Regression

## General Linear Model - Multivariate logistic Regression for multiple classification


# Modelbased Approaches

## Kernel Based Methods - Support Vector Machines - Linear Kernel (= Linear Regression)

## Kernel Based Methods - Support Vector Machines - logistic Kernel (= SVM for Classifcation)

## Kernel Based Methods - Support vector Machines - Gaussian Density Kernel 
# Used for high dimensional, non-linear radial approximation with normalized likelihoods

## Kernel Based Methods - Support Vector Machine - TODO! Add all other available kernel functions for SVMs here....
#.....

# Neural Networks

## Training a perceptron

## Traing a 1D hidden layer model 

## Training multiple hidden layer models

## Training a deep neural network - Recurrent Neural Network



#etc....





# Plotting predictors
# One of the most import steps in building a prediction model is understanding the inherent structure and interaction whith the dataset
# This can be best accomplished by first getting a cisual overview of the inherent trends by plotting the predictors.
# It is important to also keep in mind to only use the training data for plotting, as whith the computer models themselves, also our conclusions
# about the data are predisposed by the information we derive from the dataset. This would lead us to develop our models too closely tuned towards
# the inherent trends in our particular sample, which is the common cause of overfitting and a higher out of sample error.

# We will have a look at the "Wages" Dataset from the ISLR-Package from the book Introduction to statistical Learning
if !exists(library(ISLR)) install.packages("ISLR")
data(Wage)

# First lets have a look at the Data
summary(Wage)

# only men, only from the middle Atlantic Region

# preparin the data for modeltraining
inTrain_Wage <- createDataPartition(y=Wage, p=0.75, list=False)
trn_Wage <- Wage[inTrain_Wage, ]
test_Wage <- Wage[-inTrain_Wage, ]

# First plot all available independent predictors against the dependent variable "wage"to identify individual trends in the data
featurePlot(x=trn_Wage[,c('age', 'education', 'jobclass')], y= trn_Wage$wage, plot="pairs")

# This shows all features against each other on the diagonal entry
# We are looking at trends in the rows, where a given variable is plotted agains every other variable in the dataset. Here we 
# want to identify promising trends to be further explored.

# Then we can take a closer look by plotting an individual variable against another i.e using the qPlot function (ggplot2)
qplot(education, wage, data=trn_Wage)

qplot(age, wage, data=trn_Wage)
# Here we see a probale quadrativ trend between wage as a function of age. 
# But we can also identify a subset of the wage variable in the region around 300k$ where this trends does not seem to apply.
# In order to identify subtrends underlying this mixed dependency between these two variables we can dive deeper. 
# To add a third dimension to the plot, we can use color coding of factors of the predictor "jobclass". 
qplot(age, wage, colour=jobclass, data=trn_Wage)

# Now we can see that most individuals on the top come from the information based jobs. 

# In order to clearly show these subtrends of a moderating third variable we can first color code them, and exemplifiy their influence
# by adding linear regressions to each factorlevel individually. 
# Here again we consider the development of wages as a function of age, mediated by the highest level of education. 
qq <- ggplot(age, wage, colour=education, data=trainng)
qq + geom_smooth(method="lm", formula=y~x)

# When handling continous predictors in the same fashion, we can cut them into artifical factor levels to better approximate subsets
# of functions. 
# For example, we can subset the wage factor into 3 factorlevels ("low", "medium", "high") income.(Using the Hmisc package)
library(Hmisc)
cutWage <- cut2(trn_Wage$wage, g=3)
table(cutWage)
qplot(age, wage, colour=cutWage,data=trn_Wage) + geom_smooth(method="lm", formulay= y ~ cutWage)

# Or we can plot the individual influence of Age on the Wage variable as a Boxplot
p1 <- qplot(cutWage,age, data=trn_Wage,fill=cutWage,
      geom=c("boxplot"))

# Also we might want to add the points themselves on top of the boxplots to see the distribution even better
p2 <- qplot(cutWage,age,data=trn_Wage, fill=cutWage,
      geom=c("boxplot","jitter"))
# And arrange the plots side by side
grid.arrange(p1,p2,ncol=2)

# Factorized continous data is especially usefull to create very indepth tables. Here i.e to extract information about the 
# mediating influence of the factor Jobclass on the wage in all 3 different wage classes.
t1 <- table(cutWage, trn_Wage$jobclass)
t1

# This can easily be turned from a count table above, into a proportial table, set to show proportions by 1=row, 2=column
pt1 <- prop.table(t1,1)


# To identify where the bulk of the data is, we can have a look at a density function for the dataset
qplot(wage, colour=eduction, data=trn_Wage, geom="density")




