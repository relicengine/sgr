#!/bin/bash

path_sgr_68k_objects_debug=$path_sgr/obj/debug
path_sgr_68k_objects_release=$path_sgr/obj/release
path_sgr_68k_objects_lto=$path_sgr/obj/release/lto

object_files="$(find $path_sgr_68k_objects_debug -name *.o 2> /dev/null) "
object_files+="$(find $path_sgr_68k_objects_release -name *.o 2> /dev/null) "
object_files+=$(find $path_sgr_68k_objects_lto -name *.o 2> /dev/null)

for object_file in $object_files
do
    source_file=$(find $path_sgr/src -name $(basename $object_file | sed "s/\.o//"))
    if [ "$source_file" = "" ]; then
        rm $object_file
        rm $path_sgr/dep/$(basename $object_file | sed "s/\.o/\.d/") 2> /dev/null
    fi
done

#existing_objects = $(shell find $(path_sgr_68k_objects_debug) -name *.o 2> /dev/null)
#existing_objects				+= $(shell find $(path_sgr_68k_objects_release) -name *.o 2> /dev/null)
#existing_objects				+= $(shell find $(path_sgr_68k_objects_lto) -name *.o 2> /dev/null)