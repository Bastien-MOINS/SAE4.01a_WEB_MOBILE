from .app import app, db
from .models import Compagnie

@app.cli.command()
def syncdb():
    db.drop_all()
    db.create_all()
    c1 = Compagnie("Air France")
    c2 = Compagnie("Lufthansa")
    c3 = Compagnie("EasyJet")
    
    db.session.add(c1)
    db.session.add(c2)
    db.session.add(c3)
    db.session.commit()