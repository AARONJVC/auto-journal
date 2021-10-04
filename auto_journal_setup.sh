#!/bin/bash

config_dir="Configuration";

# Make the Configuration folder
if [[ ! -d "$config_dir" ]];
then
    mkdir "$config_dir";
fi

archive_script_name="set_archive_target.sh";

# Place the Archive configuration script in the Configuration folder
if [[ ! -f "${config_dir}\\${archive_script_name}" ]];
then
    
    printf "Enter an absolute filepath where you'd like journal entries to be stored:\n";

    read -r archive_target;
    
    archive_script_text="#!/bin/bash

archive_target=\"${archive_target}\";

echo \"\$archive_target\";";

    echo "$archive_script_text" >> "${config_dir}\\${archive_script_name}";
fi

logging_dir="Logs";
logfile_name="auto_journal_log.txt";

# Make the Logs folder
if [[ ! -d "$logging_dir" ]];
then
    mkdir "$logging_dir";
    touch "${logging_dir}\\${logfile_name}";
fi
