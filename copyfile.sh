#!/bin/bash
# $1 sould be "fetch" or "install"
# $2 iput file sould be something like "usr/local/bin/swayphone_*"

METHODE="$1"
FILES="$2"

#echo $OUTPUT_DIR

[[ -z $COUNT ]] && export COUNT=1 || export COUNT=$(($COUNT+1))
echo $COUNT

RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'
GREEN_B='\033[1;42m'
NC='\033[0m'

# Create diff file if not exist
DIFF_DIR="diff/$(date +%y%m%d)"
mkdir -p  $DIFF_DIR




new_systemfile() {
   echo -e "${GREEN_B}New file:${NC} ${YELLOW}${ISSUDO}cp${CYAN} $INPUT_FILE $OUTPUT_DIR${NC}" | ${echo_log}
   ${ISSUDO}mkdir -p $OUTPUT_DIR
   ${ISSUDO}cp $INPUT_FILE $OUTPUT_DIR
}

diff_systemfile() {
   echo -e "${RED}Overwrite existing ${ISSUDO}: ${GREEN}Diff file: ${YELLOW}diff -u${NC} $INPUT_FILE $OUTPUT_FILE >> $DIFF_DIR/$FILE_NAME.diff" | ${echo_log}
   diff -u $INPUT_FILE $OUTPUT_FILE >> $DIFF_DIR/$FILE_NAME.diff
   ${ISSUDO}cp $INPUT_FILE $OUTPUT_FILE
}

copy_file() {
   INPUT_FILE=$FILE
   FILE_NAME=$(basename $FILE)
   FILE_DIR=$(dirname $INPUT_FILE)
   ISSUDO=""

   if echo "$METHODE" | grep -q "install"; then
      DIFF_FILE="$DIFF_DIR/install-diff.log"
      OUTPUT_DIR=$(echo $FILE_DIR | 
         sed "s/^home\/config/home\/\.config/" | 
         sed "s/^home\/local/home\/\.local/" | 
         sed "s/^/\//" | 
         sed "s/^\/home/\/home\/$(whoami)/")
      OUTPUT_DIR_U=$(stat -c '%U' $OUTPUT_DIR)
      if echo $OUTPUT_DIR_U | grep -q "root"; then
         ISSUDO="sudo "
      fi
   elif echo "$METHODE" | grep -q "fetch"; then
      DIFF_FILE="$DIFF_DIR/fetch-diff.log"
      OUTPUT_DIR=$(echo $FILE_DIR | 
         sed "s/^\///" |
         sed "s/^home\/$(whoami)/home/" |
         sed "s/^home\/\./home\//")
   fi


   touch $DIFF_FILE
   echo_log="tee -a ${DIFF_FILE}"

   OUTPUT_FILE="$OUTPUT_DIR/$FILE_NAME"


   echo -e "${YELLOW}$FILE_NAME:${NC}"
   if [ ! -f "$OUTPUT_FILE" ]; then
      new_systemfile
   else
      DIFF_FILES=$(diff -u $INPUT_FILE $OUTPUT_FILE)
      [ ! -z "$DIFF_FILES" ] && 
         diff_systemfile ||
         echo -e "${GREEN}No changes${NC}"
   fi

}


if echo $METHODE | grep -q "fetch"; then
   for FILE in ${FILES[@]}; do
      NEWFILES+=" $(echo $FILE | 
         sed "s/^home\/config/home\/\.config/g" |
         sed "s/^home\/local/home\/\.local/g" |
         sed "s/^/\//" |
         sed "s/^\/home\//$(echo $HOME | sed 's/\//\\\//g')\//g"
      )" 
   done
   FILES="$NEWFILES"
fi

### Main
[ -z "$FILES" ] &&
   echo -e "${RED}No input file${NC}" ||
   for FILE in ${FILES[@]}; do
      IGNORE=0
      echo $FILE | grep -qi ".back$" && IGNORE=1 
      echo $FILE | grep -qi ".backup$" && IGNORE=1
      echo $FILE | grep -qi ".new$" && IGNORE=1
      echo $FILE | grep -qi ".old$" && IGNORE=1

      [[ $IGNORE == 1 ]] &&
         echo -e "${RED}Ignoring file: ${YELLOW}$FILE${NC}"
      [[ $IGNORE == 0 ]] &&
         copy_file
   done
 
echo ""
echo ""
