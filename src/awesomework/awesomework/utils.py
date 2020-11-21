from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split


def get_data(test_sample=False):
    """
    Return train subset
    :return:
    """
    dataset = load_boston()
    x_train, x_test, y_train, y_test = train_test_split(dataset.get('data'), dataset.get('target'),
                                                        random_state=1, train_size=0.8)
    if test_sample:
        return x_test, y_test
    else:
        return x_train, y_train


