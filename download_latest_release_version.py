import pathlib
import requests

release_zip_download_url = None

resp = requests.get("https://gitee.com/api/v5/repos/Discuz/DiscuzX/releases/latest")
for asset in resp.json()["assets"]:
    if ".zip" in asset.get("name", ""):
        release_zip_download_url = asset["browser_download_url"]
        break

release_zip_resp = requests.get(release_zip_download_url)
pathlib.Path("DiscuzX.zip").write_bytes(release_zip_resp.content)
