library(caret); library(randomForest); library(rpart); library(RColorBrewer); library(rattle)
trUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
teUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
training <- read.csv(url(trUrl), na.strings=c("NA","#DIV/0!",""))
testing <- read.csv(url(teUrl), na.strings=c("NA","#DIV/0!",""))
training <- training[,colSums(is.na(training)) == 0]
testing <- testing[,colSums(is.na(testing)) == 0]
training <- training[,-c(1:7)]
testing <- testing[,-c(1:7)]

set.seed(1234)
inTrain <- createDataPartition(y=training$classe, p=0.75, list=FALSE)
mytraining <- training[inTrain, ]
mytesting <- training[-inTrain, ]

plot(mytraining$classe, col="lightgreen", main = "Plot of levels of variable classe within the TrainTrainingSet data set", xlab="classe", ylab="Frequency" )

model <- rpart(classe ~ ., data=mytraining, method="class")
prediction1 <- predict(model, mytesting, type = "class")

fancyRpartPlot(model)

confusionMatrix(prediction1, mytesting$classe)

model2 <- randomForest(classe ~. , data=mytraining, method="class")
prediction2 <- predict(model2, mytesting, type = "class")
confusionMatrix(prediction2, mytesting$classe)


finalpredict <- predict(model2, testing, type="class")
finalpredict

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
pml_write_files(finalpredict)