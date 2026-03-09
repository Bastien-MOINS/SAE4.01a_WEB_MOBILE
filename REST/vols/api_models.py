
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