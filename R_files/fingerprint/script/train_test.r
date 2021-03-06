setwd("/Users/edoardesd/Documents/master_thesis/R_files")
getwd()


library(readr)
library(kimisc)

sam_bt_ok <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sam_bt_ok.csv")
sam_wifi_ok <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sam_wifi_ok.csv", 
                        col_types = cols(location = col_character()))

s3_bluetooth_ok <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_bluetooth_ok.csv")
s3_wifi_dup <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_wifi_dup.csv")
lg_wifi_v1 <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/lg_wifi_v1.csv")
lg_wifi_v2 <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/lg_wifi_v2.csv")
lg_bt_avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/lg_bt_avg.csv")


#import rasp separate
sam_rasp1_wifi.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sams_wifi_avg/sams_wifi_avg_rasp1.csv")
sam_rasp2_wifi.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sams_wifi_avg/sams_wifi_avg_rasp2.csv")
sam_rasp3_wifi.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sams_wifi_avg/sams_wifi_avg_rasp3.csv")
sam_rasp4_wifi.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sams_wifi_avg/sams_wifi_avg_rasp4.csv")

sam_rasp1_bt.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sams_bt_avg/sams_bt_avg_rasp1.csv")
sam_rasp2_bt.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sams_bt_avg/sams_bt_avg_rasp2.csv")
sam_rasp3_bt.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sams_bt_avg/sams_bt_avg_rasp3.csv")
sam_rasp4_bt.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/sams_bt_avg/sams_bt_avg_rasp4.csv")

s3_rasp1_bt.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_bt_avg/s3_bt_avg_rasp1.csv")
s3_rasp2_bt.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_bt_avg/s3_bt_avg_rasp2.csv")
s3_rasp3_bt.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_bt_avg/s3_bt_avg_rasp3.csv")
s3_rasp4_bt.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_bt_avg/s3_bt_avg_rasp4.csv")


s3_rasp1_wifi.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_wifi_avg/s3_wifi_rasp1.csv")
s3_rasp2_wifi.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_wifi_avg/s3_wifi_rasp2.csv")
s3_rasp3_wifi.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_wifi_avg/s3_wifi_rasp3.csv")
s3_rasp4_wifi.avg <- read_csv("~/Documents/master_thesis/R_files/fingerprint/data/s3_wifi_avg/s3_wifi_rasp4.csv")


#remove errors in location
sam_bt_ok$location[sam_bt_ok$location == "”2.2”"] = 2.2
#check for duplicates
sam_bt_ok[duplicated(sam_bt_ok), ]

set.seed(1234)

#unsort wifi dataframe
gp1 <- runif(nrow(sam_bt_ok))
df.sam_bt <- sam_bt_ok[order(gp1),] 

#unsort bt dataframe
gp2 <- runif(nrow(sam_wifi_ok))
df.sam_wifi <- sam_wifi_ok[order(gp2),]

#split wifi df in test and training
sample.ind.wifi.sam <- sample(2, nrow(df.sam_wifi), replace = T, prob = c(0.7,0.3))

train.wifi.sam <- df.sam_wifi[sample.ind.wifi.sam==1,]
test.wifi.sam <- df.sam_wifi[sample.ind.wifi.sam==2,]

#split bt df in test and training
sample.ind.bt.sam <- sample(2, nrow(df.sam_bt), replace = T, prob = c(0.7,0.3))

train.bt.sam <- df.sam_bt[sample.ind.bt.sam==1,]
test.bt.sam <- df.sam_bt[sample.ind.bt.sam==2,]

#fix some formatting problem
#test.bt.sam$location[421] = 3.2
#train.bt.sam$location[619] = 3.2
#train.bt.sam$location[1016] = 3.2


##### FUNCTIONS ####
#normalize function
normalize <- function(x){ ((x-min(x))/ (max(x) - min(x)))}
#sampling function (per scegliere n random row)
sample.df <- function(df, n) df[sample(nrow(df), n), , drop = FALSE]


#normalized dataframe
df.sam_wifi.norm <- as.data.frame(lapply(df.sam_wifi[,-5], normalize))
df.sam_bt.norm <- as.data.frame(lapply(df.sam_bt[, -5], normalize))

#add the labels to the normalized dataset
df.sam_wifi.norm["location"] <- df.sam_wifi$location
df.sam_bt.norm["location"] <- df.sam_bt$location



#conteggi
table(df.sam_bt$location)
#View(ten_row_bt)

