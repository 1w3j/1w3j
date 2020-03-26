#!/usr/bin/env python

import argparse
import os
import subprocess
from termcolor import colored

parser = argparse.ArgumentParser(
    description='Puts the "Title" metadata attribute of pdf files instead of file name'
)
parser.add_argument('-r', '-R', '--recursive',
                    action='store_true',
                    help='Make recursive the processing for all the files, directories, links, etc.'
                    )
parser.add_argument('files',
                    nargs='+',
                    help='The list of files to be modified'
                    )
parser.add_argument('--debug', '-D',
                    action="store_true",
                    help='Sort like \'dry run mode\', prints out which commands are going to be used for updating the '
                         'pdfs '
                    )
parser.add_argument('-o', '--output',
                    type=argparse.FileType('a'),
                    help='Store the output in a file'
                    )

args = parser.parse_args()
selected_files = args.files[:]
actual_files = []
if args.recursive:
    print(colored('***Attention*** Recursive mode detected:', "yellow"))
    for arg_file in selected_files:
        if os.path.exists(arg_file):
            for root, dirs, recursive_files in os.walk(arg_file):
                for file in recursive_files:
                    if os.path.splitext(file)[1] == ".pdf":
                        actual_files.append(os.path.join(root, file))
        else:
            print(colored("File: " + arg_file + " does not exist", "red"))

if len(actual_files) == 0:
    for file in selected_files:
        if os.path.isfile(file):
            if os.path.splitext(file)[1] == ".pdf":
                actual_files.append(file)
            else:
                print(colored("(.) File: " + file + " is not a pdf", "yellow"))
        else:
            print(colored(file + " is not a file", "red"))

# at this point `actual_files` should be filled with the paths
if len(actual_files) == 0:
    print(colored("(.) No pdf files detected, nothing to do, exiting...", "yellow"))
    exit()
else:
    print(colored(str(len(actual_files)) + " PDFs detected", "green"))
    if len(actual_files) >= 10 and args.recursive:
        print(colored("Showing first 10:", "green"))
        count = 0
        for file in actual_files:
            count += 1
            filename = os.path.splitext(os.path.basename(file))[0]
            print("\t" + str(count) + ") " + filename)
            if count == 10:
                break

# show recursive warning
if args.recursive:
    input('Press ENTER to continue or Ctrl-C the shit out')

count = 0
log = ""

for file in actual_files:
    count += 1
    filename = os.path.splitext(os.path.basename(file))[0]
    command = ["exiftool", "-Title=" + filename, file]
    exiftool = None
    if not args.debug:
        exiftool = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)  # shell=True
        exiftout, exifterr = exiftool.communicate()
        had_warnings = bytes.decode(exifterr).startswith("Warning:")
        rm = subprocess.Popen(['rm', '-f', file + "_original"])  # .pdf_original extension created by exiftool
        if len(bytes.decode(exifterr)) != 0 and not had_warnings:
            log = colored(str(count) + ") " + filename + ": " + bytes.decode(exifterr), "red")
        elif had_warnings:
            log = colored(str(count) + ") " + filename + ": " + bytes.decode(exifterr), "yellow")
        else:
            log = colored(str(count) + ") " + filename + "...OK", "green")

        if args.output is not None: args.output.write(log + "\n")
        print(log)
    else:
        print('\'' + " ".join(command) + '\'')
        if len(actual_files) == count:
            print(colored(str(count) + " PDFs are going to be modified", "green"))
            if args.output is not None:
                print(colored("Output will be saved on " + args.output.name, "green"))
