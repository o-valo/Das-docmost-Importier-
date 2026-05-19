

# Das Docmost Importier 🏗️

Das Docmost Importier ist ein robuster Systemdienst für Linux, der wie ein treues Arbeitstier stoisch im Hintergrund schuftet. Er überwacht ein definiertes Verzeichnis vollautomatisch auf neu eingehende Dokumente in den Formaten HTML, Markdown (.md) und reinen Text (.txt) und schiebt sie automatisch in deinen Docmost-Space.

Sobald eine Datei im Watch-Folder landet, schnappt sich das Skript die Arbeit:
* **HTML-Dateien** (z. B. aus KI-Chats vom Gemini Chat Exporter) werden per Pandoc blitzschnell in sauberes GitHub-Flavored-Markdown verwandelt.
* **Markdown-Dateien (.md)** werden ohne Umwege direkt für den Upload vorbereitet.
* **Textdateien (.txt)** (wie Skripte oder rohe Logbucheinträge) werden automatisch in einen sicheren Markdown-Code-Block verpackt, damit keine einzige Einrückung oder Formatierung verloren geht.

## Highlights 🚀
* **Arbeitstier-Modus:** Läuft als systemd-Dienst und startet bei Fehlern automatisch neu.
* **Smarte Konvertierung:** Verwendet Pandoc, um HTML in GitHub-Flavored Markdown (GFM) zu übersetzen.
* **Sicherer Login:** Beherrscht den Umgang mit komplexen Passwörtern und extrahiert Session-Tokens direkt aus den API-Headern.
* **Ressourcenschonend:** Reagiert dank inotify sofort auf neue Dateien, ohne die CPU mit Polling zu belasten.

---

## Installation & Einrichtung

### 1. Voraussetzungen installieren (Ubuntu/Debian)
Bevor es losgeht, müssen die benötigten Werkzeuge auf deinem Server vorhanden sein. Nutze dafür diesen schnellen One-Liner:
```bash
sudo apt update && sudo apt install -y jq inotify-tools pandoc curl
````

### 2\. Repository klonen & scharf schalten

Bash

```
git clone [https://github.com/o-valo/Das-docmost-Importier-.git](https://github.com/o-valo/Das-docmost-Importier-.git)
cd Das-docmost-Importier-
chmod +x docmost-importier.sh scan-nach-token.sh find-space-id-db.sh
```

### 3\. Konfiguration & ID-Ermittlung

Um den Importier zu konfigurieren, müssen die IDs deiner Docmost-Instanz  
ermittelt und in die Konfiguration eingetragen werden.

#### Schritt A: docmost.conf anlegen und vorbereiten

Erstelle im Verzeichnis die Datei `docmost.conf` und fülle sie mit  
deinen Basisdaten (URL, E-Mail, Passwort sowie die Pfade für  
Watch-Folder und Logfile). Nutze dafür diese Vorlage:

Ini,  
TOML

```
# ==============================================================================
# DOCMOST IMPORTIER - KONFIGURATIONSVORLAGE
# ==============================================================================

# 1. API-Zugangsdaten
# Die URL deiner Docmost-Instanz (inkl. Port, falls nötig)
DOCMOST_URL="[http://10.7.0.](http://10.7.0.)x:3000"

# Deine Login-Email
EMAIL="admin@deine-domain.de"

# Dein Passwort (UNBEDINGT in einfache Anführungszeichen setzen!)
PASSWORD='dein_passwort_hier'

# 2. Ziel-Parameter (UUIDs)
# (Werden in Schritt B und C ermittelt)
WORKSPACE_ID="00000000-0000-0000-0000-000000000000"
SPACE_ID="00000000-0000-0000-0000-000000000000"

# 3. Pfade & Logging
# Welcher Ordner soll überwacht werden? (Absoluter Pfad empfohlen)
WATCH_DIR="/home/nutzer/downloads/import-watch"

# Wo soll das Arbeitstier seine Protokolle ablegen?
LOG_FILE="/home/nutzer/progs/docmost-importier/docmost_watch.log"
```

#### Schritt B: WORKSPACE_ID generieren (Remote oder lokal)

Führe das erste Skript aus. Es loggt sich über die API ein (funktioniert  
auch remote von einem Client aus) und extrahiert die benötigte  
`WORKSPACE_ID` direkt aus dem generierten JWT-Token:

Bash

```
./scan-nach-token.sh
```

Ersetze die `WORKSPACE_ID` in deiner `docmost.conf` mit dem ausgegebenen  
Wert.

#### Schritt C: SPACE_ID aus der Datenbank auslesen (Nur auf dem Host!)

Da dieses Skript direkt auf die lokale Docmost-Datenbank zugreifen muss,  
muss die `./find-space-id-db.sh` **zwingend direkt auf dem Host**  
ausgeführt werden, auf dem die Instanz bzw. die Datenbank läuft:

Bash

```
./find-space-id-db.sh
```

Ersetze die `SPACE_ID` in deiner `docmost.conf` mit dem ausgegebenen  
Wert.

---

### 4\. Betrieb als Systemdienst (24/7 schuften lassen)

1.  Pfade in der Datei `docmost-importier.service` prüfen und  
    gegebenenfalls anpassen.
2.  Den Dienst im System registrieren, aktivieren und starten:

Bash

```
sudo cp docmost-importier.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable docmost-importier.service
sudo systemctl start docmost-importier.service
```

---

## Sicherheit & Schwachstellen melden 🔒

Da dieses Skript mit sensiblen Zugangsdaten (Passwörter/Tokens)  
hantiert, nimm Sicherheit bitte ernst:

- **Keine Passwörter im Code:** Nutze ausschließlich die  
    `docmost.conf` und stelle sicher, dass diese Datei niemals auf  
    GitHub committet wird (sie steht bereits in der `.gitignore`).
- **Schwachstellen melden:** Falls du eine Sicherheitslücke im Skript  
    findest, öffne bitte kein öffentliches Issue. Kontaktiere mich  
    stattdessen direkt per E-Mail oder über die Kontaktwege in meinem  
    GitHub-Profil, damit wir das Problem diskret und zügig beheben  
    können.

