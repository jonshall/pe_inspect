!#/bin/bash
# Author: Jon S Hall

# Usage: ./pe_inspect.sh <file>

# Clear screen and start script
clear
echo -e "
    *-------------------------------*
    :        pe_inspect v1.0        :
    :-------------------------------:
    :     By: Jon S Hall, 2022      :
    *-------------------------------*
"

# Ensure a filename was input
if [ -z "${1}" ]
then
    echo -e "Usage: ./pe_inspect.sh <file>\n"
    exit 1
fi

# Ensure target is a file
if [ ! -f "${1}" ]
then
    echo -e "[-] ${1} is not a file\n"
    exit 1
fi

# Variables
TARGET=${1}                                    # Path to valid target file
DIR="results_pe_inspect"                       # Directory to store results
TARGET_DIR=dir_${TARGET}                       # Directory to store target results
FILE_EXIF=${DIR}/${TARGET_DIR}/exif_${TARGET}  # File to store exiftool results
FILE_SCAN=${DIR}/${TARGET_DIR}/scan_${TARGET}  # File to store scan results
FILE_HASH=${DIR}/${TARGET_DIR}/hash_${TARGET}  # File to store hash results
FILE_PACK=${DIR}/${TARGET_DIR}/pack_${TARGET}  # File to store packer results
FILE_STR=${DIR}/${TARGET_DIR}/str_${TARGET}    # File to store str results
FILE_FULL=${DIR}/${TARGET_DIR}/full_${TARGET}  # File to store full results

# Create results dir, if needed
if [ -d "${DIR}" ]
then
    echo -e "[-] Results directory exists, skipping...\n"
else
    mkdir ${DIR}
    echo -e "[+] Creating results directory (/${DIR})\n"
fi

# Create target dir, if needed
if [ -d "${DIR}" ]
then
    echo -e "[-] Target directory exists, skipping...\n"
else
    cd ${DIR}
    mkdir ${TARGET_DIR}
    cd ..
    echo -e "[+] Creating target directory (/${DIR}/${TARGET_DIR})\n"
fi

# Clean dir if rerun
rm -f ${FILE_EXIF}
rm -f ${FILE_SCAN}
rm -f ${FILE_HASH}
rm -f ${FILE_PACK}
rm -f ${FILE_STR}
rm -f ${FILE_FULL}

# Run exiftool
echo "[+] Identify the file"
echo -e "------------------------[ EXIFTOOL ]-----------------------------\n" >> ${FILE_FULL}
exiftool ${TARGET} >> ${FILE_EXIF}
cat ${FILE_EXIF} >> ${FILE_FULL}

# Run pescan
echo "[+] Scanning file"
echo -e "\n-------------------------[ PESCAN ]------------------------------\n" >> ${FILE_FULL}
pescan ${TARGET} >> ${FILE_SCAN}
cat ${FILE_SCAN} >> ${FILE_FULL}

# Run pehash
echo "[+] Finding hashes"
echo -e "\n-------------------------[ PEHASH ]------------------------------\n" >> ${FILE_FULL}
pehash ${TARGET} >> ${FILE_HASH}
cat ${FILE_HASH} >> ${FILE_FULL}

# Run pepack
echo "[+] Checking for packers"
echo -e "\n-------------------------[ PEPACK ]------------------------------\n" >> ${FILE_FULL}
pepack ${TARGET} >> ${FILE_PACK}
cat ${FILE_PACK} >> ${FILE_FULL}

# Run pestr
echo "[+] Pulling strings"
echo -e "\n-------------------------[ PESTR ]-------------------------------\n" >> ${FILE_FULL}
pestr ${TARGET} >> ${FILE_STR}
cat ${FILE_STR} >> ${FILE_FULL}

# Add end for housekeeping
echo -e "\n--------------------------[ END ]--------------------------------\n" >> ${FILE_FULL}

# Show results, can omit if you wish.
echo -e "\ninspected files location: (${DIR}/${TARGET_DIR}/)\n"
