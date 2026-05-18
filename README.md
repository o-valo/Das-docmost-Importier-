# Das Docmost Importier 🏗️

Das Docmost Importier** ist ein robuster Systemdienst für Linux, der wie ein treues Arbeitstier stoisch im Hintergrund schuftet. Er überwacht ein definiertes Verzeichnis vollautomatisch auf neu eingehende Dokumente in den Formaten HTML, Markdown (.md) und reinen Text (.txt).  und schiebt sie automatisch in deinen Docmost-Space.

Sobald eine Datei im Watch-Folder landet, schnappt sich das Skript die Arbeit:

    HTML-Dateien (z. B. aus KI-Chats vom Gemini Chat Exporter) werden per Pandoc blitzschnell in sauberes GitHub-Flavored-Markdown verwandelt.

    Markdown-Dateien (.md) werden ohne Umwege direkt für den Upload vorbereitet.

    Textdateien (.txt) (wie Skripte oder rohe Logbucheinträge) werden automatisch in einen sicheren Markdown-Code-Block verpackt, damit keine einzige Einrückung oder Formatierung verloren geht.


    



## Highlights
- **Arbeitstier-Modus**: Läuft als `systemd`-Dienst und startet bei Fehlern
automatisch neu. - **Smarte Konvertierung**: Verwendet `pandoc`, um HTML in
GitHub-Flavored Markdown (GFM) zu übersetzen. - **Sicherer Login**: Beherrscht
den Umgang mit komplexen Passwörtern und extrahiert Session-Tokens direkt aus den
API-Headern. - **Ressourcenschonend**: Reagiert dank `inotify` sofort auf neue
Dateien, ohne die CPU zu belasten.

## Voraussetzungen Linux Debian/Ubuntu 
Folgende Werkzeuge müssen auf deinem Server installiert sein: ```bash sudo
apt update && sudo apt install jq inotify-tools pandoc curl -y

## Installation & Einrichtung

Repository klonen:

Bash

<CODE>
git clone https://github.com/o-valo/Das-docmost-Importier-.git
cd Das-docmost-Importier-
</CODE>


Skript scharf schalten:

Bash
<CODE>
chmod +x docmost-importier.sh
</CODE>


## Betrieb als Systemdienst

Um den Importierer 24/7 schuften zu lassen:

Pfade in der docmost-importier.service prüfen.
Dienst registrieren:


Bash
<CODE>
sudo cp docmost-importier.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable docmost-importier.service
sudo systemctl start docmost-importier.service
</CODE>



## System-Requirements 🛠️

Der **Docmost Importier** benötigt ein paar Werkzeuge, um seine Arbeit zu verrichten. 
Du kannst prüfen, ob sie installiert sind, oder sie direkt mit folgendem Befehl
nachinstallieren:

### Schnell-Installation (Ubuntu/Debian)
```bash
sudo apt update && sudo apt install -y jq inotify-tools pandoc curl











