![GitHub contributors](https://img.shields.io/github/contributors/bronygamedev/friendship-globe)  [![Discord](https://img.shields.io/discord/999679634994122824)](https://bronygamedev.github.io/redirect.html?to=https://discord.gg/78RVfevpuU)  ![GitHub forks](https://img.shields.io/github/forks/bronygamedev/friendship-globe)  ![GitHub Repo stars](https://img.shields.io/github/stars/bronygamedev/friendship-globe)  ![GitHub closed issues](https://img.shields.io/github/issues-closed/bronygamedev/friendship-globe)  ![GitHub milestones](https://img.shields.io/github/milestones/open/bronygamedev/friendship-globe)  ![GitHub closed issues by-label](https://img.shields.io/github/issues-closed/bronygamedev/friendship-globe/bug)  ![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/bronygamedev/friendship-globe/.github%2Fworkflows%2Fsite.yml)  ![Website](https://img.shields.io/website?url=https://bronygamedev.github.io/friendship-globe/globe&label=globe)   


# Friendship globe

The friendship globe symbolizes even though where in different country's where still united through the friendships from the MLP fandom.

## Inspiration

At the end of r/place 2023 moderators of [bronyplace](https://discord.gg/bronyplace) were talking about not losing these bonds between the friends we made during r/place 2023 and one of them said something along the lines of  "Just because we can't put a rainbow across the globe doesn't mean we can't find other ways to express our friendship towards one another" and that got me thinking if we can't physically stretch a rainbow across the globe why not do it virtually? So that night I started to work on this.

## Contributing

see [CONTRIBUTING.md](https://github.com/bronygamedev/friendship-globe/blob/main/CONTRIBUTING.md)

## Running. 
### setup 
First, make sure you have the following programs installed

* latest [Godot 3](https://godotengine.org/download/3.x/) build
* [Python 3.11](https://www.python.org/downloads/)  

get the latest stable version [here](https://github.com/bronygamedev/friendship-globe/releases)
or clone this repo `git clone https://github.com/bronygamedev/friendship-globe.git`

### server set up
open the folder in the terminal 
type `cd server` to enter the server directory
##### linux/macOS
run `./install_requirements.sh` and wait for it to finish installing all dependencies (this may take a while).
run `source .venv/bin/activate`
run `python server.py`
##### Windows
run `python -m venv .venv`
run `./.venv/scripts/activate`
run `pip install -r requiements.txt`
run `python server.py`

  
  

open the project in godot (open godot -> import -> "path/to/friendship-globe/client_gd3/project.godot")
then click play button in the top right corner 


>  **NOTE**:
>
> there currently are no official servers to run this, for now it's a proof of concept.
