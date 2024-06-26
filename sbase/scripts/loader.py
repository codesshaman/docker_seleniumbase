from seleniumbase import SB

with SB(uc=True, headless2=True) as sb:
    sb.open("https://pypi.org/project/sbvirtualdisplay/#files")
    sb.assert_element("span#pip-command")
    sb.assert_text("Download files", "div#files h2.page-title")
    sb.assert_text("Download files", "a#files-tab")
    pkg_header = sb.get_text("h1.package-header__name").strip()
    pkg_name = pkg_header.replace(" ", "-")
    whl_file = pkg_name + "-py2.py3-none-any.whl"
    tar_gz_file = pkg_name + ".tar.gz"

    # Click the links to download the files into: "./downloaded_files/"

    whl_selector = 'div#files a[href$="%s"]' % whl_file
    tar_selector = 'div#files a[href$="%s"]' % tar_gz_file

    sb.uc_click(whl_selector)  # Download the "whl" file
    sb.sleep(0.1)
    sb.uc_click(tar_selector)  # Download the "tar" file

    sb.sleep(2)

    sb.assert_downloaded_file(whl_file)
    sb.assert_downloaded_file(tar_gz_file)
    print("Successfully downloaded files!")
