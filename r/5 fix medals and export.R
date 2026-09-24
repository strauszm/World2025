####################################
# Michael Strausz
# Fix medals and export
# 9/24/2026 : 9/24/2026
####################################

library(tidyverse)
library(readr)

#fix medals data------------------------------
#first, find the medals here:
#https://www.olympedia.org/statistics/medal/country

#second, paste the data into a excel spreadsheet, rename the columns, and save
#as a csv called medals
#must save as UTF-8

#now, I will pull medals in:
medals <- read_csv("data/medals.csv")
View(medals)


#now I am going to remove the three incorrect variables
world2025<-world2025 |> dplyr::select(-bronze2024,-silver2024,-gold2024)

#now I want to confirm that world$countryID and medals$countryID are unique
world2025 |> 
  count(countryID) |> 
  filter(n>1)

medals |> 
  count(countryID) |> 
  filter(n>1)

#check for missing values in keys
world2025 |> 
  filter(is.na(countryID))

medals |> 
  filter(is.na(countryID))

#look for different coding in primary keys
setdiff(world2025$countryID, medals$countryID) 

#fix world to eliminate space before countryID
medals$countryID<-substring(medals$countryID,2)

#look for different coding in primary keys again
setdiff(world2025$countryID, medals$countryID)
setdiff(medals$countryID, world2025$countryID)

#make the medals primary key match the world2025 primary key
medals |> dplyr::select(country, countryID) |> View()
world2025 |> dplyr::select(country, countryID) |> View()

medals$countryID[medals$countryID=="NED"]<-"NLD"
medals$countryID[medals$countryID=="GER"]<-"DEU"
medals$countryID[medals$countryID=="IRI"]<-"IRN"
medals$countryID[medals$countryID=="BUL"]<-"BGR"
medals$countryID[medals$countryID=="DEN"]<-"DNK"
medals$countryID[medals$countryID=="CRO"]<-"HRV"
medals$countryID[medals$countryID=="SLO"]<-"SVN"
medals$countryID[medals$countryID=="TPE"]<-"TWN"
medals$countryID[medals$countryID=="PHI"]<-"PHL"
medals$countryID[medals$countryID=="ALG"]<-"DZA"
medals$countryID[medals$countryID=="INA"]<-"IDN"
medals$countryID[medals$countryID=="RSA"]<-"ZAF"
medals$countryID[medals$countryID=="SUI"]<-"CHE"
medals$countryID[medals$countryID=="POR"]<-"PRT"
medals$countryID[medals$countryID=="GRE"]<-"GRC"
medals$countryID[medals$countryID=="BOT"]<-"BWA"
medals$countryID[medals$countryID=="CHI"]<-"CHL"
medals$countryID[medals$countryID=="GUA"]<-"GTM"
medals$countryID[medals$countryID=="KOS"]<-"XKX"
medals$countryID[medals$countryID=="FIJ"]<-"FJI"
medals$countryID[medals$countryID=="GRN"]<-"GRD"
medals$countryID[medals$countryID=="MAS"]<-"MYS"
medals$countryID[medals$countryID=="MGL"]<-"MNG"
medals$countryID[medals$countryID=="ZAM"]<-"ZMB"

#AIN IS INDIVIDUAL NEUTRAL ATHLETES FROM RUSSIA AND BELARUS, SO I WILL LEAVE THEM OUT
#NO ENTRY IN WORLD2025 FOR PUERTO RICO SO I WILL LEAVE THEM OUT FOR NOW AS WELL
#NO ENTRY IN WORLD FOR EOR (REFUGEES) SO I WILL LEAVE THEM OUT FOR NOW AS WELL

#now I will make medals into only the key and the variables that I want in world2025
medals<-medals |> dplyr::select(-country)

world2025<-world2025 |> left_join(medals) #R discards our three observations in medals that
#lacked a corresponding id in world2025
#THE KEY MUST HAVE THE EXACT SAME NAME

#now let's replace the NAs with 0s since our medal data was comprehensive
world2025$gold2024[is.na(world2025$gold2024)]<-0
world2025$silver2024[is.na(world2025$silver2024)]<-0
world2025$bronze2024[is.na(world2025$bronze2024)]<-0

save(world2025, file="world2025.rda")
