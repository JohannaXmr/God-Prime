# God-Prime
Experiment Code and Data Analysis for the Replication of "Effects of subliminal priming of self and God on self-attribution of authorship for events" by Dijksterhuis, Preston, Wegner and Aarts (2008, Journal of Experimental Social Psychology)


Dijksterhuis, Preston, Wegner and Aarts (2008) investigated how thoughts of an agent induced through subliminal priming influence the perceived authorship of an action. In the experiment, participants were asked to perform a lexical decision task, categorizing words versus nonwords through button presses on a keyboard. If they reacted too slow, the computer would delete the letters after a certain (short) amount of time. After each lexical decision, the participants then had to express their feeling of authorship, judging on a Likert Scale whether they or the computer were responsible for the letters disappearing. The relevant experimental manipulation occurred before each appearance of the letters, where a masked, subliminal prime ("God" to diminish feeling of authorship, "I" to increase it or "Broccoli" as a neutral prime) was presented to the participants. 
Since we do only have access to a mostly German participant group, our experiment was designed using German stimuli. Therefore, we also didn’t use “broccoli” as a neutral prime, but “Pilz”, which is also a vegetable and has a similar length to “Gott” and “Ich”.


The code available in this repository allows the user to replicate the experiment and collect data, as well as analyze it. 
First, the createsession_god.R file has to be run, to create the randomized word and non-word trials. Then the gott.py script can be run which is used to present the experiment and to collect the data. Data analysis is done using the Auswertung.R file and the data files in the data directory.
