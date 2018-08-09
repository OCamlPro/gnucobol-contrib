# Author: Brian Tiffin
# Dedicated to the public domain
#
# Date started: August 2018
# Modified: 2018-08-09/17:35-0400 btiffin
#
# commands.sed, markup command substitution
#
# Tectonics:
#    sed -rf commands.sed [inputfiles]

# Replace #indent prog params# with the captured output indented 4 spaces
s%#indent ([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?(.*)#%\1 \2 \3 \4 \5 | sed 's/^/    /'%e

# Replace #command prog params# with the captured output
s%#command ([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?(.*)#%\1 \2 \3 \4 \5%e

# Replace agar constants and C expressions
s#(.*)\[\[symbol[ ]?(.*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3)" "\4"#e
s#(.*)\[\[eval[ ]?'(.*)'[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv "\2" \3)" "\4"#e

# Output suitable for replacement in COBOL source
s#(.*)\[\[constant[ ]?(.*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3 -c)" "\4"#e
s#(.*)\[\[value[ ]?(.*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3 -v)" "\4"#e

# Non gcv shell replacement
s#(.*)\[\[shell[ ]?([^ ]*)[ ]?'(.*)'[ ]?\]\](.*)#printf "%s%s%s" "\1" "$("\2" "\3")" "\4"#e
