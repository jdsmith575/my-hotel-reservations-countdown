#!/bin/bash
#set -x

# set up variables
END_DATE="2027-03-11"      # the day your trip begins YYYY-MM-DD
RESORT="grand_californian" # the name of the hotel and the folder where the images are stored
BORDER_COLOR="#FAC04B"     # pick a color that goes with your image
SCREEN_HEIGHT=2870         # the height of your screen in pixels
BORDER_WIDTH=485           # the width of a border that is added to the right and left so that the image fills the tv screen
INPUT_DIR="./img/input/"
OUTPUT_DIR="./img/output"
TEMP_DIR="./img/temp"
TODAY=$(date +%Y-%m-%d)

# Convert dates to Unix timestamps (seconds since epoch)
start_timestamp=$(date -d "$TODAY" +%s)
end_timestamp=$(date -d "$END_DATE" +%s)

# exit if start is after end
if [[ ${start_timestamp} > ${end_timestamp} ]]; then
  echo "The end date already passed. Exiting."
  exit 0
fi

# Calculate the difference in seconds
time_difference_seconds=$((end_timestamp - start_timestamp))

# Convert the difference in seconds to days
# There are 86400 seconds in a day (60 seconds * 60 minutes * 24 hours)
days_difference=$((time_difference_seconds / 86400))
days_padded=$(printf "%0*s" "3" "$days_difference")
echo "Number of days between $start_date and $END_DATE: 
$days_difference / $days_padded"

# split up the number of days into their digit places
hundreds="${days_padded:0:1}"
tens="${days_padded:1:1}"
ones="${days_padded:2:1}"

# change to the mickey head if less than 100 days
if [[ "${hundreds}" -eq 0 ]]; then
  hundreds="mickey"
fi

# check to see if all the source numbers exist
if [ ! -f "${INPUT_DIR}/${RESORT}/number-${hundreds}.png" ] || \
  [ ! -f "${INPUT_DIR}/${RESORT}/number-${tens}.png" ] || \
  [ ! -f "${INPUT_DIR}/${RESORT}/number-${ones}.png" ]; then
  echo "The source files don't exist. Exiting."
  exit 1
else
  echo "Found the source files. Continuing..."
  # remove the yesterdays file
  rm ${OUTPUT_DIR}/*.png
fi

## Start building the image
magick "${INPUT_DIR}/${RESORT}/middle-left.PNG" \
  "${INPUT_DIR}/${RESORT}/number-${hundreds}.png" \
  "${INPUT_DIR}/${RESORT}/middle-spacer.PNG" \
  "${INPUT_DIR}/${RESORT}/number-${tens}.png" \
  "${INPUT_DIR}/${RESORT}/middle-spacer.PNG" \
  "${INPUT_DIR}/${RESORT}/number-${ones}.png" \
  "${INPUT_DIR}/${RESORT}/middle-right.PNG" \
  +append "${TEMP_DIR}/middle_combined.png"

if [[ $? -ne 0 ]]; then
  echo "Something went wrong! Exiting."
  exit 1
fi

magick "${INPUT_DIR}/${RESORT}/top.PNG" "${TEMP_DIR}/middle_combined.png" \
  "${INPUT_DIR}/${RESORT}/bottom.PNG" -append "${TEMP_DIR}/all_small.png"

if [[ $? -ne 0 ]]; then
  echo "Something went wrong! Exiting."
  exit 1
fi

# resize the image to the height of the screen
magick "${TEMP_DIR}/all_small.png" -resize ${SCREEN_HEIGHT}x "${TEMP_DIR}/all_big.png"

if [[ $? -ne 0 ]]; then
  echo "Something went wrong! Exiting."
  exit 1
fi

# add the colored sidebar to each side of the composed image 
# so it is the full width of the screen
magick "${TEMP_DIR}/all_big.png" -bordercolor "${BORDER_COLOR}" \
  -border ${BORDER_WIDTH}x \
  "${OUTPUT_DIR}/${days_difference}.png"

if [[ $? -ne 0 ]]; then
  echo "Something went wrong! Exiting."
  exit 1
fi

# sharpen the image
magick "${OUTPUT_DIR}/${days_difference}.png" -sharpen 0 \
  "${OUTPUT_DIR}/${days_difference}.png"

if [[ $? -ne 0 ]]; then
  echo "Something went wrong! Exiting."
  exit 1
fi

# clean up the temp directory
rm ${TEMP_DIR}/*.png
