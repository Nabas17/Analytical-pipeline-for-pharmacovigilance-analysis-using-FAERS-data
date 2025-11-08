library(readxl)
library(stringr)
library(dplyr)
library(tableone)

#read the file containing information regrading different drug class, liver disease reaction
descriptive_stats <- read_excel("descriptive_stats.xlsx",sheet="drugs")

drug_nsaid <- na.omit(tolower(descriptive_stats$`NSAID for comparison`))
drug_osteo<- na.omit(tolower(descriptive_stats$`Other Osteoperosis drug`))
drug_antibio <- na.omit(tolower(descriptive_stats$`Antibiotic for comparison`))
drug_bisphos <- na.omit(tolower(descriptive_stats$Bisphosphonate))

# removes the attributes from the data 
attributes(drug_nsaid) <- NULL
attributes(drug_osteo) <- NULL
attributes(drug_antibio) <- NULL
attributes(drug_bisphos) <- NULL

#keywords to identify liver disease 
liver <- c("liver","hepatitis","cirrhosis","hepatic","Metastasis to liver","Metastases to liver")

#list of reactions to be identified
Hepatab <- read_excel("descriptive_stats.xlsx",sheet="hepatabilliary reaction")
reaction <- tolower(Hepatab$`Different type of hepatabillary output`)

#read the data - year 2013-2022, age group 18-85, Bisphosphonate users
all_case_bisphos1 <- read_excel("all_cases_bisphos1.xlsx")
all_case_bisphos2 <- read_excel("all_cases_bisphos2.xlsx")

#merge both the dataset to get in a collective for all Bisphosphonate
all_case_bisphos_final <- rbind(all_case_bisphos1,all_case_bisphos2)

#duplicate  records delete
all_case_bisphos_final1 <- all_case_bisphos_final[!duplicated(all_case_bisphos_final),]

#remove all records with reason for use as liver disease 
all_case_bisphos_final1$`Reason for Use` <- tolower(all_case_bisphos_final1$`Reason for Use`)
all_case_bisphos_final1$presence1 <- ifelse(rowSums(sapply(liver, function(word) grepl(word,all_case_bisphos_final1$`Reason for Use`))) > 0, 1, 0)

#remove patients which have either liver disease 
all_case_bisphos_final2 <- all_case_bisphos_final1[all_case_bisphos_final1$presence1==0,]

#Remove nsaid/antibiotic/other osteoporosis drug user from bisphosphonate user in concomitant  medication 
all_case_bisphos_final1$`Concomitant Product Names` <- tolower(all_case_bisphos_final1$`Concomitant Product Names`)
all_case_bisphos_final1$presence2 <- ifelse(rowSums(sapply(drug_nsaid, function(word) grepl(word,all_case_bisphos_final1$`Concomitant Product Names`))) > 0, 1, 0)

#remove patients which have either liver disease or bisphosphonate user or both
all_case_bisphos_final2 <- all_case_bisphos_final1[all_case_bisphos_final1$presence1==0 & all_case_bisphos_final1$presence2==0,-c(25,26)]

#Dataset 1a: consider only records with hepatabilliary reactions
#Dataset 1b: consider only records with no hepatabilliary reactions

all_case_bisphos_final2$Reactions <- tolower(all_case_bisphos_final2$Reactions)
all_case_bisphos_final2$presence <- ifelse(rowSums(sapply(reaction, function(word) grepl(word,all_case_bisphos_final2$Reactions))) > 0, 1, 0)

liver_bisphos <- all_case_bisphos_final2[all_case_bisphos_final2$presence==1,]
no_liver_bisphos<- all_case_bisphos_final2[all_case_bisphos_final2$presence==0,]

liv_bisp_no_nsaid<- nrow(liver_bisphos)
liv_bisp_no_osteo=nrow(liver_bisphos)
liv_bisp_no_anti=nrow(liver_bisphos)
no_liv_bisp_no_nsaid=nrow(no_liver_bisphos)
no_liv_bisp_no_osteo=nrow(no_liver_bisphos)
no_liv_bisp_no_anti=nrow(no_liver_bisphos)

#read the data - year 2013-2022, age group 18-85, Non-Bisphosphonate users, and NSAID user

all_case_nsaid1 <- read_excel("all_cases_nsaid1.xlsx")
all_case_nsaid2 <- read_excel("all_cases_nsaid2.xlsx")
all_case_nsaid3 <- read_excel("all_cases_nsaid3.xlsx")
all_case_nsaid4 <- read_excel("all_cases_nsaid4.xlsx")
all_case_nsaid5 <- read_excel("all_cases_nsaid5.xlsx")

