man bash | tr -cs '[:alnum:]' '[\n*]' | awk 'length($0) >= 4' | sort | uniq -c | sort -nr | head -3
