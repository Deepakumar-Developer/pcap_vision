from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
(CORS(app)

 @app.route('/home'))
def home():
    return "This is the home page"