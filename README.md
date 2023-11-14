# IntuneScripts
Just a bunch of my helpful Intune scripts. Like always if you use any of these you do at your own risk, always test the random stuff you find on the internet first before deploying to production.


# HomeDriveMigration
User home drives where redirected to an onprem file share (As was the style at them time). So we needed to migrate users data from the home drive to local in an easy way that the end user could kick off if required.

The script will check for the connected network drive and log in if required, It will then copy the contents and drop it in the local user drive ready to sync to OneDrive.

# DeployPrinters
Super simple one for connecting and removing network shared printers.

# SetDesktopBackground
Client didnt have SharePoint running (Long story) but still wanted to deploy a desktop background to all managed devices. So here is a simple script that when packaged together with a background image will copy the image from the temp deployment location to a location that you specify. Once this is done you can then create a configuration in Intune to set that image as the Desktop.

# SetRegion
Intune lacks the ability to set and enforce language and region settings outside of initial Autopilot deployment. This script can be packaged as an app and deployed to devices to set language and region settings (Currently configured fro Australia)

# DetectionScripts
These detection scripts will find and remediate issues found. MicrosotStorePin will look for the MS store app and remove it from the task bar if it is found, Same with the Teams chat remediation.

# HideTaskbarIcons
This script aims to remove the annoying default taskbar bloat - Search, Chat, and widgets. Most clients coming from Windows 10 have no used for them and they are just confusing to most users.