##### BT MOD ####
#create a dataset with 10 row for each location
ten_row_bt = sample.df(subset(df.sam_bt, location == "1.1"), 10)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "1.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "1.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "1.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "1.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "2.1"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "2.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "2.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "2.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "2.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "3.1"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "3.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "3.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "3.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "3.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "4.1"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "4.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "4.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "4.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "4.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "5.1"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "5.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "5.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "5.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "5.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "6.1"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "6.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "6.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "6.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "6.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "7.1"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "7.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "7.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "7.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "7.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "8.1"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "8.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "8.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "8.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "8.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "9.1"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "9.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "9.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "9.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "9.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "10.1"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "10.2"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "10.3"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "10.4"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
ten_row_bt2 = sample.df(subset(df.sam_bt, location == "10.5"), 10)
ten_row_bt = rbind(ten_row_bt, ten_row_bt2)
#View(ten_row_bt)
table(ten_row_bt$location)

set.seed(1234)
#shuffle it
gp3 <- runif(nrow(ten_row_bt))
df.sam_bt.ten_row <- ten_row_bt[order(gp3),]

sample.ind.bt.sam.ten <- sample(2, nrow(df.sam_bt.ten_row), replace = T, prob = c(0.7,0.3))

train.bt_sam.ten <- df.sam_bt.ten_row[sample.ind.bt.sam.ten==1,]
test.bt_sam.ten <- df.sam_bt.ten_row[sample.ind.bt.sam.ten==2,]


##### WIFI MOD #####
#create a dataset with 10 row for each location
ten_row_wifi = sample.df(subset(df.sam_wifi, location == "1.1"), 10)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "1.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "1.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "1.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "1.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "2.1"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "2.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "2.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "2.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "2.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "3.1"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "3.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "3.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "3.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "3.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "4.1"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "4.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "4.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "4.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "4.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "5.1"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "5.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "5.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "5.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "5.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "6.1"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "6.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "6.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "6.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "6.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "7.1"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "7.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "7.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "7.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "7.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "8.1"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "8.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "8.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "8.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "8.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "9.1"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "9.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "9.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "9.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "9.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "10.1"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "10.2"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "10.3"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "10.4"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
ten_row_wifi2 = sample.df(subset(df.sam_wifi, location == "10.5"), 10)
ten_row_wifi = rbind(ten_row_wifi, ten_row_wifi2)
#View(ten_row_wifi)
table(ten_row_wifi$location)


set.seed(1234)
#shuffle it
gp4 <- runif(nrow(ten_row_wifi))
df.sam_wifi.ten_row <- ten_row_wifi[order(gp4),]

sample.ind.wifi.sam.ten <- sample(2, nrow(df.sam_wifi.ten_row), replace = T, prob = c(0.7,0.3))

train.wifi_sam.ten <- df.sam_wifi.ten_row[sample.ind.wifi.sam.ten==1,]
test.wifi_sam.ten <- df.sam_wifi.ten_row[sample.ind.wifi.sam.ten==2,]

#normalized 500 rows' dataframe, train and test 
df.sam_wifi.norm.train <- as.data.frame(lapply(train.wifi_sam.ten[,-5], normalize))
df.sam_wifi.norm.test <- as.data.frame(lapply(test.wifi_sam.ten[, -5], normalize))

df.sam_bt.norm.train <- as.data.frame(lapply(train.bt_sam.ten[,-5], normalize))
df.sam_bt.norm.test <- as.data.frame(lapply(test.bt_sam.ten[, -5], normalize))

#norm of abs df
df.sam_wifi.norm.ten <- as.data.frame(lapply(abs(ten_row_wifi[,-5]), normalize))
df.sam_bt.norm.ten <- as.data.frame(lapply(abs(ten_row_bt[,-5]), normalize))

ten_row_wifi[,5]
#merge df: wifi + bt
bt.norm.with.labels = cbind(df.sam_bt.norm.ten, ten_row_bt[,5])
wifi.norm.with.labels = cbind(df.sam_wifi.norm.ten, ten_row_wifi[,5])

df.merge.sam = rbind(bt.norm.with.labels, wifi.norm.with.labels)


#unsort bt dataframe
gp5 <- runif(nrow(df.merge.sam))
df.sam_wifi_bt <- df.merge.sam[order(gp5),]

#split wifi df in test and training
sample.bt.wifi.sam <- sample(2, nrow(df.sam_wifi_bt), replace = T, prob = c(0.7,0.3))

