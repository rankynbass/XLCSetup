#!/usr/bin/env python3

import os
import sys
import argparse
import re
from pathlib import Path
import urllib.request
import urllib
import shutil
import tarfile
from urllib.request import urlopen
from tkinter import messagebox

parser = argparse.ArgumentParser(description='Local install tool for XIVLauncher.Core.')
installer = parser.add_argument_group('Install targets', "Where XIVLauncher will be installed")
exclusive = installer.add_mutually_exclusive_group()
exclusive.add_argument("-l", "--local", help="Install to ~/.local/share/xivlaucher-local. The default option if no other options are passed.",
                    action="store_true")
exclusive.add_argument("-s", "--steam", help="Install as steam compatibility tool to default path. Steam Deck users should choose this.",
                    action="store_true")
exclusive.add_argument("-f", "--flatpak", help="Install as steam compatibility tool for flatpak steam",
                    action="store_true")
exclusive.add_argument("--sct", help="Install as steam compatibility tool to custom location.", metavar="PATH")
installer.add_argument("-u", "--uninstall", help="Uninstall the target instead.",
                    action="store_true")
installer.add_argument("--RB", help="Install XIVLauncher-RB instead of the official XIVLauncher.Core",
                    action="store_true")
parser.add_argument("--force", help="Force the install even if the current version is up-to-date",
                    action="store_true")
parser.add_argument("-d", "--download", help="Always download the source, even if it's already cached.",
                    action="store_true")
parser.add_argument("--clear", help="Clear the cached files and exit.", action="store_true")
args = parser.parse_args()

if not args.steam and not args.flatpak and args.sct == None and not args.clear:
    args.local = True

print(f"Local Install   = {args.local}")
print(f"Steam Install   = {args.steam}")
print(f"Flatpak Install = {args.flatpak}")
print(f"Custom Install  = {args.sct}")
print(f"XIVLauncher-RB  = {args.RB}")
print(f"Uninstall       = {args.uninstall}")
print(f"Force Install   = {args.force}")
print(f"Force Download  = {args.download}")
print(f"Clear Cache     = {args.clear}")

print('basename:    ', os.path.basename(__file__))
print('dirname:     ', os.path.dirname(__file__))

home = os.environ.get("HOME")
xdg_data = os.environ.get("XDG_DATA_HOME") or os.path.join(home, ".local", "share")
xdg_cache = os.environ.get("XDG_CACHE_HOME") or os.path.join(home, ".cache")
# if (xdg_data == None) or (xdg_data_home == ""):
#     xdg_data = os.path.join(os.environ.get("HOME"), ".local", "share")
# if (xdg_cache == None) or (xdg_cache_home == ""):
#     xdg_cache = os.path.join(os.environ.get("HOME"), ".cache")

repo = "rankynbass" if args.RB else "goatcorp"
title = "XIVLauncher-RB" if args.RB else "XIVLauncher.Core"
release = "RB-Patched" if args.RB else "Official"
versioncheck = "https://raw.githubusercontent.com/rankynbass/XIVLauncher.Core/RB-patched/version.txt" \
    if args.RB else "https://raw.githubusercontent.com/goatcorp/xlcore-distrib/main/version.txt"

xlcore_url = f"https://github.com/{repo}/XIVLauncher.Core/releases/latest/download/XIVLauncher.Core.tar.gz"
aria2_url = "https://github.com/rankynbass/aria2-static-build/releases/latest/download/aria2-static.tar.gz"
tool_url = "https://github.com/rankynbass/XIVLocal-Installer/releases/latest/download/XIVLocal-Installer.tar.gz"

print(f"\nXDG_DATA_HOME={xdg_data}")
print(f"XDG_CACHE_HOME={xdg_cache}")
print(f"\nXIVLauncher.Core url = {xlcore_url}")
print(f"Aria2 url = {aria2_url}")
print(f"XIVLocal-Installer url = {tool_url}")
print(f"Title = {title} ({release})")
print(f"VersionCheckUrl = {versioncheck}")

