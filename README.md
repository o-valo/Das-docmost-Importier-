# Docmost Importier 🏗️

Des **Docmost Importier** ist ein robuster Systemdienst für Linux, der wie ein
Arbeitstier im Hintergrund schuftet. Er überwacht ein Verzeichnis auf
HTML-Exporte (z. B. aus KI-Chats von Gemini), verwandelt sie per Pandoc in sauberes Markdown
und schiebt sie automatisch in deinen Docmost-Space.

## Highlights
- **Arbeitstier-Modus**: Läuft als `systemd`-Dienst und startet bei Fehlern
automatisch neu. - **Smarte Konvertierung**: Verwendet `pandoc`, um HTML in
GitHub-Flavored Markdown (GFM) zu übersetzen. - **Sicherer Login**: Beherrscht
den Umgang mit komplexen Passwörtern und extrahiert Session-Tokens direkt aus den
API-Headern. - **Ressourcenschonend**: Reagiert dank `inotify` sofort auf neue
Dateien, ohne die CPU zu belasten.

## Voraussetzungen Linux Debian/Ubuntu 
Folgende Werkzeuge müssen auf deinem Ubot/Server installiert sein: ```bash sudo
apt update && sudo apt install jq inotify-tools pandoc curl -y

## Installation & Einrichtung

Repository klonen:

Bash

<CODE>
git clone https://github.com/dein-nutzername/docmost-importier.git
cd docmost-importier
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








