#!/bin/bash
# process_customer.cgi

# Set content type
echo "Content-type: text/html"
echo ""

# Read POST data
read -n $CONTENT_LENGTH POST_DATA

# Function to get field value
get_field() {
    echo "$POST_DATA" | grep -o "$1=[^&]*" | cut -d= -f2 | sed 's/+/ /g' | sed 's/%20/ /g'
}

# Extract fields
ACCT_NO=$(get_field "acct_no")
FNAME=$(get_field "fname")
LNAME=$(get_field "lname")
HOUSE_NO=$(get_field "house_no")
STREET=$(get_field "street")
CITY=$(get_field "city")
STATE=$(get_field "state")
ZIP=$(get_field "zip")
INCOME=$(get_field "income")
ACTION=$(get_field "action")

# Validate account number
if [[ ! $ACCT_NO =~ ^[0-9]{9}$ ]]; then
    MESSAGE="Invalid account number format"
    HTML_TEMPLATE=$(cat /var/www/mkat/zz/cust02.index.html)
    echo "$HTML_TEMPLATE" | sed "s/\$ACCT_NO/$ACCT_NO/g" \
                          | sed "s/\$FNAME/$FNAME/g" \
                          | sed "s/\$LNAME/$LNAME/g" \
                          | sed "s/\$HOUSE_NO/$HOUSE_NO/g" \
                          | sed "s/\$STREET/$STREET/g" \
                          | sed "s/\$CITY/$CITY/g" \
                          | sed "s/\$STATE/$STATE/g" \
                          | sed "s/\$ZIP/$ZIP/g" \
                          | sed "s/\$INCOME/$INCOME/g" \
                          | sed "s/\$MESSAGE/$MESSAGE/g"
    exit 0
fi
 

# Call COBOL program
COBOL_OUTPUT=$(/var/www/cust01 "$ACCT_NO" "$FNAME" "$LNAME" "$HOUSE_NO" "$STREET" "$CITY" "$STATE" "$ZIP" "$INCOME" "$ACTION")

# Parse COBOL output
IFS='|' read -r NEW_ACCT_NO NEW_FNAME NEW_LNAME NEW_HOUSE_NO NEW_STREET NEW_CITY NEW_STATE NEW_ZIP NEW_INCOME MESSAGE <<< "$COBOL_OUTPUT"

# Display updated page
HTML_TEMPLATE=$(cat /var/www/mkat/zz/cust02.index.html)
echo "$HTML_TEMPLATE" | sed "s/\$ACCT_NO/$NEW_ACCT_NO/g" \
                      | sed "s/\$FNAME/$NEW_FNAME/g" \
                      | sed "s/\$LNAME/$NEW_LNAME/g" \
                      | sed "s/\$HOUSE_NO/$NEW_HOUSE_NO/g" \
                      | sed "s/\$STREET/$NEW_STREET/g" \
                      | sed "s/\$CITY/$NEW_CITY/g" \
                      | sed "s/\$STATE/$NEW_STATE/g" \
                      | sed "s/\$ZIP/$NEW_ZIP/g" \
                      | sed "s/\$INCOME/$NEW_INCOME/g" \
                      | sed "s/\$MESSAGE/$MESSAGE/g"

