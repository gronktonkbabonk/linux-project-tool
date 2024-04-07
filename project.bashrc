#put this at the bottom of your .bashrc file
function project()   {

    DIR_CONFIG_FILE="$HOME/.config/project_tool/.dir_project_config"
    TEXED_CONFIG_FILE="$HOME/.config/project_tool/.text_editor_config"

    if [ ! -d "$HOME/.config/project_tool/" ]; then
        mkdir "$HOME/.config/project_tool/"
    fi
        
    # Check if a project name is passed as an argument
    if [ $# -eq 0 ]; then
        echo "Please provide arguments."
        return 1
    fi

    # Check if the project config file exists and create it if not
    if [ ! -f "$DIR_CONFIG_FILE" ]; then
        touch "$DIR_CONFIG_FILE"
    fi

    # Read the project directory from the config file or set default
    project_dir=$(head -n 1 "$DIR_CONFIG_FILE")
    if [ -z "$project_dir" ]; then
        project_dir="$HOME/Desktop/projects" # Set a default project directory
    fi

    # Check if the text editor config file exists and create it if not
    if [ ! -f "$TEXED_CONFIG_FILE" ]; then
        touch "$TEXED_CONFIG_FILE"
    fi

    # Read the text editor from the config file or set default
    text_editor=$(head -n 1 "$TEXED_CONFIG_FILE")
    if [ -z "$text_editor" ]; then
        text_editor="nvim" # Set a default text editor
    fi

    project_name="$1"
    project_path="$project_dir/$project_name"
    project_exists=1
    
    if [ $1 = "--help" ] || [ $1 = "-h" ]; then
        echo -e "GRONK'S PROJECT TOOL
 
Usage:

project [projectname]: this will cd to the project, open it in the file mgr and open it in your text editor (default nvim)
project [projectname] -b: this will do the same, but cd into the project's build directory

project [newprojectname] -c: this will create a new project in your project directory
project [newprojectname] -c -o: this will do the same as above, but also open it as if you had opened it with this tool

project [directory] -f: this will change the directory of where your projects are created and looked for.
project [directory] -f -d: additionally deletes the old project file and its contents.
project [texteditor] -t: this will alter the text editor to the one specified. It needs to be able to open folders in the console.

project -h / --help: show this screen
project -l / --list: list projects"

return 0

fi
    if [ $1 = "-l" ] || [ $1 = "--list" ]; then
        ls "$project_dir"
        return 0
    fi        

    if [ ! -d "$project_path" ]; then
        project_exists=0
    fi
    
    case "$2" in
        "-b" )
            if [ "$project_exists" -eq 0 ]; then
                echo "$1 is not a recognized project in $project_dir"
                return 1
            else
                cd "$project_path/build" || echo "$1 is not a recognized project in $project_dir"
            fi
            ;;
        "-c" )
            mkdir "$project_dir/$project_name"
            echo "Project $project_name created"
            if [ "$3" == "-o" ]; then
                cd "$project_dir/$project_name"
                gnome-terminal --tab --working-directory="$project_path" -- "$text_editor /"
                xdg-open "$project_path" &>/dev/null
            fi
            return 0
            ;;
        "-f" )
            if [ "$3" == "-d" ]; then
                rm -rf "$project_dir"
                echo "deleted $project_dir and it's contents.'"
            fi
            if [ -d "$1" ]; then
                # Set the project directory in the config file
                echo "$1" > "$DIR_CONFIG_FILE"
                echo "Project directory changed to $1"
                return 0
            else
                echo "Directory $1 does not exist."
                return 1
            fi
            ;;
        "-t" )
            echo "$1" > "$TEXED_CONFIG_FILE"
            echo "Text editor changed to $1. reminder that it needs to be able to open folders in the console."
            return 1
            ;;
        "" )
            if [ "$project_exists" -eq 0 ]; then
                echo "$1 is not a recognized project in $project_dir"
                return 1
            else
                cd "$project_path"
            fi  
            ;;
        * )
            echo "Invalid option."
            return 1
            ;;
    esac
    gnome-terminal --tab --working-directory="$project_path" -- bash -c "$text_editor / ; bash"
    xdg-open "$project_path" &>/dev/null 
}
