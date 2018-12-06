# Replace #indent prog params# with the captured output indented 4 spaces
s%#indent ([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?(.*)#%\1 \2 \3 \4 \5 | sed 's/^/    /'%e

# Replace #command prog params# with the captured output
s%#command ([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?(.*)#%\1 \2 \3 \4 \5%e

# Replace agar constants
s#(.*)\[\[agar[ ]?([^ ]*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv "\2" \3)" "\4"#e

# and C expressions, the expression must be single quoted.
s#(.*)\[\[eval[ ]?'(.*)'[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv "\2" \3)" "\4"#e 
                        
# Output suitable for replacement in COBOL source
s#(.*)\[\[constant[ ]?([^ ]*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3 -C)" "\4"#e 
s#(.*)\[\[value[ ]?([^ ]*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3 -V)" "\4"#e 

# No Get C Value, just command and optionally quoted args
s#(.*)\[\[shell[ ]?([^ ]*)[ ]?[']?(.*)[']?[ ]?\]\](.*)#printf "%s%s%s" "\1" "$("\2" \3)" "\4"#e 
