from flask_restx import fields
from .app import api

terminal_model = api.model('Terminal', {
    'numero_vol': fields.Integer,
    'numero_aeroport': fields.Integer,
    'date_debut': fields.String,
    'heure_debut': fields.String,
    'id_terminal': fields.Integer
})