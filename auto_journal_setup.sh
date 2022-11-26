#!/bin/bash

config_dir="configuration";

# Make the configuration folder
if [[ ! -d "$config_dir" ]];
then
    mkdir "$config_dir";
fi

archive_script_name="set_archive_target.sh";

# Place the Archive configuration script in the Configuration folder
if [[ ! -f "${config_dir}\\${archive_script_name}" ]];
then
    
    valid=0;

    while [ "$valid" == 0 ];
    do
        printf "Enter an absolute filepath where you'd like journal entries to be stored:\n";
        read -r archive_target;

        if [[ -d "$archive_target" ]];
        then
            valid=1;
        else
            clear;
            printf "Invalid. ";
        fi
    done
    
    archive_script_text="#!/bin/bash

archive_target=\"${archive_target}\";

echo \"\$archive_target\";";

    echo "$archive_script_text" >> "${config_dir}\\${archive_script_name}";
fi

logging_dir="logs";
logfile_name="auto_journal_log.txt";

# Make the logs folder
if [[ ! -d "$logging_dir" ]];
then
    mkdir "$logging_dir";
    touch "${logging_dir}\\${logfile_name}";
fi





# Finish by deleting self
# rm $0;