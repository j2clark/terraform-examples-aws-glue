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
        'watchtower==3.0.1',
        'pendulum==2.1.2',
        'pandas==2.2.1',
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
