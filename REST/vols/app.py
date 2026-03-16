from flask import Flask
from .extensions import api, db
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"
api.init_app(app)
db.init_app(app)
