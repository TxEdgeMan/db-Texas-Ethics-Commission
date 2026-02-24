#!/usr/bin/python3
'''
Verify that the filerIdent field in the filers.csv file is an integer and remove any
records with invalid filerIdent. This is necessary because the TEC data import fails
if there are any non-integer filerIdent values.
Background:  On occaision filers.csv file will be generated with several of the last
records with an email address as the filerIdent. Report invalid records to 
support@ethics.state.tx.us

Chris Edgeworth
'''
import re     # regular expressions
import shutil # shell utilities
import os     # OS utilities

# read in filers.csv and will strip out any filer ids that are not of type integer

DEBUG = False

scriptname = os.path.basename(__file__)

def debug(msg):
    if DEBUG:
        print(f'{scriptname}:DEBUG: {msg}')
def filer_id_check():
    fin = open(
        "./data/TEC_CF_CSV/filers.csv", 
        "r", 
        encoding="utf-8"
        )
    fout = open(
        "./data/TEC_CF_CSV/filers.csv_MODIFIED.csv", 
        "w",
        encoding="utf-8"
        )
    fileridenterror = False
    for line_number,line in enumerate(fin,1):
        debug(f"line: {line_number} :record {line}")
        fields = line.split(",")
        if re.search(r"^\d+$", fields[1]) or re.search(r"filerIdent", fields[1]):
            fout.write(line)
        else:
            print(f"BAD Field found: {fields[1]} line: {line_number}: \nrecord: {line}")
            fileridenterror = True
    fin.close()
    fout.close()
    if fileridenterror:
        debug("Replacing filers.csv with updated file")
        shutil.move("./data/TEC_CF_CSV/filers.csv_MODIFIED.csv","./data/TEC_CF_CSV/filers.csv")
    else:
        debug("No filerIdent errors found, removing modified file")
        os.remove("./data/TEC_CF_CSV/filers.csv_MODIFIED.csv") 
## Main
if __name__== "__main__":
    filer_id_check()
    exit()
