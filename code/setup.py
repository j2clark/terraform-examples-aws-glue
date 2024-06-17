from setuptools import setup

setup(
    name="pyshell-framework",
    version="1.0",
    author='Jamie Clark',
    author_email='jamie@j2clark.net',
    package_dir={'': 'src'},
    packages=[
        'pyshell'
    ],
    install_requires=[
        # TODO: add packages locally to ensure a fixed known environment
        'watchtower==3.0.1',
        'pendulum==2.1.2',
        'pandas==2.2.1',
        # 'python-dateutil>=2.8.2',
        # 'tzdata>=2022.7',
        # 'pytz>=2020.1',
        # 'numpy<2,>=1.22.4',
        # 'pytzdata>=2020.1',
        # 'boto3<2,>=1.9.253',
        # 'jmespath<2.0.0,>=0.7.1',
        # 's3transfer<0.11.0,>=0.10.0',
        # 'botocore<1.35.0,>=1.34.127',
        # 'six>=1.5',
        # 'urllib3<1.27,>=1.25.4'
    ],
    classifiers=[
        # complete classifier list: http://pypi.python.org/pypi?%3Aaction=list_classifiers
        'Operating System :: Unix',
        'Operating System :: POSIX',
        'Operating System :: Microsoft :: Windows',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3.9'
    ]
)
