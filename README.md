# linux-project-tool
A small project handler i created for myself. feel free to use it!

## Description:
An extremely lightweight project manager that i find helps me to easily pick up where i left off.
This is designed for people that don't use IDEs.

## Usage/Installation:
All you need to do it copy the function to the bottom of your .bashrc. 
Run ``project -h`` for help.

## Features:
a "project" is just a file containing all your code, your build file ect for a, well, project.
this tool can currently:
create projects
open projects by cd'ing into them and opening the project in your text editor of choice (default nvim) and the file browser.
change the folder where projects are created and looked for.

(p.s this is just the outline. running ``project -h`` will give you the full usage.)

## Currently tested and confirmed working editors:
nvim, vim and vi
subl

### Notes:

this requires a gnome terminal.

I'll accept any PR's if you decide to fix my shitty code, or raise an issue and i'll fix it on my monthly check of my github and email.