scriptdir = os.path.dirname(__file__)
localdir = os.path.join(xdg_data, "xivlauncher-local")
steamdir = os.path.join(xdg_data, "Steam", "compatibilitytools.d")
flatpakdir = os.path.join(home, ".var", "app", "com.valvesoftware.Steam", ".local", "share", "Steam", "compatibilitytools.d")
xlcache_dir = os.path.join(xdg_cache, "XIVLocal-Installer")

def get_latest(url: str) -> str:
    version = ""
    with urllib.request.urlopen(url) as response:
        version = response.read().decode('utf-8')
    return version.strip()

def get_version_release(file: str) -> list[str]:
    lines = []
    with open(file, 'r') as versionfile:
        lines.append(versionfile.readline().strip())
        lines.append(versionfile.readline().strip())
    return lines

def download_tarball(url: str, filename: str) -> None:
    with urllib.request.urlopen(url) as response, open(filename, 'wb') as out_file:
        while True:
            data = response.read(4096)
            if not data:
                break
            out_file.write(data)

def parse_version(version: str) -> list[int] | None:
    """Very simple regex parse modified from distutils.version
    Using this since distutils is deprecated and our needs are very simple
    Version will match dotnet Version rules of a.b.c.d, all numeric.
    """
    version_regex = re.compile(r'^(\d+)\.(\d+)(\.(\d+))?(\.(\d+))?$')
    match = version_regex.match(version)
    if not match:
        return None
    (major, minor) = match.group(1, 2)
    release = match.group(4) or '0'
    patch = match.group(6) or '0'
    return [int(major), int(minor), int(release), int(patch)]

def needs_update(latest, current) -> bool:
    """We will update if we don't know the current version, or if the latest
    version is greater than the current version. We will not try to update
    if we don't know the latest version, because we probably can't download it.
    """
    if latest == None:
        return False
    if current == None:
        return True
    if latest[0] > current[0]:
        return True
    if latest[0] < current[0]:
        return False
    if latest[1] > current[1]:
        return True
    if latest[1] < current[1]:
        return False
    if latest[2] > current[2]:
        return True
    if latest[2] < current[2]:
        return False
    if latest[3] > current[3]:
        return True
    return False

def download_xlcore() -> str:
    # if cached file does not exist or args.download:
    filename = os.path.join(xlcache_dir, f"{title}.tar.gz")
    download_tarball(xlcore_url, filename)
    return filename

def download_aria2() -> str:
    # if cached file does not exist or args.download:
    filename = os.path.join(xlcache_dir, "aria2-static.tar.gz")
    download_tarball(aria2_url, filename)
    return filename

def download_installer() -> str:
    filename = os.path.join(xlcache_dir, "XIVLocal-Installer")
    download_tarball(tool_url, os.path.join(xlcache_dir, "XIVLocal-Installer.tar.gz"))
    return filename

def clear_directory(path) -> None:
    clean_me = Path(path).resolve()
    for root, dirs, files in clean_me.walk(top_down=False):
        for f in files:
            Path(os.path.join(root, f)).unlink()
        for d in dirs:
            Path(os.path.join(root, d)).rmdir()

def clear_cache():
    p_cache = Path(xlcache_dir).resolve()
    p_root = Path(Path(xlcache_dir).root)
    p_home = Path(home).resolve()
    if (p_cache == p_root or p_cache == p_home):
        print(f"Cache directory is set to {p_root} or {p_home}. Not deleting.")
    if (not p_cache.is_dir()):
        print(f"Cache directory {p_cache} is not a directory. Not deleting.")
    
    if p_cache.exists():
        print(f"Removing {p_cache}")
        clear_directory(p_cache)
        

xlcore_tgz = download_xlcore()
aria2_tgz = download_aria2()
p_local = Path(localdir).mkdir(exist_ok=True)
shutil.unpack_archive(xlcore_tgz, p_local)
shutil.unpack_archive(aria2_tgz, p_local)


