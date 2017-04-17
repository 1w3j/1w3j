#!/usr/bin/env python3.5

import argparse
import os
import subprocess
from termcolor import colored

parser = argparse.ArgumentParser(description='Converts the "Title" metadata attribute of pdf files and set it the same as its file name')
parser.add_argument('-r','-R','--recursive', action='store_true', help='Make recursive the processing for all the files, directories, links, etc.')
parser.add_argument('files', nargs='+', help='The list of files to be modified')
parser.add_argument('--debug','-D',action="store_true",help="MAKES THE PROGRAM NOT TO CHANGE THE METADATA BUT prints out which commands are going to be used for updating the pdf")

args=parser.parse_args()
selected_files=args.files[:]
actual_files=[]
if(args.recursive):
    print(colored('(*) Recursive mode detected:',"yellow"))
    for arg_file in selected_files:
        if os.path.exists(arg_file):
            for root, dirs, recursive_files in os.walk(arg_file):
                for file in recursive_files:
                    if os.path.splitext(file)[1] == ".pdf":
                        actual_files.append(os.path.join(root,file))
        else:
            print(colored("File: " + arg_file + " does not exists" , "red"))

if len(actual_files) == 0:
    for file in selected_files:
        if os.path.isfile(file):
            if os.path.splitext(file)[1] == ".pdf":
                actual_files.append(file)
            else:
                print(colored("(.) File: "+file+" is not a pdf","yellow"))
        else:
            print(colored(file+" is not a file","red"))

count=0
for file in actual_files:
    count += 1
    filename = os.path.splitext(os.path.basename(file))[0]
    command = ["exiftool","-Title="+filename,file]
    exiftool = None
    if not args.debug:
        exiftool = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)#shell=True
        exiftout, exifterr = exiftool.communicate()
        if len(exifterr) != 0 and not str(exifterr).startswith("Warning:"): print(colored(file + " " + str(exifterr),"red"))
        else:
            rm = subprocess.Popen(['rm','-f',file + "_original"])
            print(colored(str(count) + ") " + filename + " modified","green"))
    else:
        print('\'' + " ".join(command) + '\'')
        if len(actual_files) == count:
            print(colored(str(count) + " PDFs are going to be modified","green"))
