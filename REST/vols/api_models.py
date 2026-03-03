from flask_restx import fields
from .app import api

compagnie_model = api.model('Compagnie', {
    'id_compagnie': fields.Integer,
    'nom_compagnie': fields.String,
    'vols': fields.List(fields.String),
})

compagnie_input_model = api.model('CompagnieInput', {
    'nom_compagnie': fields.String(required=True),
    'vols': fields.List(fields.String),
})
