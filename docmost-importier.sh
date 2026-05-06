#!/bin/bash
# ==============================================================================
# SCRIPT NAME:  docmost-importier.sh
# VERSION:      1.1 (GitHub Edition - The Importier)
# ==============================================================================

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$SCRIPT_DIR/docmost.conf"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "ERROR: Konfiguration nicht gefunden! Bitte docmost.conf erstellen."
    exit 1
fi

VERSION="4.4"
LOGIN_URL="${DOCMOST_URL}/api/auth/login"
IMPORT_URL="${DOCMOST_URL}/api/pages/import"

log_message() {
    local MESSAGE="[$(date +'%d.%m.%y %H:%M:%S')] [v$VERSION] $1"
    echo "$MESSAGE" >> "$LOG_FILE"
    echo "$MESSAGE"
}

get_fresh_token() {
    local PAYLOAD=$(jq -n --arg em "$EMAIL" --arg pw "$PASSWORD" '{email: $em, password: $pw}')
    local TEMP_RES="/tmp/importier_login.txt"
    
    curl -s -i -X POST "$LOGIN_URL" \
        -H "Content-Type: application/json" \
        -d "$PAYLOAD" > "$TEMP_RES"

    local TOKEN=$(grep -i "set-cookie:" "$TEMP_RES" | tr -d '\r' | sed -n 's/.*authToken=\([^;]*\).*/\1/p' | head -n 1)
    echo "$TOKEN"
}

AUTH_TOKEN=$(get_fresh_token)
[ -z "$AUTH_TOKEN" ] && { log_message "Login-Fehler: Token konnte nicht gefasst werden."; exit 1; }

log_message ">>> Docmost Importier v$VERSION ist bereit und wartet auf Arbeit..."

inotifywait -m -e close_write --format '%f' "$WATCH_DIR" | while read FILE
do
    [[ "$FILE" != *.html ]] && continue
    
    FULL_PATH="$WATCH_DIR/$FILE"
    FILENAME="${FILE%.*}"
    MD_PATH="$WATCH_DIR/$FILENAME.md"

    log_message "Importierer schnappt sich: $FILE"

    if pandoc "$FULL_PATH" -f html -t gfm --strip-comments -o "$MD_PATH"; then
        RESPONSE=$(curl -s -L -w "%{http_code}" -o /tmp/importier_res.txt \
            -X POST \
            -H "Cookie: authToken=$AUTH_TOKEN" \
            -H "X-Workspace-ID: $WORKSPACE_ID" \
            -F "spaceId=$SPACE_ID" \
            -F "format=markdown" \
            -F "file=@$MD_PATH" \
            "$IMPORT_URL")

        if [[ "$RESPONSE" == "200" || "$RESPONSE" == "201" ]]; then
            log_message "ERFOLG: $FILENAME sicher nach Docmost geschafft."
            rm "$FULL_PATH" "$MD_PATH"
        else
            log_message "FEHLER $RESPONSE: $(cat /tmp/importier_res.txt)"
            [[ "$RESPONSE" == "401" ]] && AUTH_TOKEN=$(get_fresh_token)
        fi
    fi
done

#EOF