train.bt_wifi.sam <- df.sam_wifi_bt[sample.bt.wifi.sam==1,]
test.bt_wifi.sam <- df.sam_wifi_bt[sample.bt.wifi.sam==2,]

##### COMPRESS DATA #### one row for each location
sam_bt.mean = aggregate(.~location, data=sam_bt_ok, mean)
sam_bt.mean <- sam_bt.mean[,c(2,3,4,5,1)]

sam_wifi.mean = aggregate(.~location, data=sam_wifi_ok, mean)
sam_wifi.mean <- sam_wifi.mean[,c(2,3,4,5,1)]

lg_wifi_v1.mean = aggregate(.~location, data=lg_wifi_v1, mean)
lg_wifi_v2.mean = aggregate(.~location, data=lg_wifi_v2, mean)



s3_bt.mean = aggregate(.~location, data=s3_bluetooth_ok, mean)
s3_bt.mean <- s3_bt.mean[,c(2,3,4,5,1)]
s3_wifi_dup.avg = aggregate(.~location, data=s3_wifi_dup, mean)
s3_wifi_dup.avg <- s3_wifi_dup.avg[,c(2,3,4,5,1)]

#merge rasp avg
s3_bt.avg.all = cbind(s3_rasp1_bt.avg[1], s3_rasp2_bt.avg[1], s3_rasp3_bt.avg[1], s3_rasp4_bt.avg)
s3_wifi.avg.all = cbind(s3_rasp1_wifi.avg[1], s3_rasp2_wifi.avg[1], s3_rasp3_wifi.avg[1], s3_rasp4_wifi.avg)

sams_wifi.avg.all = cbind(sam_rasp1_wifi.avg[1], sam_rasp2_wifi.avg[1], sam_rasp3_wifi.avg[1], sam_rasp4_wifi.avg)
sams_bt.avg.all = cbind(sam_rasp1_bt.avg[1], sam_rasp2_bt.avg[1], sam_rasp3_bt.avg[1], sam_rasp4_bt.avg)
#export file
write.csv(sam_bt.mean, file = "fingerprint_sam_bt_mean.csv",row.names=FALSE)
write.csv(sam_wifi.mean, file = "fingerprint_sam_wifi_mean.csv",row.names=FALSE)
write.csv(sam_bt.mean, file = "fingerprint_sam_bt_mean.txt",row.names=FALSE)
write.csv(sam_wifi.mean, file = "fingerprint_sam_wifi_mean.txt",row.names=FALSE)

write.csv(sams_wifi.avg.all, file = "sams_avg_all_wifi.txt",row.names=FALSE)
write.csv(sams_bt.avg.all, file = "sams_avg_all_bt.txt",row.names=FALSE)

write.csv(s3_bt.avg.all, file = "s3_bt_avg.txt",row.names=FALSE)
write.csv(s3_wifi.avg.all, file = "s3_wifi_avg.txt",row.names=FALSE)
write.csv(s3_bt.mean, file = "s3_bt_ist.txt",row.names=FALSE)


sam_wifi.mean[-5] - sams_wifi.avg.all[-5]
sam_bt.mean[-5] - sams_bt.avg.all[-5]

s3_bt.avg.all[-5] - s3_bt.mean[-5]

lg_wifi_v1.mean[-1] - lg_wifi_v2.mean[-1]

lg_wifi_v1.mean <- lg_wifi_v1.mean[,c(2,3,4,5,1)]

write.csv(lg_wifi_v1.mean, file = "lg_wifi_avg.txt",row.names=FALSE)

s3_wifi_avg <- s3_wifi.avg.all
lg_wifi_avg <- lg_wifi_v1.mean
sams_wifi_avg <- sams_wifi.avg.all
sams_bt_avg <- sams_bt.avg.all
s3_bt_avg <- s3_bt.avg.all

wifi_avg <- (s3_wifi_avg[-5] + lg_wifi_avg[-5] + sams_wifi_avg[-5])/3
bt_avg <- (s3_bt_avg[-5] + lg_bt_avg[-5]+  sams_bt_avg[-5])/3
bt_avg <- cbind(bt_avg, s3_bt_avg[5])
wifi_avg <- cbind(wifi_avg, s3_wifi_avg[5])


write.csv(wifi_avg, file = "fingerprint_wifi_avg.txt",row.names=FALSE)
write.csv(bt_avg, file = "fingerprint_bt_avg.txt",row.names=FALSE)


