from flask import abort
from .models import Aeroport, Vol, Terminal, get_all_terminaux, create_terminal
from flask_restx import Resource, Namespace
from .app import api
from .api_models import terminal_model, terminal_input_model
from datetime import datetime


ns_terminal = api.namespace('terminal')


@ns_terminal.route('/')
class TerminalCollection(Resource):

    @ns_terminal.doc('list_terminaux')
    @ns_terminal.marshal_list_with(terminal_model)
    def get(self):
        '''Liste tous les terminaux'''
        return get_all_terminaux()


    @ns_terminal.doc('create_terminal')
    @ns_terminal.expect(terminal_input_model, validate=True)
    @ns_terminal.marshal_with(terminal_model, code=201)
    def post(self):
        '''Crée un nouveau terminal'''
        data = ns_terminal.payload

        try:
            date_debut_conv = datetime.strptime(data.get('date_debut'), '%Y-%m-%d').date()
            heure_debut_conv = datetime.strptime(data.get('heure_debut'), '%H:%M').time()
        except (ValueError, TypeError):
            abort(400, "Format de date/heure invalide. Utilisez: YYYY-MM-DD et HH:MM")

        if not data.get('numero_vol') or not isinstance(data.get('numero_vol'), int):
            abort(400, "Le numéro de vol doit être un entier(et > 0).")
        clef = (data.get('numero_vol'), date_debut_conv, heure_debut_conv)
        vol = Vol.query.get(clef)
        if not vol:
            abort(400, "Le numéro de vol n'existe pas.")
        
        if not data.get('numero_aeroport') or not isinstance(data.get('numero_aeroport'), int):
            abort(400, "Le numéro d'aéroport doit être un entier(et > 0).")
        aeroport = Aeroport.query.get(data.get('numero_aeroport'))
        if not aeroport:
            abort(400, "Le numéro d'aéroport n'existe pas.")

        return create_terminal(
            numero_vol=data.get('numero_vol'),
            numero_aeroport=data.get('numero_aeroport'),
            date_debut=date_debut_conv,
            heure_debut=heure_debut_conv
        ), 201