#!/usr/bin/env nix-shell
#!nix-shell -p python3 -p nix-prefetch-git -i python3

import json
import pathlib
import subprocess

def replace_contents(path, process):
    with open(path) as f:
        contents = f.read()

    contents = process(contents)

    with open(path, 'w') as f:
        f.write(contents)

def main():
    current_dir = pathlib.Path(__file__).parent
    src_file = current_dir / 'src.json'

    with open(src_file) as f:
        original_src_data = json.load(f)

    new_src_contents = subprocess.check_output(['nix-prefetch-git', '--leave-dotGit', original_src_data['url']], encoding='utf-8')

    with open(src_file, 'w') as f:
        f.write(new_src_contents)

if __name__ == '__main__':
    main()
