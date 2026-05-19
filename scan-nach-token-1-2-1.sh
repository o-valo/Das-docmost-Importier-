#!/bin/bash
# ==============================================================================
# SCRIPT NAME:  scan-nach-token.sh
# VERSION:      1.2.1 (GitHub Edition - Only Token & Workspace ID - Fixed Syntax)
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
    echo "ERFOLG! Verbindung steht."
    echo "------------------------------------------------------------------------"
    echo "Dein Auth-Token lautet:"
    echo "$AUTH_TOKEN"
    echo ""

    # --- TRICK 1: WORKSPACE_ID direkt aus dem JWT extrahieren ---
    # Ein JWT besteht aus 3 Teilen, getrennt durch Punkte. Der 2. Teil ist der Payload (Base64).
    JWT_PAYLOAD=$(echo "$AUTH_TOKEN" | cut -d'.' -f2)
    
    # Base64-Padding korrigieren, falls nötig, und decodieren
    MOD=$(( ${#JWT_PAYLOAD} % 4 ))
    if [ $MOD -eq 2 ]; then JWT_PAYLOAD="${JWT_PAYLOAD}=="; elif [ $MOD -eq 3 ]; then JWT_PAYLOAD="${JWT_PAYLOAD}="; fi
    
    WORKSPACE_ID=$(echo "$JWT_PAYLOAD" | base64 -d 2>/dev/null | jq -r '.workspaceId')
    
    if [ -n "$WORKSPACE_ID" ] && [ "$WORKSPACE_ID" != "null" ]; then
        echo "Gefundene WORKSPACE_ID für deine docmost.conf:"
        echo "WORKSPACE_ID=\"$WORKSPACE_ID\""
    else
        echo "WORKSPACE_ID konnte nicht aus dem Token decodiert werden."
    fi
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
