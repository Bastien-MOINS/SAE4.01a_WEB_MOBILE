from flask_restx import fields
from .app import api

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
