from .app import app, db
from .models import Compagnie, Aeroport, Vol, Terminal
from datetime import datetime, date, timedelta

@app.cli.command()
def syncdb():
    """Remplir la base de données avec des données de test."""
    db.drop_all()
    db.create_all()
    
    # Créer les compagnies
    air_france = Compagnie('Air France')
    lufthansa = Compagnie('Lufthansa')
    ryanair = Compagnie('Ryanair')
    
    db.session.add(air_france)
    db.session.add(lufthansa)
    db.session.add(ryanair)
    db.session.commit()
    
    # Créer les aéroports
    cdg = Aeroport('Charles de Gaulle', 'Paris', 'France')
    orly = Aeroport('Orly', 'Paris', 'France')
    lyon = Aeroport('Lyon Bole', 'Lyon', 'France')
    nice = Aeroport('Nice Côte d\'Azur', 'Nice', 'France')
    frankfurth = Aeroport('Frankfurt', 'Frankfurt', 'Allemagne')
    berlin = Aeroport('Berlin Brandenburg', 'Berlin', 'Allemagne')
    
    db.session.add_all([cdg, orly, lyon, nice, frankfurth, berlin])
    db.session.commit()
    
    # Créer les vols
    aujourd_hui = date.today()
    demain = aujourd_hui + timedelta(days=1)
    
    vol1 = Vol(
        numero_vol=1001,
        date_debut=aujourd_hui,
        heure_debut=datetime.combine(aujourd_hui, datetime.min.time()).replace(hour=8, minute=0),
        date_arrivee=aujourd_hui,
        heure_arrivee=datetime.combine(aujourd_hui, datetime.min.time()).replace(hour=10, minute=0),
        id_compagnie=air_france.id_compagnie,
        numero_aeroport_dep=cdg.numero_aeroport,
        numero_aeroport_arr=lyon.numero_aeroport
    )
    
    vol2 = Vol(
        numero_vol=1002,
        date_debut=aujourd_hui,
        heure_debut=datetime.combine(aujourd_hui, datetime.min.time()).replace(hour=10, minute=30),
        date_arrivee=aujourd_hui,
        heure_arrivee=datetime.combine(aujourd_hui, datetime.min.time()).replace(hour=12, minute=30),
        id_compagnie=lufthansa.id_compagnie,
        numero_aeroport_dep=cdg.numero_aeroport,
        numero_aeroport_arr=frankfurth.numero_aeroport
    )
    
    vol3 = Vol(
        numero_vol=1003,
        date_debut=demain,
        heure_debut=datetime.combine(demain, datetime.min.time()).replace(hour=14, minute=0),
        date_arrivee=demain,
        heure_arrivee=datetime.combine(demain, datetime.min.time()).replace(hour=16, minute=0),
        id_compagnie=ryanair.id_compagnie,
        numero_aeroport_dep=orly.numero_aeroport,
        numero_aeroport_arr=nice.numero_aeroport
    )
    
    vol4 = Vol(
        numero_vol=1004,
        date_debut=demain,
        heure_debut=datetime.combine(demain, datetime.min.time()).replace(hour=9, minute=0),
        date_arrivee=demain,
        heure_arrivee=datetime.combine(demain, datetime.min.time()).replace(hour=11, minute=0),
        id_compagnie=air_france.id_compagnie,
        numero_aeroport_dep=cdg.numero_aeroport,
        numero_aeroport_arr=berlin.numero_aeroport
    )
    
    db.session.add_all([vol1, vol2, vol3, vol4])
    db.session.commit()
    
    # Créer les terminaux
    terminals = [
        Terminal(numero_vol=1001, numero_aeroport=cdg.numero_aeroport, date_debut=aujourd_hui, 
                heure_debut=datetime.combine(aujourd_hui, datetime.min.time()).replace(hour=8, minute=0)),
        Terminal(numero_vol=1001, numero_aeroport=lyon.numero_aeroport, date_debut=aujourd_hui, 
                heure_debut=datetime.combine(aujourd_hui, datetime.min.time()).replace(hour=10, minute=0)),
        Terminal(numero_vol=1002, numero_aeroport=cdg.numero_aeroport, date_debut=aujourd_hui, 
                heure_debut=datetime.combine(aujourd_hui, datetime.min.time()).replace(hour=10, minute=30)),
        Terminal(numero_vol=1002, numero_aeroport=frankfurth.numero_aeroport, date_debut=aujourd_hui, 
                heure_debut=datetime.combine(aujourd_hui, datetime.min.time()).replace(hour=12, minute=30)),
        Terminal(numero_vol=1003, numero_aeroport=orly.numero_aeroport, date_debut=demain, 
                heure_debut=datetime.combine(demain, datetime.min.time()).replace(hour=14, minute=0)),
        Terminal(numero_vol=1003, numero_aeroport=nice.numero_aeroport, date_debut=demain, 
                heure_debut=datetime.combine(demain, datetime.min.time()).replace(hour=16, minute=0)),
        Terminal(numero_vol=1004, numero_aeroport=cdg.numero_aeroport, date_debut=demain, 
                heure_debut=datetime.combine(demain, datetime.min.time()).replace(hour=9, minute=0)),
        Terminal(numero_vol=1004, numero_aeroport=berlin.numero_aeroport, date_debut=demain, 
                heure_debut=datetime.combine(demain, datetime.min.time()).replace(hour=11, minute=0)),
    ]
    
    db.session.add_all(terminals)
    db.session.commit()
    
    print("✓ Base de données remplie avec succès!")
    print(f"  - {len([air_france, lufthansa, ryanair])} compagnies")
    print(f"  - {len([cdg, orly, lyon, nice, frankfurth, berlin])} aéroports")
    print(f"  - {len([vol1, vol2, vol3, vol4])} vols")
    print(f"  - {len(terminals)} terminaux")
