##### geplante Auswertung God-Prime-Replikation ##### 
# Auswertung.R
# Input: subj***-2018****.txt, subj***-glauben.txt
# Output: -
#
# Contents: (a) Daten einlesen 
#	    (b) Replikation der ANOVA im Paper
#	    (c) Abbildung zur ANOVA
#	    (d) Auswertung mittels Siganlentdeckungstheorie (ROC)
#	    (e) Tests der AUCs (Wilcoxon und Bayes)
#	   

####################### (a) ##########################
# alle file Namen, die kein "glauben" oder "Rest" file sind in fnames 
# einspeichern
# (in den Glauben Files stehen in 5 Zeilen Glauben, Muttersprache, Alter und
# ob die VP was beim Flackern gesehen hat und wenn ja, was)
fnames <- dir(pattern = "*.txt")[!dir(pattern = "*.txt") %in% 
			c(dir(pattern = "glauben"), dir(pattern = c("Rest")))]
# die Glauben Filenames auch noch in den Vektor einspeichern
fglauben <- dir(pattern = "glauben")
frest <- dir(pattern = "rest")

# fnames und fglauben sollten die gleiche Anzahl haben

glauben <- NULL
Sprache <- NULL
Alter <- NULL
gesehen <- NULL

# Vektoren erstellen mit Glauben, Muttersprache, 
# Alter und dem Prime-Erkannt-Ausschluss
# fuer jede VP eine Stelle im Vektor
for (g in fglauben){
	glauben <- c(glauben, readLines(g)[1])
	Sprache <- c(Sprache, readLines(g)[2])
	Alter <- c(Alter, readLines(g)[3])
	gesehen <- c(gesehen, readLines(g)[4])
}

for (r in frest){
	sex <- c(sex, readLines(r)[1])
}

# Welche Personen haben was gesehen?

for (c in fglauben[gesehen == "Ja"]){
	
	if ("Gott" %in% unlist(strsplit(readLines(c)[5], split = " "))){
		print(c)
	}
	if ("Pilz" %in% unlist(strsplit(readLines(c)[5], split = " "))){
		print(c)
	}
	if ("Ich" %in% unlist(strsplit(readLines(c)[5], split = " "))){
		print(c)
	}
}

# "subj007-glauben.txt"
# "subj026-glauben.txt"


agg <- NULL
fnames2 <- NULL
fglauben2 <- NULL
A <- 0 # Anzahl der Ausgeschlossenen
i <- 0 # Index der im for-loop mitlaeuft
boese <- NULL # welche VP werden ausgeschlossen

for (f in fnames){
    i <- i + 1
	dat <- read.table(f, header = T)
	
	if (mean(dat$corrans[15:140] == dat$resp[15:140]) > .1 && Alter[i] >= 18 
	&& Alter[i] <= 60 && Sprache[i] == "Deutsch" && f != 
		"subj007-20180125_1749.txt" && f != "subj026-20180206_1916.txt") {
			
			# wenn die VP mehr als 10 Prozent richtig hat, 
			# ihr Alter zwischen 18 und 60 ist
			# und ihre Muttersprache Deutsch ist, 
			# werden die Daten benutzt und in das Data Frame
			# eingespeichert bzw. aggregiert
			agg_neu <- aggregate(urheber ~ prime, dat, mean)[c(1,3), ] 
			# nur primes gott und pilz
			agg_neu$id <- i
			agg_neu$glauben <- glauben[i]
			agg_neu$score <- mean(dat$corrans[15:140] == dat$resp[15:140])
			agg_neu$sex <- sex[i]
			agg_neu$age <- Alter[i]
			
			agg <- rbind(agg, agg_neu)
			# die Filenames von nicht ausgeschlossenen Personen
		        # werden gespeichert
			fnames2 <- c(fnames2, f)
			fglauben2 <- c(fglauben2, fglauben[i])
		} else {

			# erfuellt eine VP diese Kriterien nicht, 
			# passiert nichts mit den Daten,
			# Aber A wird um 1 groesser, damit man am Ende sieht, 
			# wie viele ausgeschlossen wurden
			boese <- c(boese, f)
			A <- A + 1
		}
}

agg$glauben <- factor(agg$glauben)
agg$id <- factor(agg$id)

#######

### VP Daten

range(as.numeric(agg[!duplicated(agg$id), ]$age))
mean(as.numeric(agg[!duplicated(agg$id), ]$age))


range(agg[!duplicated(agg$id), ]$score)
mean(agg[!duplicated(agg$id), ]$score)

table(agg[!duplicated(agg$id), ]$sex)

cor.test(agg[!duplicated(agg$id), ]$score,
as.numeric(agg[!duplicated(agg$id), ]$age))


# plot(score ~ as.numeric(age), agg[!duplicated(agg$id), ], pch = 16, cex = .7)
# abline(lm(score ~ as.numeric(age), agg[!duplicated(agg$id), ]))

