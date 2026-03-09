#####Examen du TD1#######


setwd("C:/Users/DELL/Desktop/MASTER ECO-APPLIQUEE FRANCE/Mon  ANNEE/2e semestre/Evaluation de politique publiques, application sous R/Travaux Pratiques/entrainement")

#INSTALLATION DES PACKAGES

install.packages("readxl")
install.packages("haven")
install.packages("questionr")
install.packages("formattable")
install.packages("miceadds")
install.packages("sandwich")
install.packages("psych")
install.packages("car")
install.packages("carData")

#Lecture

library(readxl)
library(haven)
library(questionr)
library(formattable)
library(miceadds)
library(sandwich)
library(psych)
library(car)
library(carData)

#####PARTIE DU TD1

#1) Importation de la BDD comportant les données


gujarati <- read_excel("Donnees_Gujarati2011.xlsx", sheet="Donnees")



##2) Importation de la partie DICO

Dico <- read_excel("Donnees_Gujarati2011.xlsx", sheet="Dico")

##3) Description rapide de la BDD


dim(gujarati)

str(gujarati
)

#Manipulation des données  

#4. Créer une variable représentant le logarithme du salaire 

gujarati$log_wage <- log(gujarati$wage) 


#5. Créer une variable représentant l’âge au carré 
gujarati$carre_age <- gujarati$age * gujarati$age


#6. Créer une dummy « pas d’éducation » 

gujarati$dum_educ <- NULL

gujarati$dum_educ[gujarati$education >0]= 1
gujarati$dum_educ[gujarati$education==0] =0





#7. Créer une variable catégorielle à partir de la variable éducation avec les catégories suivante : 
# a. Inférieur à 6 ans 
#b. Entre 6 et 13 ans 
#c. Plus de 13 ans 


gujarati$bin_educ <- NULL

gujarati$bin_educ[gujarati$education < 6]="Inférieur à 6"
gujarati$bin_educ[gujarati$education>= 6 & gujarati$education <=13]= "Entre 6 et 13"
gujarati$bin_educ[gujarati$education > 13]= "Plus de 13"



#Analyses univariées


#8. Générez des statistiques pour l’ensembles des variables de la base 

summary(gujarati)





#9. Décrivez la variable « salaire » à l’aide de statistiques et de graphiques 

summary(gujarati$wage)
sd(gujarati$wage)

#Graphique: hist et boxplot

hist(gujarati$wage,
     col="blue",
     main=paste("Histogramme du salaire"),
     xlab="salaire",
     ylab="effectifs",
     ylim=c(0,600))



boxplot(gujarati$wage,
        col="blue",
        main=paste("Boxplot du salaire"),
        xlab="salaire",
        
        horizontal=TRUE)


#10. Décrivez la variable « education » à l’aide de statistiques et de graphiques 

summary(gujarati$education)
table(gujarati$education)
sd(gujarati$education)

#Graphique: Barplot et boxplot


boxplot(table(gujarati$education),
        col="red",
        main=paste("Boxplot de l'éducation"),
        xlab="éffectifs",
        
        horizontal=TRUE)



barplot(table(gujarati$education),
        col="red",
        main=paste("Barplot de l'éducation"),
        xlab="années d'éducation",
        ylab="Effectifs",
        ylim=c(0,800)
)



#11. Décrivez la variable « syndiqué » à l’aide de statistiques et de graphiques 


table(gujarati$union)
prop.table(table(gujarati$union))

#Graphique; BARPLOT ET diagramme circulaire

barplot(table(gujarati$union),
        col="yellow",
        main=paste("Barplot du statut syndical"),
        xlab="union",
        ylab="Effectifs",
        ylim=c(0,1200)
)


tab  <- table(gujarati$union)

prop <- round(prop.table(tab),2)


labels<-paste(c("Syndiqué", "Non syndiqué"), "\n",prop)


pie(tab,
    col=c("purple","green"),
    labels=labels,
    main=paste("Diagramme circulaire du statut syndical"))




#Analyses bivariées 


#12. Commentez les différences de salaires entre hommes et des femmes 

