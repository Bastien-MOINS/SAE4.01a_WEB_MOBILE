from .app import app, db
from .models import Compagnie, Aeroport, Vol, Terminal
from datetime import date, timedelta, time
import os

@app.cli.command()
def syncdb():
    """Remplir la base de données avec des données de test."""

    os.makedirs(os.path.dirname(app.config["SQLALCHEMY_DATABASE_URI"].replace("sqlite:///file:", "").split("?")[0].replace("sqlite:///", "")), exist_ok=True)

    db.drop_all()
    db.create_all()
    
    # --- 1. Créer les compagnies ---
    air_france = Compagnie('Air France')
    lufthansa = Compagnie('Lufthansa')
    ryanair = Compagnie('Ryanair')
    trvhre = Compagnie('Ryanair')
    ecgwrgec = Compagnie('Ryanair')
    ccgwcg = Compagnie('Ryanair')
    wcrgvwwv = Compagnie('Ryanair')
    cvgrgvw = Compagnie('Ryanair')
    jbyrbjyj = Compagnie('Ryanair')
    bjtvwevh = Compagnie('Ryanair')
    jybtb = Compagnie('Ryanair')
    vhgwvh = Compagnie('Ryanair')
    rytyyt = Compagnie('Ryanair')
    
    db.session.add_all([air_france, lufthansa, ryanair, trvhre, ecgwrgec, ccgwcg, wcrgvwwv, cvgrgvw, jbyrbjyj, bjtvwevh, jybtb, vhgwvh, rytyyt])
    db.session.commit()
    
    # --- 2. Créer les aéroports ---
    cdg = Aeroport('Charles de Gaulle', 'Paris', 'France')
    orly = Aeroport('Orly', 'Paris', 'France')
    lyon = Aeroport('Lyon Saint-Exupéry', 'Lyon', 'France')
    nice = Aeroport('Nice Côte d\'Azur', 'Nice', 'France')
    frankfurt = Aeroport('Frankfurt', 'Frankfurt', 'Allemagne')
    berlin = Aeroport('Berlin Brandenburg', 'Berlin', 'Allemagne')
    
    db.session.add_all([cdg, orly, lyon, nice, frankfurt, berlin])
    db.session.commit()

    # --- 3. Créer les Terminaux ---
    # On crée d'abord les terminaux car les vols en ont besoin
    t1_cdg = Terminal(numero_aeroport=cdg.numero_aeroport, nom_terminal="Terminal 2E")
    t2_cdg = Terminal(numero_aeroport=cdg.numero_aeroport, nom_terminal="Terminal 2F")
    t_lyon = Terminal(numero_aeroport=lyon.numero_aeroport, nom_terminal="Terminal 1")
    t_orly = Terminal(numero_aeroport=orly.numero_aeroport, nom_terminal="Orly 4")
    t_nice = Terminal(numero_aeroport=nice.numero_aeroport, nom_terminal="Terminal 2")
    t_frank = Terminal(numero_aeroport=frankfurt.numero_aeroport, nom_terminal="Terminal A")
    t_berlin = Terminal(numero_aeroport=berlin.numero_aeroport, nom_terminal="Main Hall")

    db.session.add_all([t1_cdg, t2_cdg, t_lyon, t_orly, t_nice, t_frank, t_berlin])
    db.session.commit()
    
    # --- 4. Créer les vols ---
    aujourd_hui = date.today()
    demain = aujourd_hui + timedelta(days=1)
    
    vols = [
        Vol(
            numero_vol=1001,
            date_debut=aujourd_hui,
            heure_debut=time(8, 0),
            date_arrivee=aujourd_hui,
            heure_arrivee=time(10, 0),
            id_compagnie=air_france.id_compagnie,
            numero_aeroport_dep=cdg.numero_aeroport,
            id_terminal_dep=t1_cdg.id_terminal,
            numero_aeroport_arr=lyon.numero_aeroport,
            id_terminal_arr=t_lyon.id_terminal
        ),
        Vol(
            numero_vol=1002,
            date_debut=aujourd_hui,
            heure_debut=time(10, 30),
            date_arrivee=aujourd_hui,
            heure_arrivee=time(12, 30),
            id_compagnie=lufthansa.id_compagnie,
            numero_aeroport_dep=cdg.numero_aeroport,
            id_terminal_dep=t2_cdg.id_terminal,
            numero_aeroport_arr=frankfurt.numero_aeroport,
            id_terminal_arr=t_frank.id_terminal
        ),
        Vol(
            numero_vol=1003,
            date_debut=demain,
            heure_debut=time(14, 0),
            date_arrivee=demain,
            heure_arrivee=time(16, 0),
            id_compagnie=ryanair.id_compagnie,
            numero_aeroport_dep=orly.numero_aeroport,
            id_terminal_dep=t_orly.id_terminal,
            numero_aeroport_arr=nice.numero_aeroport,
            id_terminal_arr=t_nice.id_terminal
        ),
        Vol(
            numero_vol=1004,
            date_debut=demain,
            heure_debut=time(9, 0),
            date_arrivee=demain,
            heure_arrivee=time(11, 0),
            id_compagnie=air_france.id_compagnie,
            numero_aeroport_dep=cdg.numero_aeroport,
            id_terminal_dep=t1_cdg.id_terminal,
            numero_aeroport_arr=berlin.numero_aeroport,
            id_terminal_arr=t_berlin.id_terminal
        ),
        Vol(
            numero_vol=1005,
            date_debut=demain,
            heure_debut=time(12, 12),
            date_arrivee=demain,
            heure_arrivee=time(13, 0),
            id_compagnie=lufthansa.id_compagnie,
            numero_aeroport_dep=orly.numero_aeroport,
            id_terminal_dep=t_orly.id_terminal,
            numero_aeroport_arr=lyon.numero_aeroport,
            id_terminal_arr=t_lyon.id_terminal
        )
    ]
    
    db.session.add_all(vols)
    db.session.commit()
    
    print("✓ Base de données remplie avec succès !")
    print(f"  - {Compagnie.query.count()} compagnies")
    print(f"  - {Aeroport.query.count()} aéroports")
    print(f"  - {Terminal.query.count()} terminaux")
    print(f"  - {Vol.query.count()} vols")
