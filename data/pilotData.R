# Um zu schauen, ob unsere Auswertung funktioniert, haben wir
# Datensaetze simuliert und diese mit Auswertung.R analysiert


for(VP in 1:10) { # For Schleife, die 10 mal durchlaeuft 
	
	
	df.trial <- data.frame(prime = "XXXXXX",
						 corrans = rep(1:2, 7),
						 resp = rep(1:2, 7),
						 urheber = 0
						)
	
	df.ind <- data.frame(prime = rep(c("Ich", "Pilz", "Gott"), each = 42),
						 corrans = rep(1:2, 63),
						 resp = rep(1:2, 63)
						)
	# jedes Mal wird ein neues Data Frame erstellt
	zufall <- sample(1:2, 1)
	
	if (zufall == 1) {
		
		#glaeubig
		glauben = "Ja"
		df.ind$urheber = round(c(rnorm(42, 5, 1), rnorm(42, 3, 1), 
								rnorm(42, 1, 1)))
			
		} else {

		glauben = "Nein"
		df.ind$urheber = round(c(rnorm(42, 5, 1), rnorm(42, 3, 1), 
								rnorm(42, 3, 1)))
		}

	fname <- paste0("subj", sprintf("%03d", VP), ".txt")
	# Namen der jeweiligen Files werden erzeugt
	
	fname2 <- paste0("subj", sprintf("%03d", VP), "-glauben.txt")
	
	df.glauben <- data.frame(zeugs = c(glauben, "Deutsch", 
										as.character(sample(17:63,1)), "Nein"))
	
	dat <- rbind(df.trial, df.ind)
	
	
	write.table(dat, fname, row.names = F, quote = F)
	write.table(df.glauben, fname2, row.names = F, col.names = F, quote = F)
	# und die Data Frames darin abgespeichert
}