#merge all the dataset to get in a collective for all NSAid
all_case_nsaid_final <- rbind(all_case_nsaid1,all_case_nsaid2,all_case_nsaid3,all_case_nsaid4,all_case_nsaid5)

#remove duplicate  records based on all fields
all_case_nsaid_final1 <- all_case_nsaid_final[!duplicated(all_case_nsaid_final),]

#remove all records with reason for use as liver disease  
all_case_nsaid_final1$`Reason for Use` <- tolower(all_case_nsaid_final1$`Reason for Use`)
all_case_nsaid_final1$presence1 <- ifelse(rowSums(sapply(liver, function(word) grepl(word,all_case_nsaid_final1$`Reason for Use`))) > 0, 1, 0)

#remove patients which have either reason for use as liver disease or bisphosphonate user or both
all_case_nsaid_final2 <- all_case_nsaid_final1[all_case_nsaid_final1$presence1==0,]

#Remove cases with concomitant  medication as Bisphosphonate
all_case_nsaid_final1$`Concomitant Product Names` <- tolower(all_case_nsaid_final1$`Concomitant Product Names`)
all_case_nsaid_final1$presence2 <- ifelse(rowSums(sapply(drug_bisphos, function(word) grepl(word,all_case_nsaid_final1$`Concomitant Product Names`))) > 0, 1, 0)

#remove patients which have either reason for use as liver disease or bisphosphonate user or both
all_case_nsaid_final2 <- all_case_nsaid_final1[all_case_nsaid_final1$presence1==0 & all_case_nsaid_final1$presence2==0,-c(25,26)]

#Dataset 2a: consider only records with hepatabilliary reactions
#Dataset 2b: consider only records with no hepatabilliary reactions

all_case_nsaid_final2$Reactions <- tolower(all_case_nsaid_final2$Reactions)
all_case_nsaid_final2$presence <- ifelse(rowSums(sapply(reaction, function(word) grepl(word,all_case_nsaid_final2$Reactions))) > 0, 1, 0)

liver_nsaid <- all_case_nsaid_final2[all_case_nsaid_final2$presence==1,]
no_liver_nsaid <- all_case_nsaid_final2[all_case_nsaid_final2$presence==0,]

# Other drugs used for Osteoporosis
all_case_osteo1 <- read_excel("all_case_osteo.xlsx")
all_case_osteo2 <- read_excel("all_case_osteo1.xlsx")

#merge both the dataset 
all_case_osteo_final1 <- rbind(all_case_osteo1,all_case_osteo2)

#remove duplicate  records based on all fields
all_case_osteo_final2 <- all_case_osteo_final1[!duplicated(all_case_osteo_final1$`Case ID`),]

#remove all records with reason for use as liver disease 
all_case_osteo_final2$`Reason for Use` <- tolower(all_case_osteo_final2$`Reason for Use`)
all_case_osteo_final2$presence1 <- ifelse(rowSums(sapply(liver, function(word) grepl(word,all_case_osteo_final2$`Reason for Use`))) > 0, 1, 0)

#Remove cases with concomitant  medication as Bisphosphonate
all_case_osteo_final2$`Concomitant Product Names` <- tolower(all_case_osteo_final2$`Concomitant Product Names`)
all_case_osteo_final2$presence2 <- ifelse(rowSums(sapply(drug_bisphos, function(word) grepl(word,all_case_osteo_final2$`Concomitant Product Names`))) > 0, 1, 0)

all_case_osteo_final3 <- all_case_osteo_final2[all_case_osteo_final2$presence1==0 & all_case_osteo_final2$presence2==0,-c(25,26)]

#Dataset 3a: consider only records with hepatabilliary reactions
#Dataset 3b: consider only records with no hepatabilliary reactions

all_case_osteo_final3$Reactions <- tolower(all_case_osteo_final3$Reactions)
all_case_osteo_final3$presence <- ifelse(rowSums(sapply(reaction, function(word) grepl(word,all_case_osteo_final3$Reactions))) > 0, 1, 0)

liver_osteo <- all_case_osteo_final3[all_case_osteo_final3$presence==1,]
no_liver_osteo <- all_case_osteo_final3[all_case_osteo_final3$presence==0,]

