from setuptools import setup, find_packages

setup(
    name='CyberProbe',
    version='1.0.0',
    author='Wil Dennison',
    author_email='runnind3ad@gmail.com',
    description='A tool for penetration testing',
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
    install_requires=[], # Add your dependencies here
    
        
    classifiers=[
        'Programming Language :: Python :: 3',
        'Programming Language :: Bash',
        'License :: OSI Approved :: MIT License',
        'Operating System :: Linux and Windows',
    ],
    python_requires='>=3.6',
)

# To install the package, run:
# python setup.py install
# or
# pip install .
# To uninstall the package, run:
# pip uninstall CyberProbe 


