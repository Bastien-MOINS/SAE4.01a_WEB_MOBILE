from .app import app, db
from .models import Aeroport
@app.cli.command()
def syncdb():
    db.drop_all()
    db.create_all()
    aeroport1 = Aeroport(nom_aeroport="Charles De Gaulle", ville="Paris", pays="France")

    db.session.add(aeroport1)
    db.session.commit()