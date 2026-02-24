#!/usr/bin/env python3
''' This script processes CSV files in a specified directory, converting values in columns containing "StateCd"
to uppercase. It supports both a dry run mode (which reports how many values would be changed) and an actual
execution mode (which modifies the files in place). The processing is done in parallel using multiprocessing.
Our datafiles are large, so we read and write them in chunks to manage memory usage effectively.'''
# Chris Edgeworth, 2024-06-20
import os
from multiprocessing import Pool
import pandas as pd
import tempfile
import shutil

WORKERS = 4
CHUNKSIZE = 250_000

def process_file(file_path, dry_run):
    try:
        df_header = pd.read_csv(file_path, nrows=0)
        target_columns = [c for c in df_header.columns if "StateCd" in c]

        if not target_columns:
            return f"{os.path.basename(file_path)}: skipped"

        if dry_run:
            total, modified = 0, 0
            for chunk in pd.read_csv(file_path, dtype=str, chunksize=CHUNKSIZE):
                total += len(chunk)
                for col in target_columns:
                    upper = chunk[col].str.upper()
                    modified += (chunk[col] != upper).sum()

            return f"{os.path.basename(file_path)}: {modified}/{total} changes"

        # write path
        with tempfile.NamedTemporaryFile(delete=False, suffix=".csv") as tmp:
            temp_path = tmp.name

        first = True
        for chunk in pd.read_csv(file_path, dtype=str, chunksize=CHUNKSIZE):
            for col in target_columns:
                chunk[col] = chunk[col].str.upper()

            chunk.to_csv(temp_path, mode="a", header=first, index=False)
            first = False

        shutil.move(temp_path, file_path)
        return f"{os.path.basename(file_path)}: updated"

    except Exception as e:
        return f"{os.path.basename(file_path)}: ERROR {e}"


def run(directory, dry_run=True):
    files = [
        os.path.join(directory, f)
        for f in os.listdir(directory)
        if f.lower().endswith(".csv")
    ]

    with Pool(WORKERS) as pool:
        results = pool.starmap(process_file, [(f, dry_run) for f in files])

    for r in results:
        print(r)


if __name__ == "__main__":
    run("data/TEC_CF_CSV/", dry_run=False)