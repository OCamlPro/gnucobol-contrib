# Date started: August 2018
# Modified: 2018-08-14/18:23-0400 btiffin
#
# commands.sed, markup command substitution
# Dedicated to the public domain
#
# Tectonics:
#    Needs local copy of gcv.c compiled and ready in current working dir
#    sed -rf commands.sed [inputfiles]

# Replace #indent prog params# with the captured output indented 4 spaces
s%#indent ([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?(.*)#%\1 \2 \3 \4 \5 | sed 's/^/    /'%e

# Replace #command prog params# with the captured output
s%#command ([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?(.*)#%\1 \2 \3 \4 \5%e

# Replace include file constants, enums, and C expressions
s#(.*)\[\[symbol[ ]?(.*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3)" "\4"#e

# Replace include file constants, enums, and C expressions wrapped in single quotes
s#(.*)\[\[eval[ ]?'(.*)'[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv "\2" \3)" "\4"#e

# Output suitable for replacement in COBOL source
s#(.*)\[\[constant[ ]?(.*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3 -C)" "\4"#e
s#(.*)\[\[value[ ]?(.*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3 -V)" "\4"#e

# Non gcv shell replacement
s#(.*)\[\[shell[ ]?([^ ]*)[ ]?'(.*)'[ ]?\]\](.*)#printf "%s%s%s" "\1" "$("\2" "\3")" "\4"#e
