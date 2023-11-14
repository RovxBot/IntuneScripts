# IntuneScripts
Just a bunch of my helpful Intune scripts. Like always if you use any of these you do at your own risk, always test the random stuff you find on the internet first before deploying to production.

# Disclaimer
While I hope you find something useful here that you are able to use, I must stress: please test everything before you deploy it into production! Many of the scripts here are still in development and may have unintended results. 

# HomeDriveMigration
User home drives where redirected to an onprem file share (As was the style at them time). So we needed to migrate users data from the home drive to local in an easy way that the end user could kick off if required.

The script will check for the connected network drive and log in if required, It will then copy the contents and drop it in the local user drive ready to sync to OneDrive.
##### Update
This script has been overhauled to use Robocopy, and only copy selected user folders as I was running into issues with Defender for Endpoint when it ran into browser saved passwords. The script is also more modular allowing you to exclude folders and add/remove and also add or remove directories to copy.

# DeployPrinters
Super simple one for connecting and removing network shared printers.

# SetDesktopBackground
Client didnt have SharePoint running (Long story) but still wanted to deploy a desktop background to all managed devices. So here is a simple script that when packaged together with a background image will copy the image from the temp deployment location to a location that you specify. Once this is done you can then create a configuration in Intune to set that image as the Desktop.

# SetRegion - In development
Intune lacks the ability to set and enforce language and region settings outside of initial Autopilot deployment. This script can be packaged as an app and deployed to devices to set language and region settings (Currently configured for Australia)

# DetectionScripts
These detection scripts will find and remediate issues found. MicrosotStorePin will look for the MS store app and remove it from the task bar if it is found, Same with the Teams chat remediation.

# HideTaskbarIcons
This script aims to remove the annoying default taskbar bloat - Search, Chat, and widgets. Most clients coming from Windows 10 have no used for them and they are just confusing to most users.

# TeamsVoiceHolidays - In development
This script will pull the latest holidays from data.gov.au before submitting them to Teams. The idea is to find something that I can run on a schedule so it updates every few months. It is working for now as a once off run, but instead of updating holidays the next run it will just create the holiday again.

# Use
I tend to deploy many of my scripts as packaged .intunewin applications. The only exeption to this is the detection scripts that get deployed via Remediation scripts in Intune, and the TeamsVoiceHolidays that I just run on my local PC.
