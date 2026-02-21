from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os

def mkpath(p):
    return os.path.normpath (
        os.path.join (
            os.path.dirname(__file__),p)
    )
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = ('sqlite:///'+mkpath('../vols.db'))
app.config["SQLALCHEMY_ECHO"] = True
db = SQLAlchemy(app)
