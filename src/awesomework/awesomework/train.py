"""

"""
from awesomework.utils import get_data
import os
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split, KFold, cross_val_score
from sklearn.metrics import mean_squared_error, r2_score
from matplotlib import pyplot as plt
from joblib import load, dump


def main():

    print('Here we are!')
    x, y = get_data()
    baseline_model = RandomForestRegressor(random_state=3)

    x_train, x_val, y_train, y_val = train_test_split(x, y, random_state=1, train_size=0.8)

    baseline_model.fit(x_train, y_train)
    y_pr = baseline_model.predict(x_val)
    score = mean_squared_error(y_val, y_pr)
    print(score)

    show_results(y_val, y_pr)

    dump(baseline_model, os.path.join(os.path.dirname(__file__), './models/boston_model.jbl'))

def show_results(y_true, y_pr):
    """
    Show scatter plot and residuals

    :param y_true:
    :param y_pr:
    :return:
    """
    plt.figure(figsize=[15, 7])
    plt.subplot(121)
    plt.scatter(y_pr, y_true)
    plt.xlabel('True value')
    plt.ylabel('Predicted value')
    plt.xlim([0, 55])
    plt.ylim([0, 55])
    plt.plot([0, 55], [0, 55], '-r')

    plt.subplot(122)
    plt.scatter(y_true, y_pr - y_true)
    plt.xlabel('True value')
    plt.ylabel('Residuals')
    plt.xlim([0, 50])
    plt.ylim([-20, 20])
    plt.show()

    r2 = r2_score(y_true, y_pr)
    print('r2 score is ', r2)


if __name__ == '__main__':
    main()

