from webdriver_manager.chrome import ChromeDriverManager
from functions.custom_functions import screenshots_path
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from functions.custom_functions import savefile_path
from functions.custom_functions import args_parser
from functions.custom_functions import user_rights
from selenium import webdriver
import time
import os



print(args_parser())

options = Options()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-gpu')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--disable-setuid-sandbox')

browser = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
# browser = webdriver.Chrome(ChromeDriverManager().install(), options=options)

browser.get('https://2ip.ru')

############################################
############# SCREENSHOTS TEST #############
############################################

screenshot = screenshots_path('screenshot')
browser.save_screenshot(screenshot)
user_rights(screenshot)

time.sleep(1)
browser.close()
