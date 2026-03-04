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
    id_terminal_dep = db.Column(db.Integer, db.ForeignKey('TERMINAL.id_terminal'))
    numero_aeroport_arr = db.Column(db.Integer, db.ForeignKey('AEROPORT.numero_aeroport'))
    id_terminal_arr = db.Column(db.Integer, db.ForeignKey('TERMINAL.id_terminal'))
    
    compagnie = db.relationship('Compagnie', back_populates='vols')
    terminal_aeroport_depart = db.relationship(
        'Terminal',
        foreign_keys=[numero_aeroport_dep, id_terminal_dep],
        primaryjoin="and_(Vol.id_terminal_dep==Terminal.id_terminal, Vol.numero_aeroport_dep==Terminal.numero_aeroport)",
        back_populates="vol_dep",
        uselist=False,
    )
    terminal_aeroport_arrivee = db.relationship(
        'Terminal',
        foreign_keys=[numero_aeroport_arr, id_terminal_arr],
        primaryjoin="and_(Vol.id_terminal_arr==Terminal.id_terminal, Vol.numero_aeroport_arr==Terminal.numero_aeroport)",
        back_populates="vol_arr",
        uselist=False,
    )

    def __init__(self, numero_vol, date_debut, heure_debut, date_arrivee, heure_arrivee, id_compagnie, numero_aeroport_dep, id_terminal_dep, numero_aeroport_arr, id_terminal_arr):
        self.numero_vol = numero_vol
        self.date_debut = date_debut
        self.heure_debut = heure_debut
        self.date_arrivee = date_arrivee
        self.heure_arrivee = heure_arrivee
        self.id_compagnie = id_compagnie
        self.numero_aeroport_dep = numero_aeroport_dep
        self.id_terminal_dep = id_terminal_dep
        self.numero_aeroport_arr = numero_aeroport_arr
        self.id_terminal_arr= id_terminal_arr
    
    def to_json(self):
        return {
            'numero_vol': self.numero_vol,
            'date_debut': self.date_debut,
            'heure_debut': self.heure_debut,
            'date_arrivee': self.date_arrivee,
            'heure_arrivee': self.heure_arrivee,
            'id_compagnie': self.id_compagnie,
            'numero_aeroport_dep': self.numero_aeroport_dep,
            'id_terminal_dep' : self.id_terminal_dep,
            'numero_aeroport_arr': self.numero_aeroport_arr,
            'id_terminal_arr' : self.id_terminal_arr
        }
    
class Terminal(db.Model):
    __tablename__ = 'TERMINAL'
    __table_args__ = (
        db.UniqueConstraint('numero_aeroport', 'nom_terminal', name='uq_terminal_airport_name'),
    )

    numero_aeroport = db.Column(db.Integer, db.ForeignKey('AEROPORT.numero_aeroport'), nullable=False)
    id_terminal = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nom_terminal = db.Column(db.String(38))

    vol_dep = db.relationship(
        'Vol',
        foreign_keys='Vol.id_terminal_dep',
        primaryjoin="and_(Terminal.id_terminal==Vol.id_terminal_dep, Terminal.numero_aeroport==Vol.numero_aeroport_dep)",
        back_populates='terminal_aeroport_depart',
    )
    vol_arr = db.relationship(
        'Vol',
        foreign_keys='Vol.id_terminal_arr',
        primaryjoin="and_(Terminal.id_terminal==Vol.id_terminal_arr, Terminal.numero_aeroport==Vol.numero_aeroport_arr)",
        back_populates='terminal_aeroport_arrivee',
    )
    aeroport = db.relationship('Aeroport')

    def __init__(self, numero_aeroport, nom_terminal):
        self.numero_aeroport = numero_aeroport
        self.nom_terminal  = nom_terminal

    def to_json(self):
        return {
            'numero_aeroport': self.numero_aeroport,
            'id_terminal': self.id_terminal,
            'nom_terminal' : self.nom_terminal
        }