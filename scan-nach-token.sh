#!/bin/bash
# ==============================================================================
# SCRIPT NAME:  scan-nach-token.sh
# VERSION:      1.0 (GitHub Edition - Secure Token Fetcher)
# ==============================================================================

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$SCRIPT_DIR/docmost.conf"

# Konfiguration laden
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "ERROR: Konfiguration nicht gefunden! Bitte docmost.conf im selben Ordner erstellen."
    exit 1
fi

LOGIN_URL="${DOCMOST_URL}/api/auth/login"

echo "Frage frischen Token von $LOGIN_URL ab..."

# JSON-Payload für den Login bauen
PAYLOAD=$(jq -n --arg em "$EMAIL" --arg pw "$PASSWORD" '{email: $em, password: $pw}')
TEMP_RES="/tmp/importier_token_check.txt"

# Login ausführen und Header abfangen
curl -s -i -X POST "$LOGIN_URL" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" > "$TEMP_RES"

# Token aus dem Cookie extrahieren
AUTH_TOKEN=$(grep -i "set-cookie:" "$TEMP_RES" | tr -d '\r' | sed -n 's/.*authToken=\([^;]*\).*/\1/p' | head -n 1)

# Ergebnis ausgeben
if [ -n "$AUTH_TOKEN" ]; then
    echo "------------------------------------------------------------------------"
    echo "ERFOLG! Dein Auth-Token lautet:"
    echo "$AUTH_TOKEN"
    echo "------------------------------------------------------------------------"
else
    echo "------------------------------------------------------------------------"
    echo "FEHLER: Token konnte nicht extrahiert werden."
    echo "Bitte überprüfe die Zugangsdaten in der docmost.conf."
    echo "Server-Antwort:"
    cat "$TEMP_RES"
    echo "------------------------------------------------------------------------"
fi

# Aufräumen
rm -f "$TEMP_RES"

#EOF
