#!/bin/bash

object_files="$(find "$path_sgr_68k_objects_debug" -type f -regex ".*.o" 2> /dev/null | sed "s, ,~,g") "
object_files+="$(find "$path_sgr_68k_objects_release" -type f -regex ".*.o" 2> /dev/null | sed "s, ,~,g") "
object_files+="$(find "$path_sgr_68k_objects_lto" -type f -regex ".*.o" 2> /dev/null | sed "s, ,~,g")"

for object_file in $object_files
do
    basename="$(basename $object_file | sed "s,\.o,," | sed "s,~,\\\ ,g")"
    source_file="$(find "$path_sgr_68k_sources" -type f -name "$basename" | sed 's, ,\\\ ,g')"
    object_file="$(echo "$object_file" | sed "s,~, ,g")"
	basename="$(echo \"$basename\")"
	
    if [ "$source_file" = "" ]; then
        rm "$object_file" 2> /dev/null
        eval "rm \"$path_sgr_68k_dependencies/${basename}.d\"" 2> /dev/null
    fi
done
