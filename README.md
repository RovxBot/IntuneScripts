# IntuneScripts 🚀

Welcome to my IntuneScripts repository! Here, you'll find a curated collection of scripts designed to make your Intune experience smoother. Remember, though: deploy at your own risk and always give things a test run before unleashing them in production.

## Disclaimer ⚠️

While these scripts are crafted to be helpful, it's crucial to exercise caution. Test rigorously before deploying to ensure a seamless experience. Some scripts are still in development, so expect the unexpected.

## HomeDriveMigration 🏠

User home drives were once redirected to an on-prem file share (a blast from the past). This script elegantly migrates user data from the home drive to the local drive, giving end users the power to initiate if needed.

### Update ✨

Overhauled using Robocopy, it selectively copies user folders. This change, prompted by Defender for Endpoint issues with browser passwords, makes the script modular. Customize folder exclusions and inclusions with ease.

## DeployPrinters 🖨️

A simple script for effortlessly connecting and removing network shared printers.

### Update ✨

Added a second script that can be added as a pre-requisit install to deploy print drivers.

## SetDesktopBackground 🌄

No SharePoint, no problem! For clients without SharePoint but with a thirst for a unified desktop look, this script, paired with a background image, seamlessly copies it to a specified location. Configure Intune to set that image as the desktop background, and voila!

![Desktop Background](https://github.com/RovxBot/IntuneScripts/blob/main/Images/DesktopGirl.jpg)

## SetRegion (In Development) 🌏

Intune struggles with language and region settings post-Autopilot. Enter this script, currently geared for Australia. Package it as an app, deploy to devices, and watch as language and region settings fall into line.

## DetectionScripts 🔍

These scripts play detective and fix issues on the fly. `MicrosoftStorePin` removes the Microsoft Store app from the taskbar, and Teams chat remediation does the same for Teams chat.

## HideTaskbarIcons 🚫

Trim the taskbar fat with this script. Search, Chat, and Widgets—gone! Ideal for clients transitioning from Windows 10 who find these features more confusing than helpful.

## TeamsVoiceHolidays (In Development) 📅

Stay updated with the latest holidays from data.gov.au. Schedule it to run periodically, and it'll submit the updates to Teams. A work in progress, but functional for a one-off run—just be aware it creates holidays instead of updating on subsequent runs.

![Teams Voice Holidays](https://github.com/RovxBot/IntuneScripts/blob/main/Images/CalanderGirl.jpg)

## DeployFonts 

Package and deploy fonts with ease. These scripts packaged along with a Fonts folder will deploy and install the whole folder of fonts to your end users.


## Usage 🛠️

I typically deploy many of my scripts as packaged `.intunewin` applications. Exception: detection scripts, deployed via remediation scripts in Intune, and TeamsVoiceHolidays, run locally on my PC.
