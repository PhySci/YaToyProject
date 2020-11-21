python -m virtualenv --no-site-packages env
CALL .\env\Scripts\activate.bat

pip install --trusted-host=pypi.python.org --trusted-host=pypi.org --trusted-host=files.pythonhosted.org --proxy=185.46.212.97:10015 -r wizard\requirements.txt

CALL .\env\Scripts\deactivate.bat