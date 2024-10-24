# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "bs4",
#     "requests",
#     "rich",
# ]
# ///

import json, subprocess

ONLINE = False
PACKAGE_INFO_URL = "https://build.deepin.com/project/monitor/deepin:Develop:community?arch_riscv64=1&defaults=0&repo_deepin_develop=1&unresolvable=1"
PACKAGE_REPO_URL = "https://github.com/deepin-community/{}"
PACKAGE_KEYS = ['package', 'code', 'details']

import rich, requests # type: ignore
from bs4 import BeautifulSoup # type: ignore

def isUnresolvable(package_name: str) -> bool:
    subprocess.run(["/bin/bash", "verify_repo.sh", str])

if ONLINE:
    r = requests.get(PACKAGE_INFO_URL)
    package_info = r.text
else:
    with open('package.txt', 'r', encoding='utf-8') as file:
        package_info = file.read()

soup = BeautifulSoup(package_info, 'html.parser')

tbody_tag = soup.find('tbody', attrs={'data-packagenames': True})
package_names_str: str = tbody_tag['data-packagenames']
package_status_str: str = tbody_tag['data-statushash']

package_names: list = json.loads(package_names_str)
package_status: dict = json.loads(package_status_str)['deepin_develop']['riscv64']

assert len(package_names)==len(package_status.keys())

YANKED = ['nothing provides vim-common = 2:9.1.0016-1 needed by vim, (got version 2:9.1.0496-1), nothing provides vim-runtime = 2:9.1.0016-1 needed by vim, (got version 2:9.1.0496-1)']

for name in package_names:
    package: dict = package_status[name]
    if package['details'] not in YANKED:
        print(package['package'], package['details'])