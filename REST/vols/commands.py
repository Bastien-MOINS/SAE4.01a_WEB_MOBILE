from .app import app, db
from .models import Compagnie, Aeroport, Vol, Terminal
from datetime import date, timedelta, time

@app.cli.command()
def syncdb():
    """Remplir la base de données avec des données de test."""
    db.drop_all()
    db.create_all()
    
    # --- 1. Créer les compagnies ---
    air_france = Compagnie('Air France')
    lufthansa = Compagnie('Lufthansa')
    ryanair = Compagnie('Ryanair')
    
    db.session.add_all([air_france, lufthansa, ryanair])
    db.session.commit()
    
    # --- 2. Créer les aéroports ---
    cdg = Aeroport('Charles de Gaulle', 'Paris', 'France', 49.0097, 2.5479)
    orly = Aeroport('Orly', 'Paris', 'France', 48.7262, 2.3652)
    lyon = Aeroport('Lyon Saint-Exupéry', 'Lyon', 'France', 45.7256, 5.0811)
    nice = Aeroport('Nice Côte d\'Azur', 'Nice', 'France', 43.6653, 7.2150)
    frankfurt = Aeroport('Frankfurt', 'Frankfurt', 'Allemagne', 50.0333, 8.5706)
    berlin = Aeroport('Berlin Brandenburg', 'Berlin', 'Allemagne', 52.3667, 13.5033)
    
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
        ),
        Vol(numero_vol=1006, date_debut=aujourd_hui, heure_debut=time(6, 30), date_arrivee=aujourd_hui, heure_arrivee=time(8, 0), id_compagnie=ryanair.id_compagnie, numero_aeroport_dep=lyon.numero_aeroport, id_terminal_dep=t_lyon.id_terminal, numero_aeroport_arr=berlin.numero_aeroport, id_terminal_arr=t_berlin.id_terminal),
        Vol(numero_vol=1007, date_debut=aujourd_hui, heure_debut=time(7, 15), date_arrivee=aujourd_hui, heure_arrivee=time(8, 45), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=nice.numero_aeroport, id_terminal_dep=t_nice.id_terminal, numero_aeroport_arr=cdg.numero_aeroport, id_terminal_arr=t2_cdg.id_terminal),
        Vol(numero_vol=1008, date_debut=aujourd_hui, heure_debut=time(9, 45), date_arrivee=aujourd_hui, heure_arrivee=time(11, 20), id_compagnie=lufthansa.id_compagnie, numero_aeroport_dep=frankfurt.numero_aeroport, id_terminal_dep=t_frank.id_terminal, numero_aeroport_arr=orly.numero_aeroport, id_terminal_arr=t_orly.id_terminal),
        Vol(numero_vol=1009, date_debut=aujourd_hui, heure_debut=time(11, 0), date_arrivee=aujourd_hui, heure_arrivee=time(12, 30), id_compagnie=ryanair.id_compagnie, numero_aeroport_dep=berlin.numero_aeroport, id_terminal_dep=t_berlin.id_terminal, numero_aeroport_arr=nice.numero_aeroport, id_terminal_arr=t_nice.id_terminal),
        Vol(numero_vol=1010, date_debut=aujourd_hui, heure_debut=time(13, 15), date_arrivee=aujourd_hui, heure_arrivee=time(14, 45), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=cdg.numero_aeroport, id_terminal_dep=t1_cdg.id_terminal, numero_aeroport_arr=frankfurt.numero_aeroport, id_terminal_arr=t_frank.id_terminal),
        Vol(numero_vol=1011, date_debut=aujourd_hui, heure_debut=time(15, 30), date_arrivee=aujourd_hui, heure_arrivee=time(17, 0), id_compagnie=lufthansa.id_compagnie, numero_aeroport_dep=lyon.numero_aeroport, id_terminal_dep=t_lyon.id_terminal, numero_aeroport_arr=cdg.numero_aeroport, id_terminal_arr=t2_cdg.id_terminal),
        Vol(numero_vol=1012, date_debut=aujourd_hui, heure_debut=time(16, 45), date_arrivee=aujourd_hui, heure_arrivee=time(18, 15), id_compagnie=ryanair.id_compagnie, numero_aeroport_dep=nice.numero_aeroport, id_terminal_dep=t_nice.id_terminal, numero_aeroport_arr=lyon.numero_aeroport, id_terminal_arr=t_lyon.id_terminal),
        Vol(numero_vol=1013, date_debut=aujourd_hui, heure_debut=time(18, 0), date_arrivee=aujourd_hui, heure_arrivee=time(19, 30), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=orly.numero_aeroport, id_terminal_dep=t_orly.id_terminal, numero_aeroport_arr=berlin.numero_aeroport, id_terminal_arr=t_berlin.id_terminal),
        Vol(numero_vol=1014, date_debut=aujourd_hui, heure_debut=time(19, 15), date_arrivee=aujourd_hui, heure_arrivee=time(20, 50), id_compagnie=lufthansa.id_compagnie, numero_aeroport_dep=frankfurt.numero_aeroport, id_terminal_dep=t_frank.id_terminal, numero_aeroport_arr=lyon.numero_aeroport, id_terminal_arr=t_lyon.id_terminal),
        Vol(numero_vol=1015, date_debut=aujourd_hui, heure_debut=time(20, 30), date_arrivee=aujourd_hui, heure_arrivee=time(22, 0), id_compagnie=ryanair.id_compagnie, numero_aeroport_dep=berlin.numero_aeroport, id_terminal_dep=t_berlin.id_terminal, numero_aeroport_arr=orly.numero_aeroport, id_terminal_arr=t_orly.id_terminal),
        Vol(numero_vol=1016, date_debut=demain, heure_debut=time(6, 0), date_arrivee=demain, heure_arrivee=time(7, 30), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=cdg.numero_aeroport, id_terminal_dep=t2_cdg.id_terminal, numero_aeroport_arr=nice.numero_aeroport, id_terminal_arr=t_nice.id_terminal),
        Vol(numero_vol=1017, date_debut=demain, heure_debut=time(7, 45), date_arrivee=demain, heure_arrivee=time(9, 20), id_compagnie=lufthansa.id_compagnie, numero_aeroport_dep=lyon.numero_aeroport, id_terminal_dep=t_lyon.id_terminal, numero_aeroport_arr=frankfurt.numero_aeroport, id_terminal_arr=t_frank.id_terminal),
        Vol(numero_vol=1018, date_debut=demain, heure_debut=time(8, 30), date_arrivee=demain, heure_arrivee=time(10, 0), id_compagnie=ryanair.id_compagnie, numero_aeroport_dep=nice.numero_aeroport, id_terminal_dep=t_nice.id_terminal, numero_aeroport_arr=berlin.numero_aeroport, id_terminal_arr=t_berlin.id_terminal),
        Vol(numero_vol=1019, date_debut=demain, heure_debut=time(10, 15), date_arrivee=demain, heure_arrivee=time(11, 45), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=berlin.numero_aeroport, id_terminal_dep=t_berlin.id_terminal, numero_aeroport_arr=cdg.numero_aeroport, id_terminal_arr=t1_cdg.id_terminal),
        Vol(numero_vol=1020, date_debut=demain, heure_debut=time(11, 30), date_arrivee=demain, heure_arrivee=time(13, 0), id_compagnie=lufthansa.id_compagnie, numero_aeroport_dep=orly.numero_aeroport, id_terminal_dep=t_orly.id_terminal, numero_aeroport_arr=frankfurt.numero_aeroport, id_terminal_arr=t_frank.id_terminal),
        Vol(numero_vol=1021, date_debut=demain, heure_debut=time(13, 45), date_arrivee=demain, heure_arrivee=time(15, 15), id_compagnie=ryanair.id_compagnie, numero_aeroport_dep=cdg.numero_aeroport, id_terminal_dep=t1_cdg.id_terminal, numero_aeroport_arr=lyon.numero_aeroport, id_terminal_arr=t_lyon.id_terminal),
        Vol(numero_vol=1022, date_debut=demain, heure_debut=time(15, 0), date_arrivee=demain, heure_arrivee=time(16, 30), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=lyon.numero_aeroport, id_terminal_dep=t_lyon.id_terminal, numero_aeroport_arr=nice.numero_aeroport, id_terminal_arr=t_nice.id_terminal),
        Vol(numero_vol=1023, date_debut=demain, heure_debut=time(16, 20), date_arrivee=demain, heure_arrivee=time(17, 50), id_compagnie=lufthansa.id_compagnie, numero_aeroport_dep=frankfurt.numero_aeroport, id_terminal_dep=t_frank.id_terminal, numero_aeroport_arr=cdg.numero_aeroport, id_terminal_arr=t2_cdg.id_terminal),
        Vol(numero_vol=1024, date_debut=demain, heure_debut=time(17, 30), date_arrivee=demain, heure_arrivee=time(19, 0), id_compagnie=ryanair.id_compagnie, numero_aeroport_dep=nice.numero_aeroport, id_terminal_dep=t_nice.id_terminal, numero_aeroport_arr=orly.numero_aeroport, id_terminal_arr=t_orly.id_terminal),
        Vol(numero_vol=1025, date_debut=demain, heure_debut=time(19, 45), date_arrivee=demain, heure_arrivee=time(21, 15), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=berlin.numero_aeroport, id_terminal_dep=t_berlin.id_terminal, numero_aeroport_arr=lyon.numero_aeroport, id_terminal_arr=t_lyon.id_terminal)
    ]
    
    db.session.add_all(vols)
    db.session.commit()

    # --- 5. Ajouter des vols pour les deux prochaines semaines ---
    import random
    
    compagnies = [air_france, lufthansa, ryanair]
    aeroports = [cdg, orly, lyon, nice, frankfurt, berlin]
    terminaux = {
        cdg.numero_aeroport: [t1_cdg, t2_cdg],
        orly.numero_aeroport: [t_orly],
        lyon.numero_aeroport: [t_lyon],
        nice.numero_aeroport: [t_nice],
        frankfurt.numero_aeroport: [t_frank],
        berlin.numero_aeroport: [t_berlin]
    }
    
    vols_futurs = []
    
    for i in range(2, 16): # De dans 2 jours à dans 15 jours
        date_vol = aujourd_hui + timedelta(days=i)
        
        # 5 vols par jour
        for j in range(5):
            compagnie = random.choice(compagnies)
            aero_dep = random.choice(aeroports)
            aero_arr = random.choice([a for a in aeroports if a.numero_aeroport != aero_dep.numero_aeroport])
            
            term_dep = random.choice(terminaux[aero_dep.numero_aeroport])
            term_arr = random.choice(terminaux[aero_arr.numero_aeroport])
            
            heure = random.randint(6, 21)
            minute = random.choice([0, 15, 30, 45])
            
            duree_heures = random.randint(1, 2)
            duree_minutes = random.choice([0, 30])
            
            heure_arr = heure + duree_heures
            minute_arr = minute + duree_minutes
            if minute_arr >= 60:
                heure_arr += 1
                minute_arr -= 60
                
            vol = Vol(
                date_debut=date_vol,
                heure_debut=time(heure, minute),
                date_arrivee=date_vol,
                heure_arrivee=time(heure_arr, minute_arr),
                id_compagnie=compagnie.id_compagnie,
                numero_aeroport_dep=aero_dep.numero_aeroport,
                id_terminal_dep=term_dep.id_terminal,
                numero_aeroport_arr=aero_arr.numero_aeroport,
                id_terminal_arr=term_arr.id_terminal
            )
            vols_futurs.append(vol)
    
    db.session.add_all(vols_futurs)
    db.session.commit()

    # --- 6. Ajouter des vols spécifiques entre le 25 mars et le 1er avril ---
    vols_speciaux = [
        Vol(numero_vol=2001, date_debut=date(2026, 3, 25), heure_debut=time(8, 0), date_arrivee=date(2026, 3, 25), heure_arrivee=time(10, 0), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=cdg.numero_aeroport, id_terminal_dep=t1_cdg.id_terminal, numero_aeroport_arr=lyon.numero_aeroport, id_terminal_arr=t_lyon.id_terminal),
        Vol(numero_vol=2002, date_debut=date(2026, 3, 26), heure_debut=time(11, 0), date_arrivee=date(2026, 3, 26), heure_arrivee=time(13, 0), id_compagnie=lufthansa.id_compagnie, numero_aeroport_dep=frankfurt.numero_aeroport, id_terminal_dep=t_frank.id_terminal, numero_aeroport_arr=orly.numero_aeroport, id_terminal_arr=t_orly.id_terminal),
        Vol(numero_vol=2003, date_debut=date(2026, 3, 27), heure_debut=time(14, 30), date_arrivee=date(2026, 3, 27), heure_arrivee=time(16, 0), id_compagnie=ryanair.id_compagnie, numero_aeroport_dep=nice.numero_aeroport, id_terminal_dep=t_nice.id_terminal, numero_aeroport_arr=berlin.numero_aeroport, id_terminal_arr=t_berlin.id_terminal),
        Vol(numero_vol=2004, date_debut=date(2026, 3, 28), heure_debut=time(9, 15), date_arrivee=date(2026, 3, 28), heure_arrivee=time(11, 15), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=lyon.numero_aeroport, id_terminal_dep=t_lyon.id_terminal, numero_aeroport_arr=cdg.numero_aeroport, id_terminal_arr=t2_cdg.id_terminal),
        Vol(numero_vol=2005, date_debut=date(2026, 3, 29), heure_debut=time(17, 45), date_arrivee=date(2026, 3, 29), heure_arrivee=time(19, 30), id_compagnie=lufthansa.id_compagnie, numero_aeroport_dep=berlin.numero_aeroport, id_terminal_dep=t_berlin.id_terminal, numero_aeroport_arr=frankfurt.numero_aeroport, id_terminal_arr=t_frank.id_terminal),
        Vol(numero_vol=2006, date_debut=date(2026, 3, 30), heure_debut=time(10, 0), date_arrivee=date(2026, 3, 30), heure_arrivee=time(11, 30), id_compagnie=ryanair.id_compagnie, numero_aeroport_dep=orly.numero_aeroport, id_terminal_dep=t_orly.id_terminal, numero_aeroport_arr=nice.numero_aeroport, id_terminal_arr=t_nice.id_terminal),
        Vol(numero_vol=2007, date_debut=date(2026, 3, 31), heure_debut=time(15, 20), date_arrivee=date(2026, 3, 31), heure_arrivee=time(17, 0), id_compagnie=air_france.id_compagnie, numero_aeroport_dep=cdg.numero_aeroport, id_terminal_dep=t1_cdg.id_terminal, numero_aeroport_arr=berlin.numero_aeroport, id_terminal_arr=t_berlin.id_terminal),
        Vol(numero_vol=2008, date_debut=date(2026, 4, 1), heure_debut=time(12, 10), date_arrivee=date(2026, 4, 1), heure_arrivee=time(14, 0), id_compagnie=lufthansa.id_compagnie, numero_aeroport_dep=frankfurt.numero_aeroport, id_terminal_dep=t_frank.id_terminal, numero_aeroport_arr=lyon.numero_aeroport, id_terminal_arr=t_lyon.id_terminal),
    ]
    
    db.session.add_all(vols_speciaux)
    db.session.commit()

    print("✓ Base de données remplie avec succès !")
    print(f"  - {Compagnie.query.count()} compagnies")
    print(f"  - {Aeroport.query.count()} aéroports")
    print(f"  - {Terminal.query.count()} terminaux")
    print(f"  - {Vol.query.count()} vols")