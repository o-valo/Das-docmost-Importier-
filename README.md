
### Das Docmost Importier 🏗️

Das Docmost Importier ist ein robuster Systemdienst für Linux, der
wie ein treues Arbeitstier stoisch im Hintergrund schuftet. Er überwacht
ein definiertes Verzeichnis vollautomatisch auf neu eingehende Dokumente
in den Formaten HTML, Markdown (.md) und reinen Text (.txt)
und schiebt sie automatisch in deinen Docmost-Space.

Sobald eine Datei im Watch-Folder landet, schnappt sich das Skript die
Arbeit:


HTML-Dateien (z. B. aus KI-Chats vom Gemini Chat Exporter)
werden per Pandoc blitzschnell in sauberes GitHub-Flavored-Markdown
verwandelt.

Markdown-Dateien (.md) werden ohne Umwege direkt für den Upload
vorbereitet.

Textdateien (.txt) (wie Skripte oder rohe Logbucheinträge)
werden automatisch in einen sicheren Markdown-Code-Block verpackt,
damit keine einzige Einrückung oder Formatierung verloren geht.



## Highlights 🚀
Arbeitstier-Modus: Läuft als systemd-Dienst und startet bei
Fehlern automatisch neu.

Smarte Konvertierung: Verwendet Pandoc, um HTML in
GitHub-Flavored Markdown (GFM) zu übersetzen.


Sicherer Login: Beherrscht den Umgang mit komplexen Passwörtern
und extrahiert Session-Tokens direkt aus den API-Headern.

Ressourcenschonend: Reagiert dank inotify sofort auf neue
Dateien, ohne die CPU mit Polling zu belasten.

## Installation & Einrichtung

1. Voraussetzungen installieren (Ubuntu/Debian)

Bevor es losgeht, müssen die benötigten Werkzeuge auf deinem Server
vorhanden sein. Nutze dafür diesen schnellen One-Liner:

Bash
<CODE>

sudo apt update && sudo apt install -y jq inotify-tools pandoc curl
</CODE>

2. Repository klonen & scharf schalten

Bash

<CODE>
git clone https://github.com/o-valo/Das-docmost-Importier-.git
cd Das-docmost-Importier-
chmod +x docmost-importier.sh
</CODE>

3. Betrieb als Systemdienst (24/7 schuften lassen)

Pfade in der Datei docmost-importier.service prüfen und
gegebenenfalls anpassen.

Den Dienst im System registrieren und starten:

Bash
<CODE>
sudo cp docmost-importier.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable docmost-importier.service
sudo systemctl start docmost-importier.service
</CODE>





## Sicherheit & Schwachstellen melden 🔒

Da dieses Skript mit sensiblen Zugangsdaten (Passwörter/Tokens) hantiert, nimm Sicherheit bitte ernst:
* **Keine Passwörter im Code:** Nutze ausschließlich die `docmost.conf` und stelle sicher, dass diese Datei niemals auf GitHub committet wird (sie steht bereits in der `.gitignore`).
* **Schwachstellen melden:** Falls du eine Sicherheitslücke im Skript findest, öffne bitte **kein** öffentliches Issue. Kontaktiere mich stattdessen direkt per E-Mail oder über die Kontaktwege in meinem GitHub-Profil, damit wir das Problem diskret und zügig beheben können.

