from flask_restx import fields
from .app import api
vol_model = api.model('Vol', {
    'numero_vol': fields.Integer,
    'date_debut': fields.String,
    'heure_debut': fields.String,
    'date_arrivee': fields.String,
    'heure_arrivee': fields.String,
    'id_compagnie': fields.Integer,
    'numero_aeroport_dep': fields.Integer,
    'numero_aeroport_arr': fields.Integer
})

vol_input_model = api.model('VolInput', {
    'date_debut': fields.String(required=True),
    'heure_debut': fields.String(required=True),
    'date_arrivee': fields.String(required=True),
    'heure_arrivee': fields.String(required=True),
    'id_compagnie': fields.Integer(required=True),
    'numero_aeroport_dep': fields.Integer(required=True),
    'numero_aeroport_arr': fields.Integer(required=True)
})
compagnie_model = api.model('Compagnie', {
    'id_compagnie': fields.Integer,
    'nom_compagnie': fields.String,
    'vols': fields.List(fields.Nested(vol_model)),
})

compagnie_input_model = api.model('CompagnieInput', {
    'nom_compagnie': fields.String(required=True),
})


terminal_model = api.model('Terminal', {
    'numero_aeroport': fields.Integer,
    'id_terminal': fields.Integer,
    'nom_terminal': fields.String
})

terminal_input_model = api.model('TerminalInput', {
    'numero_aeroport': fields.Integer,
    'nom_terminal': fields.String
})

aeroport_model = api.model('Aeroport', {
    'numero_aeroport': fields.Integer,
    'nom_aeroport': fields.String,
    'ville': fields.String,
    'pays': fields.String
})

aeroport_input_model = api.model('AeroportInput', {
    'nom_aeroport': fields.String(required=True),
    'ville': fields.String(required=True),
    'pays': fields.String(required=True)
})
