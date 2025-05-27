####################################
# Michael Strausz
# Importing and simplfying world
# 1/21/2025 : 2/20/2025
####################################
library(tidyverse)

load("data/world.rda")

world2025<-world %>% select(Country,Religion,Lang1,Colony,Independence,frac_eth,Womvote,bronze2024,silver2024,gold2024)

world2025<-world2025 %>% rename(country=Country,religion=Religion,lang=Lang1,colony=Colony,
                     indep=Independence,fracEth=frac_eth,womVote=Womvote)

setdiff(vdem2023$country, world2025$country)
setdiff(world2025$country,vdem2023$country)

#rename so that country names match--------------
world2025<-world2025 %>% mutate(country=recode(country,'Myanmar'="Burma/Myanmar",
                                               'Russian Federation'="Russia",
                                               'United States'=
                                                 "United States of America",
                                               'Viet Nam'="Vietnam",'Korea, Rep'=
                                                 "South Korea",'Korea, DPR'=
                                                 "North Korea",'Cote D\'Ivoire'=
                                                 "Ivory Coast",'Timor Leste'=
                                                 "Timor-Leste",'Turkey'="Türkiye",
                                               'Congo, Democratic Republic of'=
                                                 "Democratic Republic of the Congo",
                                               'Syrian Arab Republic'="Syria",
                                               'Congo, Republic of'=
                                                 "Republic of the Congo",
                                               'Gambia'="The Gambia",
                                               'Moldova, Republic of'="Moldova",
                                               'Swaziland'="Eswatini",
                                               'Trinidad & Tobago'="Trinidad and Tobago",
                                               'Bosnia & Herzegovina'="Bosnia and Herzegovina",
                                               'Czech Republic'="Czechia",
                                               'Sao Tome & Principe'=
                                                 "Sao Tome and Principe",
                                               'Macedonia'="North Macedonia"))
world2025<-full_join(vdem2023,world2025)

#add abbreviations to countries that were not in world
df<-as.data.frame(world2025 %>% filter (is.na(countryID)) %>% select(country) %>% 
                    arrange(country),
                  c("AND","ATG","BHS","BLZ","BRN","DMA","GRD","KIR","LIE","MHL",
                    "FSM","MCO","NRU","PLW","WSM","SMR","KNA","LCA","VCT","TON",
                    "TUV"),rownames=NULL)
df <- cbind(rownames(df), data.frame(df, row.names=NULL))
colnames(df)<-c("abbrev1","country")
world2025<-world2025 %>% left_join(df)
world2025<-world2025 %>% 
  mutate(countryID=case_when(is.na(countryID)~abbrev1,.default=countryID)) %>% 
  select(-abbrev1)