boxplot(gujarati$wage ~ gujarati$female,
        horizontal=TRUE,
        col=c("blue","red"),
        xlab="salaire",
        ylab="femme",
        main=paste("Dispersion du salaire entre les femmes et les hommes")
)

t.test(data=gujarati, wage~female)





#13. Même question pour les différences de niveau d’éducation entre hommes et femmes 
boxplot(gujarati$education ~ gujarati$female,
        horizontal=TRUE,
        col=c("green","red"),
        xlab="années d'éducation",
        ylab="femme",
        main=paste("Dispersion d'éducation entre les femmes et les hommes")
)


t.test(data=gujarati, education~female)




#14. Même question pour le fait d’être syndiqué entre hommes et femmes 


table(gujarati$union, gujarati$female)

chisq.test(gujarati$union, gujarati$female)







#15. Commentez le lien entre le niveau de salaire et le niveau d’éducation 



cor(gujarati$wage, gujarati$education)


cor.test(gujarati$wage, gujarati$education)


#16. Estimez à l’aide de la méthode des MCO les variations de salaire à partir du fait d’être non
#blanc. 

reg_LS <- lm(data=gujarati, wage~education)

summary(reg_LS)


#17  Estimez à l’aide de la méthode des MCO les variations de salaire à partir du nombre d’années 
#d’éducation et d’être non-blanc. Commentez la différence avec le modèle précédent.  


reg_LM <- lm(data=gujarati, wage~education+nonwhite)

summary(reg_LM)

plot(gujarati$education, gujarati$wage,
     col="cornflowerblue",
     main = "Salaire en fonction du nombre d'années d'études",
     xlab = "Nombre d'années d'études", 
     ylab="Salaire horaire (en dollars)")

abline(reg_LS, col = "deepskyblue4")




#####TD2: CADRE DU MODELE DE RUBIN



library(readxl)
library(haven)
library(questionr)
library(formattable)
library(miceadds)
library(sandwich)
library(psych)
library(car)
library(carData)



#Importation de la BDD

hisp   <- read_dta("evaluation.dta")

#Description de la BDD

#Variable health_expenditure

summary(hisp$health_expenditures)

sd(hisp$health_expenditures)

boxplot(hisp$health_expenditures,
        horizontal=TRUE,
        xlab="Dépenses de santé",
        main=paste("Boxplot des dépenses de santé"))

hist(hisp$health_expenditures,
     horizontal=TRUE,
     xlab="Dépenses de santé",
     ylab="effectifs",
     main=paste("histogramme des dépenses de santé"))





#CAS DE age_hh: Var quantitativ disc


summary(hisp$age_hh)

sd(hisp$age_hh)



boxplot(hisp$age_hh,
        horizontal=TRUE,
        xlab="age_hh",
        main=paste("Boxplot age chef de famille"))

barplot(table(hisp$age_hh),
        col="red",
        xlab="age_hh",
        ylab="effectifs",
        main=paste("Barplot age_hh"),
        ylim=c(0,1000))






#CAS DE age_hh: Var quantitativ disc


summary(hisp$educ_hh)

sd(hisp$educ_hh)



boxplot(hisp$educ_hh,
        horizontal=TRUE,
        xlab="educ_hh",
        main=paste("Boxploteducation chef de famille"))

barplot(table(hisp$educ_hh),
        col="blue",
        xlab="educ_hh",
        ylab="effectifs",
        main=paste("Barplot educ_hh"),
        ylim=c(0,7000)
)

#Indigenous

table(hisp$indigenous)
barplot(table(hisp$indigenous),
        col="blue",
        xlab="indgenous",
        ylab="effectifs",
        main=paste("Barplot indigenous"),
        ylim=c(0,13000)
)




#CAS DE educ_sp: Var quantitativ disc


summary(hisp$educ_sp)

sd(hisp$educ_sp)

boxplot(hisp$educ_sp,
        horizontal=TRUE,
        xlab="educ_sp",
        main=paste("Boxploteducation femme"))



barplot(table(hisp$educ_sp),
        col="blue",
        xlab="educ_sp",
        ylab="effectifs",
        main=paste("Barplot educ_sp"),
        ylim=c(0,7000)
)



