TARGET="https://docs.google.com/spreadsheets/d/1cb6OHrVVZmSkrjHKnVnQZ9HuUJZautNlv29KjK_sOns/export?format=csv&id=1cb6OHrVVZmSkrjHKnVnQZ9HuUJZautNlv29KjK_sOns&gid=0"
DEST_FILE=./Assets/CAAppTranslation.csv
curl -L --silent ${TARGET} > ${DEST_FILE} # -L follows 30X redirects 