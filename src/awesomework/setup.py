from setuptools import setup, find_packages
import os

setup_dir = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(setup_dir, 'requirements.txt'), 'r') as req_file:
    requirements = [line.strip() for line in req_file if line.strip()]

setup(name='AwesomePackage',
      version='1.1.0',
      description='YaP test',
      url='',
      author='Fedor Mushenok',
      author_email='fedor.mushenok@philips.com',
      include_package_data=True,
      packages=find_packages(),
      install_requires=requirements,
      entry_points={'console_scripts': ['inference=awesomework.inference:main',
                                        'train=awesomework.train:main']}
      )
