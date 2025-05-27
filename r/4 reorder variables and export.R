####################################
# Michael Strausz
# Read in TRIP data
# 2/20/2025 : 2/20/2025
####################################

library(tidyverse)

world2025<-world2025 %>% select(
  
country,
countryID,

#democracy variables----------------
freeFair,
comVote,
femLeg,
polity,

#human rights variables-------------
torture,
freeExp,
internetPriv,
tripScore,

#society variables----------------
csPart,
socPolarize,
yearsEd,
corruption,
edInequality,
religion,
lang,
fracEth,

#economic variables--------------
equalRes,
govtOwner,
gdpMillions,

#history variables---------
regimeDur,
colony,
indep,
womVote,

#demographics and geography
terrControl,
area,
pop,
ferRate,
lifeExp,

#sports
bronze2024,
silver2024,
gold2024)

#export--------
save(world2025, file="world2025.rda")