table(hisp$female_hh)




barplot(table(hisp$female_hh),
        col="blue",
        xlab="female_hh",
        ylab="effectifs",
        main=paste("Barplot female_hh"),
        ylim=c(0,18000)
)


tab  <- table(hisp$female_hh)
prop <- round(prop.table(tab),2)
label<-paste(c("Femme","Homme"), "\n", prop)

pie(tab,
    col=c("blue","red"),
    labels=label,
    main=paste("Diagramme circulaire female"))





#HHSIZE

summary(hisp$hhsize)

sd(hisp$hhsize)



boxplot(hisp$hhsize,
        horizontal=TRUE,
        xlab="hhsize",
        main=paste("Boxplot de hhsize"))

barplot(table(hisp$hhsize),
        col="yellow",
        xlab="hhsize",
        ylab="effectifs",
        main=paste("Barplot hhsize"),
        ylim=c(0,7000)
)




#Var ditflorr


table(hisp$dirtfloor)




barplot(table(hisp$dirtfloor),
        col="blue",
        xlab="dirtflorr",
        ylab="effectifs",
        main=paste("Barplot dirtfloor"),
        ylim=c(0,18000)
)


tab  <- table(hisp$dirtfloor)
prop <- round(prop.table(tab),2)
label<-paste(c("oui","non"), "\n", prop)

pie(tab,
    col=c("blue","green"),
    labels=label,
    main=paste("Diagramme circulaire dirtfloor"))







summary(hisp$land)

sd(hisp$land)

boxplot(hisp$land,
        horizontal=TRUE,
        xlab="Land",
        main=paste("Boxplot land"))

hist(hisp$land,
     horizontal=TRUE,
     xlab="land",
     ylab="effectifs",
     main=paste("histogramme de land"))






#Cas de la variable Enrolled.


table(hisp$enrolled)




barplot(table(hisp$enrolled),
        col="green",
        xlab="enrolled",
        ylab="effectifs",
        main=paste("Barplot enrolled"),
        ylim=c(0,15000)
)


tab  <- table(hisp$enrolled)
prop <- round(prop.table(tab),2)
label<-paste(c("oui","non"), "\n", prop)

pie(tab,
    col=c("blue","green"),
    labels=label,
    main=paste("Diagramme circulaire enrolled"))


#4) Déterminez le changement dans le temps des dépenses de santé des ménages inscrits au 
programme. Concluez. 


#Etape 1: Constitution de la BDD des traités

hisp_T <- subset(hisp,hisp$treatment_locality==1 & enrolled==1)

dim(hisp_T)


#Etape : vérifions s'il y'a une différence avant et après le traitement.
t.test(data=hisp_T, health_expenditures~round)

reg_hisT_LS <- lm(data=hisp_T,health_expenditures~round)


#Il ne s'agit pas là d'un impact.






summary(reg_hisT_LS)

#Testons la stabilité de ce résultat après rajout de variable



reg_hisT_LM <- lm(data=hisp_T,health_expenditures~round+age_hh+age_sp+educ_hh+educ_sp+hhsize+dirtfloor+female_hh
                  +land+bathroom)


summary(reg_hisT_LM)




#Comparez les dépenses de santé dans les villages pilotes entre les individus qui ont demandé à bénéficier du programme et les autres après la mise en place du programme. Concluez.

#Etape 1: Echantillon des individus après le traitement

hisp_TN <-subset(hisp, hisp$treatment_locality==1 & round==1)


t.test(data= hisp_TN, hisp_TN$health_expenditures~hisp_TN$enrolled)


reg_hisp_TN_LS <- lm(data=hisp_TN,health_expenditures~enrolled )

summary(
  reg_hisp_TN_LS)



#Testons la stabilité


reg_hisp_TN_LM <- lm(data=hisp_TN,health_expenditures~enrolled+age_hh+age_sp+educ_hh+educ_sp+hhsize+dirtfloor+female_hh
                     +land+bathroom )

summary(
  reg_hisp_TN_LM)
