#!/bin/bash

#!/bin/bash

TARGET_DIR="$HOME/nicotine/"

find "$TARGET_DIR" -type f \( -name "*.s3v" -o -name "*.wav" -o -name "*.2dx9" \) -print0 | while IFS= read -r -d '' filepath; do

    filename=$(basename -- "$filepath")
    extension="${filename##*.}"
    stem="${filename%.*}"

    work_file="$filepath"
    output_file="$TARGET_DIR/${stem}.flac"

    echo "Processing: ${filename}"

    case "$extension" in
        2dx9)
            vgmstream-cli -o "${TARGET_DIR}/${stem}.wav" "$filepath" > /dev/null
            work_file="${TARGET_DIR}/${stem}.wav"

            ffmpeg -nostdin -y -i "$work_file" -c:a flac "$output_file" -loglevel error

            ;;

        s3v|wav)
            ffmpeg -nostdin -y -i "$filepath" -c:a flac "$output_file" -loglevel error
            ;;
    esac

done

echo "El finito"