####################### (b) ##########################
#2x2 Anova
summary(aov(urheber ~ glauben * prime + Error(id/prime), agg))

####################### (c) ##########################
# Abbildung
# Daten einlesen in einem grossen Dataframe

abb <- aggregate(urheber ~ glauben + prime, agg, mean)
abb$sd <- aggregate(urheber ~ glauben + prime, agg, sd)[, 3]
abb$n <- aggregate(urheber ~ glauben + prime, agg, length)[, 3]
abb$se <- abb$sd/sqrt(abb$n)




# Plot
plot(urheber[abb$glauben == "Ja" & abb$prime != "Ich"] ~ 
     as.numeric(prime)[abb$glauben == "Ja" & abb$prime != "Ich"], 
     abb, ylim = c(0, 7), ylab = "Perceived Authorship", 
     xlab = "Prime", xlim = c(0.5, 3.5), col = "grey50", pch = 16,
     axes = FALSE, type = "b")

points(urheber[abb$glauben == "Nein" & abb$prime != "Ich"] ~ as.numeric(prime)
       [abb$glauben == "Nein" & abb$prime != "Ich"], abb, col = "black",
       pch = 17, type = "b")
# Achsen
axis(2)
axis(1, at = c(1, 3), labels = c("Gott", "Pilz"))

# Fehlerbalken
arrows(c(1, 3), abb$urheber[abb$glauben == "Ja" & abb$prime != "Ich"]-
       abb$se[abb$glauben == "Ja" & abb$prime != "Ich"], c(1, 3), 
	abb$urheber[abb$glauben == "Ja" & abb$prime != "Ich"]+
	abb$se[abb$glauben == "Ja" & abb$prime != "Ich"], angle = 90,
	code = 3, col = "grey50", length = 0.15)
arrows(c(1, 3), abb$urheber[abb$glauben == "Nein" & abb$prime != "Ich"]-
       abb$se[abb$glauben == "Nein" & abb$prime != "Ich"], c(1, 3), 
	abb$urheber[abb$glauben == "Nein" & abb$prime != "Ich"]+abb$se
	[abb$glauben == "Nein" & abb$prime != "Ich"], angle = 90, code = 3, 
	length = 0.15)
# Legende

text(2,2.3,"Believers", cex = .7, col = "grey50")
text(2,3,"Non-Believers", cex = .7)


####################### (d) ##########################
#### fuer die ROC pro Person ###
# wir verwenden das Paket "pROC"
#  install.packages("pROC")
library("pROC")

# fuer Gott- Pilz
la <- NULL
unter_g <- NULL
i <- 0
for(f in fnames2){
	i <- i + 1
	la <- read.table(f, header= TRUE)
	la <- droplevels(la[la$prime != "XXXXXX", ])
	la$glauben <- rep(glauben[i], 126)
	# bis hierher war alles wie vorhin
	# nun mit roc aus pROC die area under the curve pro Person 
	# berechnen
	ag <- roc(response = la$prime,
		  predictor = la$urheber,
		  levels = c("Gott", "Pilz"))$auc[1]
	# aus der Liste einen Dataframe machen
	ag <- as.data.frame(ag)
	ag$glauben <- la$glauben[1]
	# alle AUCs und den Glauben in einen Dataframe speichern
	unter_g <- rbind(unter_g, ag) 
}

# fuer Ich- Pilz
la <- NULL
unter_i <- NULL
i <- 0
for(f in fnames2){
	i <- i + 1
	la <- read.table(f, header= TRUE)
	la <- droplevels(la[la$prime != "XXXXXX", ])
	la$glauben <- rep(glauben[i], 126)
	# dieses Mal betrachten wir die Primes Ich und Pilz
	ag <- roc(response = la$prime,
		  predictor = la$urheber,
		  levels = c("Ich", "Pilz"))$auc[1]
	ag <- as.data.frame(ag)
	ag$glauben <- la$glauben[1]
	unter_i <- rbind(unter_i, ag) 
}


####################### (e) ##########################
# Tests
# fuer Gott vs. Pilz
# Wilcoxon Rang Summentest
wilcox.test(unter_g$ag[unter_g$glauben == "Ja"], 
	    unter_g$ag[unter_g$glauben == "Nein"], alternative = "greater")


# fuer Ich vs. Pilz
# Gibt es einen Unterschied zwischen den Gruppen - Wilcoxon Rang Summentest
wilcox.test(unter_i$ag[unter_i$glauben == "Ja"], 
     unter_i$ag[unter_i$glauben == "Nein"])

# Sind die AUC groesser als 0.5 - Wilcoxon Vorzeichen Rang Test
wilcox.test(unter_i$ag, mu = .5) 



# zum veranschaulichen:
par(mfrow = c(1,2))
plot(ag ~ as.factor(glauben), unter_g)
plot(ag ~ as.factor(glauben), unter_i)


################