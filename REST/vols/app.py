import os
from flask import Flask
from .extensions import api, db
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

db_path = os.path.join(os.path.abspath(os.path.dirname(__file__)), '..', 'instance', 'db.sqlite3')
app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///file:{db_path}?uri=true&nolock=1"
api.init_app(app)
db.init_app(app)