#!/usr/bin/env python

import argparse
import os
import subprocess
from termcolor import colored

parser = argparse.ArgumentParser(
    description='Writes the "Title" metadata attribute of pdf files using its file name'
)
parser.add_argument('-r', '-R', '--recursive',
                    action='store_true',
                    help='Make recursive the processing for all the files, directories and links'
                    )
parser.add_argument('files',
                    nargs='+',
                    help='The list of files to be modified'
                    )
parser.add_argument('--dry-mode', '-D',
                    action="store_true",
                    help='Sort of \'dry run mode\', prints out which commands are going to be used for updating the '
                         'pdfs '
                    )
parser.add_argument('--do-not-remove-annotations', '-A',
                    action="store_true",
                    help='Do no perform sed trimming of those annoying tags or annotations from free downloading '
                         'sites, this process takes time, so if need to rush, then pass this arg '
                    )
parser.add_argument('-o', '--output',
                    type=argparse.FileType('a'),
                    help='Store stdout in a file'
                    )

# Annoying annotations, they must have sed patterns format
annoyingtations = ''.join([
    # '-e "s/\/URI/ /" ',
    '-e "s/www.it-ebooks.info//i" ',
    '-e "s/it-ebooks.info//i" ',
    '-e "s/www.allitebooks.com//i" ',
    '-e "s/www.allitebooks.org//i" ',
    '-e "s/free ebooks ==>   www.ebook777.com//i" ',
    '-e "s/free ebooks ==>//i" ',
    '-e "s/http:\/\/free-pdf-books.com//i" ',
    '-e "s/http:\/\/freepdf-books.com//i" ',
    '-e "s/www.freepdf-books.com//i" ',
    '-e "s/www.ebook777.com//i" ',
    '-e "s/http:\/\/www.itbookshub.com//i" ',
    '-e "s/http:\/\/itbookshub.com//i" ',
    '-e "s/www.itbookshub.com//i" ',
    '-e "s/itbookshub.com//i" ',
    '-e "s/www.it-ebooks.directory//i" ',
    '-e "s/it-ebooks.directory//i" ',
])

args = parser.parse_args()
passed_files = args.files[:]
actual_files = []

# Filling up the array with the file paths to be processed
# Checking first if need to be recursive
if args.recursive:
    print(colored('***Attention*** Recursive mode detected:', "yellow"))
    for arg_file in passed_files:
        if os.path.exists(arg_file):
            for root, dirs, recursive_files in os.walk(arg_file):
                for file in recursive_files:
                    if os.path.splitext(file)[1] == ".pdf":  # if the file is a PDF, then append to main array
                        actual_files.append(os.path.join(root, file))
        else:
            print(colored("(x) File: " + arg_file + " does not exist", "red"))

if len(actual_files) == 0:
    for file in passed_files:
        if os.path.isfile(file):
            # if it wasn't recursive, check once again those files are PDFs
            if os.path.splitext(file)[1] == ".pdf":
                actual_files.append(file)
            else:
                print(colored("(x) File: " + file + " is not a pdf", "yellow"))
        else:
            print(colored("(x) " + file + " is not a file", "red"))

# at this point `actual_files` should be filled with the paths
if len(actual_files) == 0:
    print(colored("(.) No pdf files detected, nothing to do, exiting...", "yellow"))
    exit()
else:
    print(colored("(.) " + str(len(actual_files)) + " PDFs detected", "green"))
    # If there are more than then PDFs prepared to be processed, then show them
    if len(actual_files) >= 10 and args.recursive:
        print(colored("(.) Showing first 10:", "green"))
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

# begin the actual processing
count = 0
log = ""

# perform exiftool processing for changing the 'Title' metadata of the file
for file in actual_files:
    count += 1
    filename = os.path.splitext(os.path.basename(file))[0]  # getting the basename without the extension (.pdf)
    exiftcmd = ["exiftool", "-Title=" + filename, file]
    uncompress_pdf_cmd = ['pdftk', file, 'output', file + '~t1', 'uncompress']
    # sed_pdf_cmd = ['sed', annoyingtations, file+'~t1 > ' + file+'~t2']
    sed_pdf_cmd = "sed {annoyingtations} {file}~t1 > {file}~t2".format(annoyingtations=annoyingtations, file=file)
    compress_pdf_cmd = ['pdftk', file+'~t2', 'output', file + 'compress']
    exiftool = None
    if not args.dry_mode:
        exiftool = subprocess.Popen(exiftcmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)  # shell=True
        exiftout, exifterr = exiftool.communicate()
        had_warnings = bytes.decode(exifterr).startswith("Warning:")
        if not args.do_not_remove_annotations:
            print(colored("Uncompressing...", 'yellow'))
            print(uncompress_pdf_cmd)
            uncompress = subprocess.call(uncompress_pdf_cmd)
            # print("\033[A                             \033[A")
            if uncompress == 0:
                print(colored("Removing annotations...", "red"))
                print(sed_pdf_cmd)
                sed = subprocess.call(sed_pdf_cmd.split())
                # print("\033[A                             \033[A")
                if sed == 0:
                    print(colored("Compressing...", "green"))
                    print(compress_pdf_cmd)
                    compress = subprocess.call(compress_pdf_cmd)
                    # print("\033[A                             \033[A")
                    os.remove(file+'~t1')
                    os.remove(file+'~t2')
        if len(bytes.decode(exifterr)) != 0 and not had_warnings:
            log = colored(str(count) + ") " + filename[0:40] + ": " + bytes.decode(exifterr), "red")
        elif had_warnings:
            log = colored(str(count) + ") " + filename[0:40] + ": " + bytes.decode(exifterr), "yellow")
        else:
            log = colored(str(count) + ") " + filename[0:40] + " ✓", "green")

        os.remove(file + "_original")  # *.pdf_original extension created by exiftool
        if args.output is not None:
            args.output.write(log + "\n")
        print(log)
    else:
        print('\'' + " ".join(exiftcmd) + '\'')
        if len(actual_files) == count:
            print(colored(str(count) + " PDFs are going to be modified", "green"))
            if args.output is not None:
                print(colored("Output will be saved on " + args.output.name, "green"))
