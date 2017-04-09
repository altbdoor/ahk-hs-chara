AppVersion := "1.0"


HelpMessage =
(
This program "activates" and "deactivates" folders within the "chara" folder by moving the cards in and out. It allows you to group cards into a folder to tidy things up.

Due to the *possibly* destructive nature of its action, please backup your card before trying this out. I tried to test all possible scenarios, but I might miss out some.


== Scanning A Folder ==

1. Select a card within your character folder by clicking "Browse". That lets the program know where your "chara" folder is.

2. Click "Scan Folder", and it will look for other folders within the "chara" folder. This will be listed in the "Available Folders" section.

3. If the scan is successful, the program will remember the path to your "chara" folder, and automatically perform a scan on the next run.


== Activating A Folder ==

1. Select one of the folders in the "Available Folders" list, then click "Activate".

2. All the cards in the "chara" folder will be moved back into their original folder. All the cards in the newly "activated" folder will be moved out to the "chara" folder.

3. If it is the first run, the program will move the cards into a folder called "__unsorted__".


== Reverting Activated Folder ==

1. Click the "Revert" button.

2. All the cards in the "chara" folder will be moved back into their original folder. All the cards in the "__unsorted__" folder will be moved out to the "chara" folder.

)


AboutMessage =
(
Version %AppVersion%

Idea by Flashk1ll @ http://flashk1llhoneyselect.blogspot.com/
Icon image modified @ https://morguefile.com/p/848961
Source code @ https://github.com/altbdoor/ahk-hs-chara

WTFPL License

Come join us on Discord @ https://discord.gg/xw8mHsE

P.S. Sorry that these messages are in this weird, clickable, huge text boxes. No one is going to spend much time in here anyways.

)
