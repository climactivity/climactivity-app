# Über 

## Szenemanager

Der Szenenmanager animiert den Szenenwechsel und hält die Viewports die nötig sind, um 2 Szenen gleichzeitig anzuzeigen. Schon besuchte Szenen werden in der ```history``` gespeichert und werden wiederhergestellt statt neu instanziiert zu werden. 
Falls die Szene zu der gewechselt wird die Methode ```receive_navigation``` hat, wird diese mit dem als ```navigation_data``` übergebenen Parameter _nach_ der Instanziierung aufgerufen (```onready vars``` sind also ```!= null```). 

## API 

Die Spielinhalte und die Nakama Instanz sind mit den ProjectSettings unter ```debug/settings/network``` definiert. 
Darüber lässt sich 

## ForestScene3d 

Die Hexgrid implementierung stammt von https://github.com/romlok/godot-gdhexgrid minus die Pathfinding-logik und mit anderem Basisvektor/Hex-Größe für pointy statt flat-topped Hexfelder.  

# Fortschritt

### schon Implementiert

- Infobyte/Quizansicht
- ein Anfang der 2.5D Wald-Szene 
- Szenen-Management
- Netzwerk-Verbindung zum Server

### zu tun

- alles Andere

### known Unknowns

- Einloggen mit dem Netzwerk
- In-App-Käufe

### unknown Unknows 
- unknown

# Prerequisites

Das Projekt verwendet Godot 3.2.3 (mit Mono-Support, der noch nicht wirklich benutzt wird)

# Building

Um mit Godot Projekte zu bauen müssen die Export-Templates installiert sein. 

Project -> Export 

oder

```bash
# godot muss im PATH sein, ist unter win zumindest nicht automatisch so
$ godot --export <platform>
``` 
