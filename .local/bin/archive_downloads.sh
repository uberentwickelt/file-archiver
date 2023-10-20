#!/bin/bash

# Time in days
timeframe="+15"
timeframe_unit="days"
cleanup_location="${HOME}/Downloads"
archive_location="${cleanup_location}/_archive"
timestamp=$(date +'%Y-%m-%d_%Hh%Mm_%Z')
log_location="${HOME}/.local/log"
log="${log_location}/archive_downloads.${timestamp}.log"

# Make the log directory if it does not exist
[[ ! -d ${log_location} ]] && mkdir -p ${log_location}

# Create log file with basic launch info
echo "--------------------------------------"  > ${log}
echo "Cleanup initiated: ${timestamp}"        >> ${log}
echo "Cleanup  location: ${cleanup_location}" >> ${log}
echo "Archive  location: ${archive_location}" >> ${log}
echo "--------------------------------------" >> ${log}

# Make ${archive_location} if it does not exist
if [ ! -d ${archive_location} ]; then
  echo "Creating archive location: ${archive_location}" >> ${log}
  mkdir -p ${archive_location}
fi

echo "List of directories older than ${timeframe} ${timeframe_unit}:" >> ${log}

# List all top level directories older than ${timeframe} within ${cleanup_location}
find ${cleanup_location} -type d -maxdepth 1 -mtime ${timeframe} ! -name '_archive' ! -name 'Downloads' -print >> ${log}

echo "--------------------------------------" >> ${log}

echo "List of files older than ${timeframe} ${timeframe_unit}:" >> ${log}

# List all top level files older than ${timeframe} within ${cleanup_location}
find ${cleanup_location} -type f -maxdepth 1 -mtime ${timeframe} ! -name '.localized' ! -name '.DS_Store' -print >> ${log}

echo "--------------------------------------" >> ${log}

echo "Archiving old directories..." >> ${log}

# Move all top level directories older than ${timeframe} within ${cleanup_location} to ${archive_location}
find ${cleanup_location} -type d -maxdepth 1 -mtime ${timeframe} ! -name '_archive' ! -name 'Downloads' -exec mv {} ${archive_location}/ \; >> ${log} 2>&1

if [ $? -ne 0 ]; then
  echo "An error was encountered while archiving old directories" >> ${log}
else
  echo "Successfully archived old directories" >> ${log}
fi

echo "Archiving old files..." >> ${log}

# Move all top level files older than ${timeframe} within ${cleanup_location} to ${archive_location}
find ${cleanup_location} -type f -maxdepth 1 -mtime ${timeframe} ! -name '.localized' ! -name '.DS_Store' -exec mv {} ${archive_location}/ \; >> ${log} 2>&1

if [ $? -ne 0 ]; then
  echo "An error was encountered while archiving old files" >> ${log}
else
  echo "Successfully archived old files" >> ${log}
fi

exit 0
