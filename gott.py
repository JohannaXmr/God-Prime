#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Gott Prime Experiment
Input:  session/ses??.txt, session files 
Output: data/subj??.txt
"""

import time, string, codecs
from psychopy import core, visual, event, gui

def trial(word, prime, comp, corransw = 0, iti = 1):
    """
    in jeder Trial Funktion wird angegeben welches Wort bei der lexikalischen Entscheidungs-
    Aufgabe bearbeitet wird (word), ausserdem was der Prime ist (prime), nach wie vielen
    ms der Computer das Wort wieder loescht (comp) und wie lange das Inter Trial Intervall
    andauert (default ist 1 s)
    """
    
    #fuer mehr Praezision wird hier mit anzahl der frames statt core.wait gearbeitet
    # Code und Erklaerung warum Framerate etc. hier http://www.psychopy.org/coder/codeStimuli.html
    for frameN in range(19):
        if 0 <= frameN < 15:  # 1. Maske praesentieren fuer 15 frames (ca 250 ms)
            visual.TextStim(win, "XXXXXX", height = 30).draw()
        if 15 <= frameN < 16:  # Prime praesentieren fuer 1 frame (ca 17 ms)
            visual.TextStim(win, prime, height = 30).draw()
        if 16 <= frameN < 20: # 2. Maske praesentieren fuer 3 frames (ca 50 ms)
            visual.TextStim(win, "XXXXXX", height = 30).draw()
        win.flip()
    
    # Wort auf das reagiert werden soll wird angezeigt
    visual.TextStim(win, word, height = 30).draw()
    win.flip()
    
    event.clearEvents(eventType = None)
    # Dieser super coole Befehl loescht die eventuell im Buffer gespeicherten
    # Tasten und verhindert somit, dass ein Tastendruck vor dem Erscheinen des
    # Wortes sofort als pressed_key gespeichert wird 
    
    timer.reset() 
    # Zeit wird zurueckgesetzt, damit das Wort nach einer 
    # bestimmten Zeit (comp) geloescht wird
    
    response = None
    
    while response not in [1, 0]:
        pressed_key = event.getKeys(timeStamped = timer) 
        # event.getKeys speichert nonstop die gedrueckte Taste als pressed_key ein
        # wenn man nichts drueckt ist pressed_key dementsprechen leer []
        
        if pressed_key and pressed_key[0][0] == 'n':
            core.quit() # mit esc kann man das Experiment beenden
            
        if pressed_key and pressed_key[0][0] == 'e':
            response = 1 # wenn es ein Wort ist wird die response Variable
                         # auf 1 gesetzt
            rt = pressed_key[0][1]
        if pressed_key and pressed_key[0][0] == 'o':
            response = 0 # wenn es kein Wort ist auf 0
            rt = pressed_key[0][1]

        # wenn die Zeit abgelaufen ist, wird der loop gebrochen und response = 2
        if timer.getTime() > comp:
            response = 2
            rt = timer.getTime()
            break
    
    visual.TextStim(win, u'Wer war für das Verschwinden des Wortes verantwortlich?\n'+ 
            u'Drücke die entsprechende Taste von 1 - 6', wrapWidth = 800, height = 30, pos = (0, 150)).draw()
    likert.draw()
    
    win.flip()
    
    urheber = event.waitKeys()[0]
    # Hier wird geschaut, dass die VP auch wirklich irgend ne Zahl zwischen 1 und 6
    # angibt (das wird in der urheber Variable gespeichert) 
    # Mit esc kann man wieder den Versuch abbrechen.
    while urheber not in ["1", "2", "3", "4", "5", "6"]:
        urheber = event.waitKeys()[0]
        if urheber == "n":
            core.quit()
            
            
    win.flip()
    # kurze Wartezeit zwischen den Trials zum "Entspannen"
    # (1 s Entspannung ja ne is klar :'D)
    core.wait(iti)
    
    # Daten einspeichern
    datfile.write('%6s %6s %d %d %s %7.4f\n' %
                  (prime, word, corransw, response, urheber, rt))



#welches session file soll gemacht werden
Dlg1 = gui.Dlg(title = "VP Nummer")
Dlg1.addField('z.B. 001:')
VPnum = Dlg1.show() # Dialogbox anzeigen



timer = core.Clock()

#win = visual.Window(size = (640, 480), color = (0, 0, 0))
# kleines Testwindow, da funktioniert aber aus.. aeh Gruenden das text height Argument nicht ...

win = visual.Window(fullscr = True, allowGUI = False, units ='pix')

likert = visual.ImageStim(win, image = "graphics/Likertskala.jpg", pos = (0, 0), units = "pix")



visual.TextStim(win,

u'In jedem Durchgang wird dir eine Kombination aus Buchstaben präsentiert. '
u'Deine Aufgabe ist zu entscheiden, ob die Buchstaben ein Wort bilden oder nicht. '
u'Wenn es ein Wort ist drückst du bitte die grün markierte Taste,'
u' wenn es kein Wort ist, dann die rot markierte Taste.\n'
u'Bitte versuche, so schnell und so genau wie möglich zu reagieren.\n\n'
u'Reagierst du nicht schnell genug, löscht der Computer das Wort. '
u'Deine Aufgabe nach jedem Durchgang wird sein, einzuschätzen, ob du selbst'
u' für das Verschwinden des Wortes verantwortlich warst, oder der Computer. '
u'Bevor die Buchstaben erscheinen wird eine Maske aus XXXXXX angezeigt.'
u' Dies ist das Zeichen, dass der Durchgang beginnt. Bitte schaue ab dann auf diese Stelle des Bildschirms.\n\n'
u'Drücke eine beliebige Taste, um das Experiment zu beginnen.'
,height = 20, wrapWidth = 500).draw()
win.flip()
if event.waitKeys()[0] == 'n':
    core.quit() #Beenden mit esc
    
win.flip()
core.wait(1)

# Trials werden gestartet und Datafile angelegt
with codecs.open('data/subj' + VPnum[0] + '-' + time.strftime("%Y%m%d_%H%M", time.localtime()) + '.txt',
          'w', encoding = 'utf-8') as datfile:
    datfile.write('prime word corrans resp urheber rt\n')
    
    with open('session/ses' + VPnum[0] + '.txt', 'r') as sesfile:
        exec(sesfile)
    

#Endscreen mit danke sagen undso
visual.TextStim(win,
  u'Danke für die Teilnahme an unserem Experiment :)\n\n'
  'Jetzt kommen nur noch ein paar Fragen, dann bist du fertig!',
  height = 40, wrapWidth = 700).draw()
win.flip()
event.waitKeys()

win.close()

DlgX = gui.Dlg(title = "Versuchspersonen Daten")
DlgX.addField(u'Konntest du etwas anderes als XXXXXX vor den Wörtern lesen?',
                choices = ["Nein", "Ja"])
DlgX.addField('Wenn ja, was?')
X = DlgX.show()

while True:
    if DlgX.OK:
        break
    else:
        X = DlgX.show() # Dialogbox nochmal anzeigen falls VP zu bloed ist auf ok zu druecken
        

# VP Daten erheben
myDlg = gui.Dlg(title = "Versuchspersonen Daten")
myDlg.addField('Alter:')
myDlg.addField('Geschlecht:', choices = ["weiblich", "maennlich", "sonstige"])
myDlg.addField('Familienstand:', choices = ["ledig", "verheiratet", "geschieden", 
                "in eingetragener Lebenspartnerschaft", "verwitwet"]) 
myDlg.addField('Muttersprache:', choices = ["Deutsch", "Anderes"])
myDlg.addField('Bildungsgrad:', choices = ["Abi", "anderes"])
myDlg.addField('Was war deine letzte Mathe Note in der Schule?')
myDlg.addField('Glaubst du an Gott?', choices = ["Ja", "Nein"])
myDlg.addField('Magst du Brokkoli?', choices = ["Ja", "Nein"])
myDlg.addField('Magst du Pilze?', choices = ["Ja", "Nein"])
 
VPdata = myDlg.show() # Dialogbox anzeigen
while True:
    if myDlg.OK:
        break
    else:
        VPdata = myDlg.show() # Dialogbox nochmal anzeigen falls VP zu bloed ist auf ok zu druecken
        

Sprache = VPdata[3]
Gott = VPdata[6]
Alter = VPdata[0]
Ausschluss = X[0]
Ausschluss_was = X[1]

with codecs.open('data/subj' + VPnum[0] + '-glauben.txt',
          'w', encoding='utf-8') as datfile:
    datfile.write(Gott + "\n" + Sprache + "\n" + Alter + "\n" + Ausschluss + "\n" + Ausschluss_was)
    

# Restliche Variablen einspeichern, eigentlich unnoetig, aber wenn man die schon erhebt...

Geschlecht = VPdata[1]
Familienstand = VPdata[2]
Bildung = VPdata[4]
Mathe = VPdata[5]
Pilze = VPdata[7]
Brokkoli = VPdata[8]

with codecs.open('data/subj' + VPnum[0] + '-derunnoetigeRest.txt',
          'w', encoding='utf-8') as datfile:
    datfile.write(Geschlecht + "\n" + Familienstand + "\n" 
                + Bildung + "\n" + Mathe+ "\n" + Pilze + "\n" + Brokkoli)