liver_group_osteo <- NULL
for (i in 1:length(reaction1)) {
  all_case_osteo_final3$Reactions <- tolower(all_case_osteo_final3$Reactions)
  all_case_osteo_final3$presence <- ifelse(rowSums(sapply(reaction1[i], function(word) grepl(word,all_case_osteo_final3$Reactions))) > 0, 1, 0)
  liver_group_osteo[i] <- nrow(all_case_osteo_final3[all_case_osteo_final3$presence==1,])
}
df <- cbind(reaction1,liver_group_osteo)

#read the data - year 2013-2022, age group 18-85, Non-Bisphosphonate users, and Antibiotic user

all_case_antibio1 <- read_excel("all_cases_antibio1.xlsx")
all_case_antibio2 <- read_excel("all_cases_antibio2.xlsx")
all_case_antibio3 <- read_excel("all_cases_antibio3.xlsx")

#merge all the dataset 
all_case_antibio_final <- rbind(all_case_antibio1,all_case_antibio2,all_case_antibio3)

#remove duplicate  records based on all fields
all_case_antibio_final1 <- all_case_antibio_final[!duplicated(all_case_antibio_final),]

#remove all records with reason for use as liver disease 
all_case_antibio_final1$`Reason for Use` <- tolower(all_case_antibio_final1$`Reason for Use`)
all_case_antibio_final1$presence1 <- ifelse(rowSums(sapply(liver, function(word) grepl(word,all_case_antibio_final1$`Reason for Use`))) > 0, 1, 0)

#Remove cases with concomitant  medication as Bisphosphonate
all_case_antibio_final1$`Concomitant Product Names` <- tolower(all_case_antibio_final1$`Concomitant Product Names`)
all_case_antibio_final1$presence2 <- ifelse(rowSums(sapply(drug_bisphos, function(word) grepl(word,all_case_antibio_final1$`Concomitant Product Names`))) > 0, 1, 0)

#remove patients which have either reason for use as liver disease or bisphosphonate user or both
all_case_antibio_final2 <- all_case_antibio_final1[all_case_antibio_final1$presence1==0 & all_case_antibio_final1$presence2==0,-c(25,26)]

#Dataset 4a: consider only records with hepatabilliary reactions
#Dataset 4b: consider only records with no hepatabilliary reactions

all_case_antibio_final2$Reactions <- tolower(all_case_antibio_final2$Reactions)
all_case_antibio_final2$presence <- ifelse(rowSums(sapply(reaction, function(word) grepl(word,all_case_antibio_final2$Reactions))) > 0, 1, 0)

liver_antibio <- all_case_antibio_final2[all_case_antibio_final2$presence==1,]
no_liver_antibio <- all_case_antibio_final2[all_case_antibio_final2$presence==0,]

# Zoledronic vs other bisphosphonate 

# Dataset with only zoledronic
all_case_zoledronic <- read_excel("all_cases_zoledronic.xlsx")

# Dataset with other bisphonsphonate
all_case_other_bisphos<- read_excel("all_cases_other_bisphos.xlsx")

#remove duplicate  records based on all fields
all_case_zol_final1 <- all_case_zoledronic[!duplicated(all_case_zoledronic),]
all_case_obisp_final1 <- all_case_other_bisphos[!duplicated(all_case_other_bisphos),]

#remove all records with reason for use as liver disease 
all_case_zol_final1$`Reason for Use` <- tolower(all_case_zol_final1$`Reason for Use`)
all_case_zol_final1$presence1 <- ifelse(rowSums(sapply(liver, function(word) grepl(word,all_case_zol_final1$`Reason for Use`))) > 0, 1, 0)

all_case_obisp_final1$`Reason for Use` <- tolower(all_case_obisp_final1$`Reason for Use`)
all_case_obisp_final1$presence1 <- ifelse(rowSums(sapply(liver, function(word) grepl(word,all_case_obisp_final1$`Reason for Use`))) > 0, 1, 0)

#Remove cases with concomitant  medication as the other compare group
all_case_zol_final1$`Suspect Product Active Ingredients` <- tolower(all_case_zol_final1$`Suspect Product Active Ingredients`)
all_case_zol_final1$presence2 <- ifelse(rowSums(sapply(c("ibandronate, ibandronic acid, risedronate, risedronic acid, alendronate, alendronic acid"), function(word) grepl(word,all_case_zol_final1$`Suspect Product Active Ingredients`))) > 0, 1, 0)

all_case_obisp_final1$`Suspect Product Active Ingredients` <- tolower(all_case_obisp_final1$`Suspect Product Active Ingredients`)
all_case_obisp_final1$presence2 <- ifelse(rowSums(sapply("zoledronic", function(word) grepl(word,all_case_obisp_final1$`Suspect Product Active Ingredients`))) > 0, 1, 0)

