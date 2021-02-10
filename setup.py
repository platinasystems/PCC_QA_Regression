from setuptools import setup, find_packages
from os.path import abspath, dirname, join

PROJECT_NAME = "aa"
LICENSE = 'MIT'
SOURCE_DIR = join("src", PROJECT_NAME)
PROJECT_GIT_URL = "https://github.com/platinasystems/" + PROJECT_NAME
AUTHOR_NAME = "mplatina"
AUTHOR_EMAIL = "mplatina@platinasystems.com"
DESCRIPTION = "Robot Framework Library"
KEYWORDS = [PROJECT_NAME]
CLASSIFIERS = '''
Programming Language :: Python :: 3
Framework :: Robot Framework
'''.strip().splitlines()

REQUIREMENTS = [
    'robotframework',
    'selenium',
    'fabric',
    'distro',
    'datetime',
    'requests >= 2.21',
    'urllib3 >= 1.24'
    ]

CURRENT_DIR = dirname(abspath(__file__))
with open(join(CURRENT_DIR, SOURCE_DIR, '__init__.py')) as init_py:
    for line in init_py:
        if line.startswith("__version__"):
            VERSION = line.strip().split("=")[1].strip(" '\"")
            break
        else:
            VERSION = "1.0.0"
DOWNLOAD_URL = PROJECT_GIT_URL + "/archive/master.zip"

setup(
    name = PROJECT_NAME,
    package_dir={'': 'src'},
    packages= find_packages(where="src"),
    scripts=[ 
        join(SOURCE_DIR, 'scripts', 'run-aa.sh')
        ],
    version = VERSION,
    license = LICENSE,
    author = AUTHOR_NAME,
    author_email = AUTHOR_EMAIL,
    description = DESCRIPTION,
    url = PROJECT_GIT_URL,
    download_url = DOWNLOAD_URL,
    keywords = KEYWORDS,
    install_requires = REQUIREMENTS,
    classifiers = CLASSIFIERS,
    data_files=[
        ('robot', ['src/' + PROJECT_NAME + "/robot/pcc_resources.robot"])
    ]
)
