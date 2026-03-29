import os
import shutil
from flask import Flask, request
from .extensions import api, db
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

db_path = os.path.join(os.path.abspath(os.path.dirname(__file__)), '..', 'instance', 'db.sqlite3')
app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///file:{db_path}?uri=true&nolock=1"

def copy_db_to_mobile():
    mobile_assets_dir = os.path.join(os.path.abspath(os.path.dirname(__file__)), '..', '..', 'App_Mobile', 'assets')
    os.makedirs(mobile_assets_dir, exist_ok=True)
    dest_path = os.path.join(mobile_assets_dir, 'db.sqlite3')
    if os.path.exists(db_path):
        try:
            shutil.copy2(db_path, dest_path)
        except Exception as e:
            print(f"Erreur lors de la copie de la DB: {e}")

# Copie au démarrage de l'application
copy_db_to_mobile()

# Copie après chaque requête qui potentiellement modifie les données
@app.after_request
def after_request_func(response):
    if request.method in ['POST', 'PUT', 'DELETE']:
        copy_db_to_mobile()
    return response

api.init_app(app)
db.init_app(app)