#remove patients which have either reason for use as liver disease or bisphosphonate user or both
all_case_zol_final1 <- all_case_zol_final1[all_case_zol_final1$presence1==0 & all_case_zol_final1$presence2==0,-c(25,26)]
all_case_obisp_final1 <- all_case_obisp_final1[all_case_obisp_final1$presence1==0 & all_case_obisp_final1$presence2==0,-c(25,26)]

#Dataset 5a: consider only records with hepatabilliary reactions
#Dataset 5b: consider only records with no hepatabilliary reactions

all_case_zol_final1$Reactions <- tolower(all_case_zol_final1$Reactions)
all_case_zol_final1$presence <- ifelse(rowSums(sapply(reaction, function(word) grepl(word,all_case_zol_final1$Reactions))) > 0, 1, 0)

liver_zoled <- all_case_zol_final1[all_case_zol_final1$presence==1,]
no_liver_zoled <- all_case_zol_final1[all_case_zol_final1$presence==0,]

#Dataset 6a; Dataset 6b
all_case_obisp_final1$Reactions <- tolower(all_case_obisp_final1$Reactions)
all_case_obisp_final1$presence <- ifelse(rowSums(sapply(reaction, function(word) grepl(word,all_case_obisp_final1$Reactions))) > 0, 1, 0)

liver_obisph <- all_case_obisp_final1[all_case_obisp_final1$presence==1,]
no_liver_obisph <- all_case_obisp_final1[all_case_obisp_final1$presence==0,]

#Descriptive stats

library(knitr)
data_table1%>%kable(caption="Summary of Bisphosphonate user excluding other antibiotic")

#Function to count the number of cases for each group
# Bisphosphonate user vs NSAID
# Bisphosphonate user vs other Osteoporosis
# Bisphosphonate user vs Antibiotic users 
# zoledronic user and other bisphosphonate user

#age function
extract_age <- function(age_strings) 
{
  ages_in_years <- numeric(length(age_strings))
  for (i in 1:length(age_strings)) {
    age_string <- age_strings[i]
    if (grepl("day", age_string)) {
      # Extract the number of days and convert to years
      age_in_days <- as.numeric(gsub(".*?(\\d+) day.*", "\\1", age_string))
      age_in_years <- age_in_days / 365
    } else {
      # Extract the age in years
      age_in_years <- as.numeric(gsub(".*?(\\d+) yr.*", "\\1", age_string))
    }
    ages_in_years[i] <- age_in_years
  }
  return(ages_in_years)
}

