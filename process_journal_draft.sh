#!/bin/bash

script_source=`pwd`;
journal_draft_target="${script_source}\static\journal_draft.txt";
log_target=`./configuration/set_logging_target.sh`;
archive_target=`./configuration/set_archive_target.sh`;

date_generated=`date +%T-%A-%d-%b-%m-%Y`;

# Storing the data in an array
declare -a date_data_array=();
IFS="-";
read -ra date_data_array <<< "${date_generated}";
unset IFS;

# Extracting data for use
gen_time="${date_data_array[0]}";
gen_day="${date_data_array[2]}";
gen_month="${date_data_array[3]}";
gen_year="${date_data_array[5]}";

generated_desc="$gen_time $gen_day $gen_month $gen_year";

# Get the journal content
declare -a journal_draft_array=();
mapfile -t journal_draft_array < "$journal_draft_target";

raw_date="INVALID";
journal_date="INVALID";
file_name="INVALID";

date_cmd_option="";

# Determine target date source mode
if [ "$#" -gt "0" ];
then
	date_arg="$@";
	mode="Command Args";
else
	# Detect a date explicitly placed in the drafting area
	if [[ ${journal_draft_array[0]} =~ ^[0-9]{1,2}[[:space:]][a-zA-Z]{3,}[[:space:]][0-9]{4}.*$ ]];
	then
		date_arg="${journal_draft_array[0]}";
		journal_draft_array=("${journal_draft_array[@]/${journal_draft_array[0]}}");
		mode="Draft Args";
	else
		mode="Current";
	fi
fi

date_cmd_str="raw_date=\$(date -d \"${date_arg}\" +%T-%A-%d-%b-%m-%Y 2> /dev/null)";
command eval $date_cmd_str;

if [[ $? -ne "0" ]];
then
	printf -- "Journal Draft Processor\n\tFailed on ${generated_desc}\n\t${mode} mode received a malformed date\n\t\tThe argument was: ${date_arg}\n\n" >> "$log_target";
	printf -- "Failed due to malformed date argument: ${date_arg}\nTry again with a proper date.\n";
	exit 1
fi

# Storing the data in an array
date_data_array=();
IFS="-";
read -ra date_data_array <<< "${raw_date}";
unset IFS;

# Extracting data for use
weekday="${date_data_array[1]}";
day="${date_data_array[2]}";
month="${date_data_array[3]}";
month_num="${date_data_array[4]}";
year="${date_data_array[5]}";

journal_date_desc="$(echo $weekday | tr '[:lower:]' '[:upper:]') $day $(echo $month | tr '[:lower:]' '[:upper:]') $year";
journal_file_name="${day}_$(echo $month | tr '[:upper:]' '[:lower:]')_${year}.txt";
month_folder_name="${month_num}_${month}_${year}";
year_folder_name="$year";

printf -- "Journal Draft Processor\n\tRunning at ${generated_desc}\n\t${mode} mode with target: ${day} ${month} ${year}\n" >> "$log_target";

# Remove blank lines from the draft
for i in "${!journal_draft_array[@]}";
do
	current_line="${journal_draft_array[$i]}";
	if [[ ! $current_line =~ ^[[:space:]]*$ ]];
	then
		cleaned_draft_array+=( "$(printf "$current_line")" );
	fi
done

journal_draft_array=("${cleaned_draft_array[@]}");

if [ "${#journal_draft_array[@]}" -gt "0" ];
then
	printf -- "\tDraft read - " >> "$log_target";

	# Begin the directory traversal
	cd "$archive_target";

	if [ ! -e "$year_folder_name" ];
	then
		mkdir "$year_folder_name";
		printf -- "Made ${year_folder_name} - " >> "$log_target";
	fi

	cd "$year_folder_name";

	if [ ! -e "$month_folder_name" ];
	then
		mkdir "$month_folder_name";
		printf -- "Made ${month_folder_name} - " >> "$log_target";
	fi

	cd "$month_folder_name";

	if [ ! -e "$journal_file_name" ];
	then
		printf -- "Generated ${journal_file_name}\n" >> "$log_target";
		
		printf -- "${journal_date_desc}\n\n" >> "$journal_file_name";
		
		for i in "${!journal_draft_array[@]}";
		do			
			printf -- "${journal_draft_array[$i]}\n" | sed -rn 's/^(\t*)([^\t]*)$/\1- \2/gp' >> "$journal_file_name";
		done
		
		printf -- "\tWrote ${#journal_draft_array[@]} draft lines\n\n" >> "$log_target";
		
		printf -- "\nGenerated\t\t${generated_desc}\n" >> "$journal_file_name";
	else
		# Storing journal contents in an array
		declare -a journal_contents_array=();
		mapfile -t journal_contents_array < "$journal_file_name";
		
		printf "Accessed ${journal_file_name}\n" >> "$log_target";

		let replace_len="${#journal_contents_array[@]}"-2;
		let insert_before="$replace_len"-2;
		let insert_after="$insert_before"+1;
				
		# Rewrite the old content
		printf "" > "$journal_file_name";

		for i in $(seq -s ' ' 0 "$insert_before")
		do
			printf -- "${journal_contents_array[$i]}\n" >> "$journal_file_name";
		done

		# Insert the new content
		for i in "${!journal_draft_array[@]}";
		do
			printf -- "${journal_draft_array[$i]}\n" | sed -rn 's/^(\t*)([^\t]*)$/\1- \2/gp' >> "$journal_file_name";
		done
		
		printf -- "\tAppended ${#journal_draft_array[@]} draft lines\n\n" >> "$log_target";

		# Insert the generated footer
		for i in $(seq -s ' ' "$insert_after" "$replace_len")
		do
			printf -- "${journal_contents_array[$i]}\n" >> "$journal_file_name";
		done
	fi

	printf "Last modified\t${generated_desc}" >> "$journal_file_name";
else
	printf -- "\tDraft empty - No action taken\n\n" >> "$log_target";
fi

# Wipe the draft file no matter what (to eliminate tabs and spaces even if it's "empty")
printf "" > "$journal_draft_target";

exit 0;