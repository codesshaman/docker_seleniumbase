import subprocess
import datetime
import shutil
import pytz
import re
import os


server_timezone = pytz.timezone('Europe/Moscow')
time_now = datetime.datetime.now(server_timezone)
time_now = str(time_now)
time_now = re.sub(r' ', '_', time_now)

def args_parser():
    arg = os.getenv('ARGUMENTS')
    argslist = arg.split()

    result_dict = {}
    result_list = []

    for item in argslist:
        if ':' in item:
            key, value = item.split(':')
            result_dict[key] = value
        else:
            result_list.append(item)
    print(result_dict)
    print(result_list)
    return {"result_dict":result_dict, "result_list":result_list}

def user_rights(filepath):
    uid = os.getenv('USER_ID')
    gid = os.getenv('GRUP_ID')
    command = f"chown {uid}:{gid} {filepath}"
    subprocess.run(command, shell=True, check=True)

def screenshots_path(filename):
    return '/SeleniumBase/sbase/screenshots/' + str(filename) + '_' +str(time_now) + '.png'

def savefile_path(filename, extension):
    return '/SeleniumBase/sbase/downloads/' + str(filename) + '_' +str(time_now) + '.' + str(extension)

def delete_lock_file(lock_file):
    lock_file_path = os.path.join(lock_file)
    if os.path.exists(lock_file_path):
        os.remove(lock_file_path)
        print(f"File {lock_file_path} has been deleted.")
    else:
        print(f"File {lock_file_path} does not exist.")

def rename_files(folder_path):
    client_timezone = 'Europe/Moscow'
    client_tz = pytz.timezone(client_timezone)
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            new_filename = f"{time_now}_{filename}"
            os.rename(file_path, os.path.join(folder_path, new_filename))

def change_files_owner(directory):
    uid = 1000
    gid = 1000
    for root, dirs, files in os.walk(directory):
        for d in dirs:
            dir_path = os.path.join(root, d)
            print(f"Changing owner of directory {dir_path} to {uid}:{gid}")
            os.chown(dir_path, uid, gid)
        for f in files:
            file_path = os.path.join(root, f)
            print(f"Changing owner of file {file_path} to {uid}:{gid}")
            os.chown(file_path, uid, gid)

def move_files(source_folder, dest_folder):
    for file_name in os.listdir(source_folder):
        source_file = os.path.join(source_folder, file_name)
        dest_file = os.path.join(dest_folder, file_name)
        shutil.move(source_file, dest_file)
        print(f"File '{file_name}' has been moved to {dest_folder}.")

def downloads_path():
    delete_lock_file('/downloaded_files/driver_fixing.lock')
    rename_files('/downloaded_files')
    change_files_owner('/downloaded_files')
    move_files('/downloaded_files', '/SeleniumBase/sbase/downloads')
