from flask_restx import fields
from .app import api

terminal_model = api.model('Terminal', {
    'numero_aeroport': fields.Integer,
    'id_terminal': fields.Integer,
    'nom_terminal': fields.String
})

terminal_input_model = api.model('TerminalInput', {
    'numero_aeroport': fields.Integer,
    'nom_terminal': fields.String
})