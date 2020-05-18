#!/usr/bin/env python
import os

PDF = '.pdf'

# pdftk's commands
CMD_UNCOMPRESS = 'pdftk {file} output {file}1 uncompress'
CMD_SED = 'sed {annotations} {file}1 > {file}2'
CMD_COMPRESS = 'pdftk {file}2 output {file} compress'

# Annotations
ANNOTATIONS = ''.join([
    '-e "s/www.it-ebooks.info/ /" ',
    '-e "s/www.allitebooks.com/ /" ',
    '-e "s/WWW.EBOOK777.COM/ /" ',
    '-e "s/www.ebook777.com/ /" ',
    '-e "s/Free ebooks ==>/ /" ',
    '-e "s/free ebooks ==>/ /" ',
    '-e "s/Free ebooks ==>   www.ebook777.com/ /" ',
    '-e "s/\/URI/ /" ',
])


def clean(file_name):
    """
    Correcting name of file for pdftk.
    """
    file_name = file_name.replace(' ', '_') \
        .replace('(', '') \
        .replace(')', '') \
        .replace(',', '') \
        .replace('-', '-') \
        .replace('!', '')

    return file_name


def rename(path):
    """
    Rename file.
    """
    for file in os.listdir(path):
        if file.endswith(PDF):
            if ' ' in file:
                os.rename(file, clean(file))


def finalize(file):
    os.remove('{file}'.format(file=file))

    print('\033[92mCompressing...\033[0m')
    os.system(CMD_COMPRESS.format(file=file))

    os.remove('{file}1'.format(file=file))
    os.remove('{file}2'.format(file=file))

    print(
        '\033[92m{msg}\033[0m: \033[33m{file}\033[0m.'.format(
            file=file,
            msg='Annotations removed from file')
    )
    print('\033[96m------\033[0m' * 14, '\n')


def remove_annots(path):
    """
    Remove annotations from file.
    """
    rename(path)

    for file in os.listdir(path):
        if file.endswith(PDF):
            print('\033[96m------\033[0m' * 14)
            print('\033[92mUncompressing...\033[0m')
            os.system(CMD_UNCOMPRESS.format(file=file))
            print('\033[92mRemoving annotations...\033[0m')
            os.system(CMD_SED.format(file=file, annotations=ANNOTATIONS))
            finalize(file)


if __name__ == '__main__':
    aw = input('Are you sure? [y/n]: ')
    if aw.lower() in ['y', 'yes']:
        remove_annots(os.curdir)
