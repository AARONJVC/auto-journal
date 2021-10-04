# Auto Journal
### About
Auto Journal is a script utility that formats and organizes simple notes into structured journal entries. It is intended as a minimalist system that is simple to use and storage-conservative. 
### Compatibility 
Auto Journal was developed on a machine running Windows 10 and written for a bash interpreter. It has not been tested in other environments, but may work on some. 
*Learn more about [bash scripts](https://www.linux.com/training-tutorials/writing-simple-bash-script/).* 

### Setting Up 

### Usage
Auto Journal takes your thoughts, polishes them into a finished journal entry, and stores this inside an organized Archive folder for you to access later.

- **Journal entries are stored in .txt files for space efficiency.**
    - 100 years of writing 1200-word (~8KB) journal entries every day takes up less than 290MB, or 0.29GB. This can easily be stored on an inexpensive flash drive.
- **Entries are organized inside a simple directory structure for easy searching.**
    - Folders and files follow a particular naming convention to disambiguate navigation.
        - Every month is associated with a year, and every day with a month and year.
    - Naming Convention Details
        - The Archive folder contains folders for each year, each named "yyyy"
            - e.g. "2021"
        - Year folders contain folders for each month, each named "mm_Mon_yyyy"
            - e.g. "01_Jan_2021", "12_Dec_2021"
            - This convention ensures month folders are correctly ordered when displayed.
        - Month folders contain the journal entries for each recorded day, each named "dd_mon_yyyy.txt"
            - e.g. "13_aug_2021"
    - Folders are only created on an as-needed basis. If no journal entries exist for a given month or year, no folder will exist corresponding to that month or year.
    
