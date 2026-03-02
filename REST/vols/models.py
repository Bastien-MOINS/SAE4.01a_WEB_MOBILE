from .app import db

class Compagnie(db.Model):
    __tablename__ = 'COMPAGNIE'

    id_compagnie = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nom_compagnie = db.Column(db.String(38))
    vols = db.relationship('Vol', back_populates='compagnie')

    def __init__(self, nom_compagnie):
        self.nom_compagnie = nom_compagnie

    def to_json(self):
        return {
            'id_compagnie': self.id_compagnie,
            'nom_compagnie': self.nom_compagnie,
        }

class Aeroport(db.Model):
    __tablename__ = 'AEROPORT'

    numero_aeroport = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nom_aeroport = db.Column(db.String(38))
    ville = db.Column(db.String(38))
    pays = db.Column(db.String(38))

    def __init__(self, nom_aeroport, ville, pays):
        self.nom_aeroport = nom_aeroport
        self.ville = ville
        self.pays = pays

    def to_json(self):
        return {
            'numero_aeroport': self.numero_aeroport,
            'nom_aeroport': self.nom_aeroport,
            'ville': self.ville,
            'pays': self.pays
        }
    
class Vol(db.Model):
    __tablename__ = 'VOL'

    numero_vol = db.Column(db.Integer, primary_key=True)
    date_debut = db.Column(db.Date, primary_key=True)
    heure_debut = db.Column(db.DateTime, primary_key=True)
    date_arrivee = db.Column(db.Date)
    heure_arrivee = db.Column(db.DateTime)
    
    id_compagnie = db.Column(db.Integer, db.ForeignKey('COMPAGNIE.id_compagnie'))
    numero_aeroport_dep = db.Column(db.Integer, db.ForeignKey('AEROPORT.numero_aeroport'))
    numero_aeroport_arr = db.Column(db.Integer, db.ForeignKey('AEROPORT.numero_aeroport'))
    
    compagnie = db.relationship('Compagnie', back_populates='vols')
    aeroport_depart = db.relationship('Aeroport', foreign_keys=numero_aeroport_dep)
    aeroport_arrivee = db.relationship('Aeroport', foreign_keys=numero_aeroport_arr)
    terminals = db.relationship('Terminal', back_populates='vol', cascade="all, delete-orphan")

    def __init__(self, numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, numero_aeroport_arr):
        self.numero_vol = numero_vol
        self.date_debut = date_debut
        self.heure_debut = heure_debut
        self.date_arrivee = date_arrivee
        self.heure_arrivee = heure_arrivee
        self.id_compagnie = id_compagnie
        self.numero_aeroport_dep = numero_aeroport_dep
        self.numero_aeroport_arr = numero_aeroport_arr
    
    def to_json(self):
        return {
            'numero_vol': self.numero_vol,
            'date_debut': self.date_debut,
            'heure_debut': self.heure_debut,
            'date_arrivee': self.date_arrivee,
            'heure_arrivee': self.heure_arrivee,
            'id_compagnie': self.id_compagnie,
            'numero_aeroport_dep': self.numero_aeroport_dep,
            'numero_aeroport_arr': self.numero_aeroport_arr
        }
    
class Terminal(db.Model):
    __tablename__ = 'TERMINAL'

    numero_vol = db.Column(db.Integer, primary_key=True)
    numero_aeroport = db.Column(db.Integer, db.ForeignKey('AEROPORT.numero_aeroport'), primary_key=True)
    date_debut = db.Column(db.Date, primary_key=True)
    heure_debut = db.Column(db.DateTime, primary_key=True)
    id_terminal = db.Column(db.Integer, autoincrement=True)
    #Associe les valeurs de Terminal à celle de Vol
    __table_args__ = (
        db.ForeignKeyConstraint(
            ['numero_vol', 'date_debut', 'heure_debut'],
            ['VOL.numero_vol', 'VOL.date_debut', 'VOL.heure_debut']
        ),
    )

    vol = db.relationship('Vol', back_populates='terminals')
    aeroport = db.relationship('Aeroport')

    def __init__(self, numero_vol, numero_aeroport, date_debut, heure_debut):
        self.numero_vol = numero_vol
        self.numero_aeroport = numero_aeroport
        self.date_debut = date_debut
        self.heure_debut = heure_debut

    def to_json(self):
        return {
            'numero_vol': self.numero_vol,
            'numero_aeroport': self.numero_aeroport,
            'date_debut': self.date_debut,
            'heure_debut': self.heure_debut,
            'id_terminal': self.id_terminal
        }
    
def get_all_terminaux():
    return Terminal.query.all()