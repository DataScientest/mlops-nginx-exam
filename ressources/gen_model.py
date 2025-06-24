import os
import joblib
import pandas as pd

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.model_selection import train_test_split

DATA_PATH = "./tweet_emotions.csv"
MODEL_PATH = "../app/model.joblib"

# Chargement des données
try:
    df = pd.read_csv(DATA_PATH)
except FileNotFoundError:
    raise RuntimeError(f"Data file not found at {DATA_PATH}.")
except Exception as e:
    raise RuntimeError(f"Error loading data: {e}")

df.dropna(inplace=True)
X = df['content']
y = df['sentiment']

pipeline = Pipeline([
    ('tfidf', TfidfVectorizer(max_features=5000)), 
    ('clf', LogisticRegression(max_iter=1000)) 
])
pipeline.fit(X, y)

try:
    joblib.dump(pipeline, MODEL_PATH)
    print(f"Model saved successfully at {MODEL_PATH}")
except Exception as e:
    raise RuntimeError(f"Error saving model: {e}")
