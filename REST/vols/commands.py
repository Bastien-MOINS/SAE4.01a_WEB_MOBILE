from datetime import date, datetime
from .app import app, db
from .models import Compagnie, Aeroport, Vol, Terminal

@app.cli.command()
def syncdb():
    """Crée les tables et insère des données de test."""
    db.drop_all()
    db.create_all()

    # Compagnies
    af = Compagnie("Air France")
    ez = Compagnie("easyJet")
    db.session.add_all([af, ez])

    # Aéroports
    cdg = Aeroport("Paris CDG", "Paris", "France")
    nce = Aeroport("Air is Nice", "Nice", "France")
    lhr = Aeroport("Heathrow", "London", "UK")
    db.session.add_all([cdg, nce, lhr])
    db.session.flush()  # pour récupérer les ids

    # Terminaux
    terminaux = [
        Terminal(0,'A11'),
        Terminal(1,'B12'),
        Terminal(2,'E14')
    ]

    # Vols
    vols = [
        Vol(
            numero_vol=1001,
            date_debut=date(2024, 7, 1),
            heure_debut=datetime(2024, 7, 1, 9, 30),
            date_arrivee=date(2024, 7, 1),
            heure_arrivee=datetime(2024, 7, 1, 11, 5),
            id_compagnie=af.id_compagnie,
            numero_aeroport_dep=cdg.numero_aeroport,
            id_terminal_dep=0,
            numero_aeroport_arr=lhr.numero_aeroport,
            id_terminal_arr=2
        ),
        Vol(
            numero_vol=2002,
            date_debut=date(2024, 7, 2),
            heure_debut=datetime(2024, 7, 2, 14, 10),
            date_arrivee=date(2024, 7, 2),
            heure_arrivee=datetime(2024, 7, 2, 15, 25),
            id_compagnie=ez.id_compagnie,
            numero_aeroport_dep=lhr.numero_aeroport,
            id_terminal_dep=2,
            numero_aeroport_arr=nce.numero_aeroport,
            id_terminal_arr=1
        ),
    ]
    db.session.add_all(vols)
    db.session.commit()
    print("Base synchronisée et données de test insérées.")

@app.cli.command()
def cleardb():
    db.drop_all()
    db.create_all()
    print("Base synchronisée et vidée.")