count_row <- function(dataset_list, dataset_names) {
  # Initialize an empty list to store the results
  results <- list()
  
  # Iterate through the datasets and calculate the sex and age 
  for (i in seq_along(dataset_list)) 
  {
    dataset <- dataset_list[[i]]
    name <- dataset_names[i]
    ddd<-drug[[i]]
    
    #remove all records with reason for use as liver disease 
    dataset$`Reason for Use` <- tolower(dataset$`Reason for Use`)
    dataset$presence1 <- ifelse(rowSums(sapply(liver, function(word) grepl(word,dataset$`Reason for Use`))) > 0, 1, 0)
    
    #Remove cases with concomitant  medication as compare group and liver disease
    dataset$`Suspect Product Active Ingredients` <- tolower(dataset$`Suspect Product Active Ingredients`)
    dataset$presence2 <- ifelse(rowSums(sapply(ddd, function(word) grepl(word,dataset$`Suspect Product Active Ingredients`))) > 0, 1, 0)
    
    dataset <- dataset[dataset$presence1==0 & dataset$presence2==0,-c(25,26)]
    
    #consider only records with either hepatabilliary reactions or no reaction
    dataset$Reactions <- tolower(dataset$Reactions)
    dataset$presence <- ifelse(rowSums(sapply(reaction, function(word) grepl(word,dataset$Reactions))) > 0, 1, 0)
    
    a<- nrow(dataset[dataset$presence==1,])
    b<- nrow(dataset[dataset$presence==0,] )
    #results[[name]] <- list(liver_present=a,no_liver=b)
    
    #count the age and sex
    
    age <- tolower(dataset$`Patient Age`)
    dataset$age <- extract_age(age)
    
    variables <- names(dataset)[names(dataset)%in%c("Sex","age")]
    data_table1 <- CreateTableOne(data=dataset, vars=variables, 
                                  includeNA = TRUE, addOverall = TRUE) %>%
    print(showAllLevels=TRUE)   #factorVars = factors
      
    # remove records with missing age and sex not specified
    dummy1 <- dataset %>%   filter(dataset$Sex != "Not Specified")
    dummy2 <- dummy1 %>%   filter(!is.na(dummy1$age))
    print(name)
    print(summary(glm(presence ~ Sex + age ,data=dummy2,family="binomial"))

  }
  
  # Return the results as a named list
  return(results)
}

datasets <- list(all_case_bisphos_final1,all_case_bisphos_final1,all_case_bisphos_final1,all_case_nsaid_final1,all_case_osteo_final2,all_case_antibio_final1)
data_name <- c("bisphos_nsaid","bisphos_osteo","bisphos_antibio","NSAID","Other Osteo","Antibio")
drug <- list(drug_nsaid,drug_osteo,drug_antibio,drug_bisphos,drug_bisphos,drug_bisphos)

result <- count_row(datasets,data_name)

#Get a table from the list
max_length <- max(sapply(result, length))
count_ae <- do.call(rbind, lapply(result, function(x) c(x, rep(NA, max_length - length(x)))))

#Count for each of the  livear reaction seperately
liver_group <- NULL
react_group <- Hepatab$`Category liver reaction`[!is.na(Hepatab$`Category liver reaction`)]
count_grp_row <- function(dataset, drug) {
  # Initialize an empty list to store the results
  results <- list()
  
  # Iterate through the datasets and calculate the number of rows for both cases
  for (i in seq_along(react_group)) {

    ddd<-drug
    name <- react_group[i]
    
    #remove all records with reason for use as liver disease 
    dataset$`Reason for Use` <- tolower(dataset$`Reason for Use`)
    dataset$presence1 <- ifelse(rowSums(sapply(liver, function(word) grepl(word,dataset$`Reason for Use`))) > 0, 1, 0)
    
    #Remove cases with concomitant  medication as compare group and liver disease
    dataset$`Suspect Product Active Ingredients` <- tolower(dataset$`Suspect Product Active Ingredients`)
    dataset$presence2 <- ifelse(rowSums(sapply(ddd, function(word) grepl(word,dataset$`Suspect Product Active Ingredients`))) > 0, 1, 0)
    
    dataset <- dataset[dataset$presence1==0 & dataset$presence2==0,-c(25,26)]
    
    #consider only records with either hepatabilliary reactions or no reaction
    dataset$Reactions <- tolower(dataset$Reactions)
    dataset$presence <- ifelse(rowSums(sapply(react_group[i], function(word) grepl(word,dataset$Reactions))) > 0, 1, 0)
    
    a<- nrow(dataset[dataset$presence==1,])
    b<- nrow(dataset[dataset$presence==0,] )
    results[[name]] <- list(liver_present=a,no_liver=b)
  }
  
  # Return the results as a named list
  return(results)
}

# all_case_bisphos_final1 & all_case_osteo_final2
result2 <- count_grp_row(all_case_bisphos_final1,drug_osteo)
#Get a table from the list
max_length <- max(sapply(result2, length))
count_bisph_grp_liv <- do.call(rbind, lapply(result2, function(x) c(x, rep(NA, max_length - length(x)))))

result3 <- count_grp_row(all_case_osteo_final2,drug_bisphos)
#Get a table from the list
max_length <- max(sapply(result3, length))
count_osteo_grp_liv <- do.call(rbind, lapply(result3, function(x) c(x, rep(NA, max_length - length(x)))))

#Derive ROR and CI values
install.packages("epitools")
library(epitools)

cond <- c("bisphos_nsaid","bisphos_osteo","bisphos_antibio","NSAID","Other Osteo","Antibio")
ror <- function(dataset_list2, dataset_names2) 
  {
  # Initialize an empty list to store the results
  result2 <- list()
  for(i in 1:3){
    dataset <- matrix(dataset_list[[i]],nrow=2)
    outcome <- c("liver","no liver")
    cond1 <- c(cond[i],cond[i+3])
    dimnames(dataset) <- list("Condition"=cond1, "Outcome"=outcome)
    name <- dataset_names[i]
    # Calculate the odds ratio and confidence interval
    result2 <- oddsratio(contingency_table)
  }
  return(result2)
}

program <- c('New Program', 'Old Program')
outcome <- c('Pass', 'Fail')
data <- matrix(c(1370,29117,13608,168712), nrow=2, ncol=2, byrow=TRUE)
dimnames(data) <- list('Program'=program, 'Outcome'=outcome)
data <- matrix(c(10,40,15,67), nrow=2, ncol=2, byrow=TRUE)

