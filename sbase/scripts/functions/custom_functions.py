import subprocess
import os

uid = os.getenv('USER_ID')
gid = os.getenv('GRUP_ID')

def args_parser():
    arg = os.getenv('ARGUMENTS')
    argslist = arg.split()
    # print(argslist)

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
    # Меняем права
    # Пользователя
    uid = os.getenv('USER_ID')
    gid = os.getenv('GRUP_ID')
    command = f"chown {uid}:{gid} {filepath}"
    subprocess.run(command, shell=True, check=True)

def downloads_dir(filename):
    return '/SeleniumBase/sbase/scripts/downloaded_files' + str(filename)

def screenshots_dir(filename):
    return '/SeleniumBase/sbase/screenshots' + str(filename) + '.png'

def scipts_dir():
    return '/SeleniumBase/sbase/scipts'

def download_file(filename):
    file_path = downloads_dir(filename)
    
    user_rights(file_path)
    print("Файл '" + str(file_path) + "' успешно загружен!")