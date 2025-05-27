####################################
# Michael Strausz
# Importing and cleaning vdem
# 1/18/2025 : 1/21/2025
####################################
library(tidyverse)

vdem <- readRDS("data/V-Dem-CY-Full+Others-v14.rds")


vdem2023<-vdem %>% 
  filter(year==2023) %>% 
  select(country_name,country_text_id,v2x_freexp_altinf,v2xel_frefair, 
                v2x_cspart,v2xeg_eqdr,v2elcomvot,v2regdur,
                v2lgfemleg,v2cltort_ord,v2clstown_ord,v2svstterr,v2smprivex_ord,
                v2smpolsoc_ord,e_peaveduc,e_area)

#add polity2018
vdem %>% 
  filter(year>2017) %>% 
  select(country_name,year,e_p_polity,e_chga_demo,e_ti_cpi,e_peedgini,e_miinflat,e_pop,
         e_miferrat,e_pelifeex) %>% 
  group_by(year) %>% 
  filter(!is.na(e_p_polity)) %>% 
  summarize(mean=mean(e_p_polity),n=n())
df<-vdem %>% 
  filter(year==2018) %>% 
  select(country_name,e_p_polity)
vdem2023<-vdem2023 %>% left_join(df)

#add e_ti_cpi 2022
vdem %>% 
  filter(year>2000) %>% 
  select(country_name,year,e_ti_cpi,e_peedgini,e_pop,
         e_miferrat,e_pelifeex) %>% 
  group_by(year) %>% 
  filter(!is.na(e_ti_cpi)) %>% 
  summarize(mean=mean(e_ti_cpi),n=n())
df<-vdem %>% 
  filter(year==2022) %>% 
  select(country_name,e_ti_cpi)
vdem2023<-vdem2023 %>% left_join(df)

#add e_peedgini 2010
vdem %>% 
  filter(year>2000) %>% 
  select(country_name,year,e_peedgini,e_pop,
         e_miferrat,e_pelifeex) %>% 
  group_by(year) %>% 
  filter(!is.na(e_peedgini)) %>% 
  summarize(mean=mean(e_peedgini),n=n())
df<-vdem %>% 
  filter(year==2010) %>% 
  select(country_name,e_peedgini)
vdem2023<-vdem2023 %>% left_join(df)

#add e_gdp 2019
df<-vdem %>% 
  filter(year==2019) %>% 
  select(country_name,e_gdp)
vdem2023<-vdem2023 %>% left_join(df)

#add e_pop 2019
df<-vdem %>% 
  filter(year==2019) %>% 
  select(country_name,e_pop)
vdem2023<-vdem2023 %>% left_join(df)

#add e_miferrat 2020
df<-vdem %>% 
  filter(year==2020) %>% 
  select(country_name,e_miferrat)
vdem2023<-vdem2023 %>% left_join(df)

#add e_pelifeex 2022
df<-vdem %>% 
  filter(year==2022) %>% 
  select(country_name,e_pelifeex)
vdem2023<-vdem2023 %>% left_join(df)

#recode v2elcomvot
vdem2023$v2elcomvot[vdem2023$v2elcomvot>0]<-1

#recode v2regdur
vdem2023$v2regdur<-round(vdem2023$v2regdur/365,0)

#recode v2cltort_ord
vdem2023$v2cltort_ord<-as.factor(vdem2023$v2cltort_ord)
vdem2023$v2cltort_ord<-as.ordered(vdem2023$v2cltort_ord)
levels(vdem2023$v2cltort_ord)<-c("none", "weak","somewhat","mostly","complete")

#recode v2clstown_ord
vdem2023$v2clstown_ord<-as.factor(vdem2023$v2clstown_ord)
vdem2023$v2clstown_ord<-as.ordered(vdem2023$v2clstown_ord)
levels(vdem2023$v2clstown_ord)<-c("complete govt control","most","much","some","little govt control")

#recode v2smpolsoc_ord
vdem2023$v2smpolsoc_ord<-as.factor(vdem2023$v2smpolsoc_ord)
vdem2023$v2smpolsoc_ord<-as.ordered(vdem2023$v2smpolsoc_ord)
levels(vdem2023$v2smpolsoc_ord)<-c("Serious polarization",
                                   "Moderate polarization",
                                   "Medium polarization",
                                   "Limited polarization",
                                   "No polarization")
#recode e_p_polity
table(vdem2023$e_p_polity)
vdem2023$e_p_polity[vdem2023$e_p_polity<(-10)]<-NA

#recode e_pop
vdem2023$e_pop<-10000*vdem2023$e_pop

#rename variables
vdem2023<-vdem2023 %>% 
  rename(country=country_name, countryID=country_text_id,
         freeExp=v2x_freexp_altinf, freeFair=v2xel_frefair,
         csPart=v2x_cspart,equalRes=v2xeg_eqdr,comVote=v2elcomvot,
         regimeDur=v2regdur,femLeg=v2lgfemleg,torture=v2cltort_ord,
         govtOwner=v2clstown_ord,terrControl=v2svstterr,
         internetPriv=v2smprivex_ord,socPolarize=v2smpolsoc_ord,
         yearsEd=e_peaveduc,area=e_area,polity=e_p_polity,corruption=e_ti_cpi,
         edInequality=e_peedgini,gdpMillions=e_gdp,pop=e_pop,ferRate=e_miferrat,
         lifeExp=e_pelifeex) 

