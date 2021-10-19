# Auto Journal
### About
Auto Journal is a script utility that formats and organizes simple notes into structured journal entries. It is designed to be a minimal system that is simple to use and storage-conservative. 
### Compatibility 
Auto Journal was developed on a machine running Windows 10 and written for a Bash interpreter. It has not been tested in other environments, but may work on some.  
*Learn more about [bash scripts](https://www.linux.com/training-tutorials/writing-simple-bash-script/).* 

### Setting Up
A separate script will be responsible for creating the journal directories and configuring the main script. This is currently incomplete.

### Usage
Auto Journal takes your thoughts, polishes them into a finished journal entry, and stores this inside an organized Archive folder for you to access later.

### Organization
- **Journal entries are stored in .txt files for space efficiency.**
    - 100 years of writing 1200-word (~8KiB) journal entries every day would use less than 290MiB, or 0.29GiB. This amount of data can easily be stored on an inexpensive flash drive.
- **Entries are organized inside a simple directory structure for easy searching.**
    - Folders and files follow a particular naming convention to disambiguate navigation.
        - Every month is associated with a year, and every day with a month and year.
        - Naming Convention details
            - The Archive folder contains year folders, each named "yyyy"
                - e.g. "2021"
            - Year folders contain month folders, each named "mm_Mon_yyyy"
                - e.g. "01_Jan_2021", "12_Dec_2021"
                - This convention ensures that month folders are correctly ordered when displayed.
            - Month folders contain .txt files for daily journal entries, each named "dd_mon_yyyy.txt"
                - e.g. "13_aug_2021"
- **Folders and files are only created as needed.**
    - If no journal entries exist for a given month or year, no folder will exist corresponding to that month or year.

