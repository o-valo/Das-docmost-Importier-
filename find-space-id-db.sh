#!/bin/bash
# ==============================================================================
# SCRIPT NAME:  find-space-id-db.sh
# VERSION:      1.0 (Direct Database Inspection - No JS required)
# ==============================================================================

# 1. Prüfen, ob Docker installiert ist
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker wurde auf diesem System nicht gefunden."
    exit 1
fi

echo "Suche nach laufenden Docmost-Datenbank-Containern..."
# Findet den Postgres-Container, der zu Docmost gehört
DB_CONTAINER=$(docker ps --format "{{.Names}}" | grep -E "docmost.*(db|postgres)" | head -n 1)

if [ -z "$DB_CONTAINER" ]; then
    # Fallback: Suche nach irgendeinem Postgres-Container
    DB_CONTAINER=$(docker ps --format "{{.Names}}" | grep -E "postgres|db" | head -n 1)
fi

if [ -z "$DB_CONTAINER" ]; then
    echo "FEHLER: Kein passender Datenbank-Container gefunden."
    echo "Hier sind deine laufenden Container. Bitte passe den Namen im Skript an:"
    docker ps --format "{{.Names}}"
    exit 1
fi

echo "Nutze Datenbank-Container: $DB_CONTAINER"
echo "------------------------------------------------------------------------"
echo "Lese Spaces und IDs direkt aus der PostgreSQL-Datenbank aus..."
echo "------------------------------------------------------------------------"

# Führt den Query direkt im Container aus. Docmost nutzt standardmäßig den User 'docmost' oder 'postgres'
# Wir testen beide gängigen Benutzernamen.
docker exec -i "$DB_CONTAINER" psql -U docmost -d docmost -c "SELECT id, name, slug FROM spaces;" 2>/tmp/db_err.txt

if [ $? -ne 0 ]; then
    # Fallback mit User 'postgres'
    docker exec -i "$DB_CONTAINER" psql -U postgres -d docmost -c "SELECT id, name, slug FROM spaces;" 2>/tmp/db_err.txt
fi

if [ $? -ne 0 ]; then
    echo "Fehler beim direkten SQL-Abruf. Versuche Tabellen-Struktur zu listen..."
    cat /tmp/db_err.txt
    echo "------------------------------------------------------------------------"
    echo "Alternativer Versuch über Umgebungsvariablen des Containers:"
    # Holt sich die DB-Verbindungsdaten direkt aus den Container-Infos
    docker exec -i "$DB_CONTAINER" env | grep -E "POSTGRES|DB_"
fi

rm -f /tmp/db_err.txt
echo "------------------------------------------------------------------------"
#EOF


