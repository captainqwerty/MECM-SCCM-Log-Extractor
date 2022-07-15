# Script Name / Title
This script is ran automatically and emails new staff users the welcome email. It can also be ran manually targeting specific users with the email.

- [Script Name / Title](#script-name--title)
  - [Running the Script](#running-the-script)
    - [Sheduled Run](#sheduled-run)
    - [Manual Runs](#manual-runs)
  - [Generating a new LastRan.csv](#generating-a-new-lastrancsv)
  - [Known Issues](#known-issues)
  - [Future Improvements](#future-improvements)

## Running the Script
The script is configured to be ran on a task schedule but can also be ran manually. 

### Sheduled Run
The script is configured on a task shedule to run a specific time. When ran with no paramters it will simply check the .\Files\LastRan.csv file for the date it was last ran and then find all new users since that date and send the welcome email.
A log is created in .\Files\Logs\Log.log which contains information about each launch.

### Manual Runs
If ran without any paramters the script will run with the same result as an automated run however the script can be supplied and array of usernames to email specifically. 

```
Send-StudentWelcomeEmail.ps1 -usernames @("Antony.Bragg","Chris.Graham")
```
Manual runs will not alter the date stored in the LastRan.csv.

## Generating a new LastRan.csv
Open a PowerShell Window from the context of .\Files folder and run the following command entering how many days backwards you would like to set the date from. The below example would set the date to 3 days previous.

```
(Get-Date).AddDays(-3).Date | Export-Csv LastRan.csv -force
```

## Known Issues
Below is a list of currently known issues as of 05/09/2021 - If any of these are resolved please update the list and the date.

- No error handling at all
- No real solution implemented for if there is no LastRanFile

## Future Improvements
Below is a list of potential future improvements as of 05/09/2021 - If any of these are implemented please update the list and the date.

- Utilise Office 365