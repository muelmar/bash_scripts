#!/bin/bash

# Konfiguration
TOC_FILE="audio.toc"
DRIVE="/dev/sr0"
ALBUM_TITLE="${1-Mein Album}"
ALBUM_ARTIST="${2-Verschiedene Kuenstler}"

echo "================================================="
echo "  Audio-CD TOC-Generator & Brenn-Skript"
echo "================================================="

# 1. TOC-Datei Header schreiben
cat << EOF > "$TOC_FILE"
CD_DA

CD_TEXT {
  LANGUAGE_MAP {
    0 : EN
  }
  LANGUAGE 0 {
    TITLE "$ALBUM_TITLE"
    PERFORMER "$ALBUM_ARTIST"
  }
}
EOF

# Count für Tracks
track_num=1

# 2. Schleife durch alle WAV-Dateien im aktuellen Verzeichnis (sortiert)
# Nutzt 'nullglob', falls keine WAVs existieren
shopt -s nullglob
wav_files=(*.wav)

if [ ${#wav_files[@]} -eq 0 ]; then
    echo "❌ Keine .wav-Dateien im aktuellen Verzeichnis gefunden!"
    exit 1
fi

for file in "${wav_files[@]}"; do
    # Dateiendung entfernen
    filename=$(basename "$file" .wav)
    
    # Versuche Künstler und Titel sauber zu trennen (falls ein " - " im Namen ist)
    if [[ "$filename" == *" - "* ]]; then
        # Entfernt führende Nummern wie "01_" oder "01 " falls vorhanden
        clean_name=$(echo "$filename" | sed -E 's/^[0-9]+[_\. -]+//')
        artist=$(echo "$clean_name" | cut -d'-' -f1 | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//')
        title=$(echo "$clean_name" | cut -d'-' -f2- | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//')
    else
        # Fallback, falls kein Bindestrich existiert
        artist="$ALBUM_ARTIST"
        title="$filename"
    fi

    echo "➜ Track $track_num hinzugefügt: $artist - $title"

    # Track-Eintrag in die TOC-Datei schreiben
    cat << EOF >> "$TOC_FILE"

TRACK AUDIO
CD_TEXT {
  LANGUAGE 0 {
    TITLE "$title"
    PERFORMER "$artist"
  }
}
AUDIOFILE "$file" 0
EOF

    track_num=$((track_num + 1))
done

echo "-------------------------------------------------"
echo "✅ '$TOC_FILE' wurde erfolgreich erstellt!"
echo "-------------------------------------------------"

# 3. Abfrage ob direkt gebrannt werden soll
read -p "Möchtest du die CD jetzt brennen? (j/n): " answer
echo "sudo cdrdao write --speed 4 --device /dev/sr0 audio.toc"
if [[ "$answer" =~ ^[Jj]$ ]]; then
    echo "💿 Starte Brennvorgang auf $DRIVE..."
    # Führt den cdrskin-Befehl aus und finalisiert (-dao)
    cdrskin dev="$DRIVE" -v -dao -audio "$TOC_FILE"
else
    echo "Information: Du kannst die Datei später manuell mit folgendem Befehl brennen:"
    echo "cdrskin dev=$DRIVE -v -dao -audio $TOC_FILE"
fi

