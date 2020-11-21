"""

"""
import os
from joblib import load


def main(x):
    model = load(os.path.join(os.path.dirname(__file__), './models/boston_model.jbl'))
    y_pr = model.predict(x)
    return y_pr


if __name__=='__main__':
    main()