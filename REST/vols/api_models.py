from flask_restx import fields
from .app import api

terminal_model = api.model('Terminal', {
    'numero_vol': fields.Integer,
    'numero_aeroport': fields.Integer,
    'date_debut': fields.String,
    'heure_debut': fields.String,
    'id_terminal': fields.Integer
})

terminal_input_model = api.model('TerminalInput', {
    'numero_vol': fields.Integer(required=True),
    'numero_aeroport': fields.Integer(required=True),
    'date_debut': fields.String(required=True),
    'heure_debut': fields.String(required=True)
})