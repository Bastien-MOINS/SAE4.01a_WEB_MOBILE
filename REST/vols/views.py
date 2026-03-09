from flask import abort
from .models import Aeroport, Vol, Terminal, get_all_terminaux, create_terminal, get_terminal_by_id, update_terminal, delete_terminal
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

        if not data.get('nom_terminal'):
            abort(400, "Veuillez rentrer le nom du Terminal.")

        num_aero = data.get('numero_aeroport')
        if 'numero_aeroport' in data and not isinstance(num_aero, int):
            abort(400, "Le numéro d'aéroport doit être un entier(et > 0).")
        aeroport = Aeroport.query.get(num_aero)
        if not aeroport:
            abort(400, "Le numéro d'aéroport n'existe pas.")

        return create_terminal(
            numero_aeroport=num_aero,
            nom_terminal=data.get('nom_terminal')
        ), 201



@ns_terminal.route('/<int:id>')
@ns_terminal.response(404, 'Terminal non trouvé')
@ns_terminal.param('id', 'L\'identifiant du terminal')
class TerminalItem(Resource):

    @ns_terminal.marshal_with(terminal_model)
    def get(self, id):
        '''Récupère un terminal via son identifiant'''
        terminal = get_terminal_by_id(id)
        if not terminal:
            abort(404, f"Le terminal avec l'identifiant {id} n'existe pas.")
        return terminal


    @ns_terminal.response(200, 'Terminal supprimé avec succès')
    def delete(self, id):
        '''Supprime un terminal via son identifiant'''
        if not delete_terminal(id):
            abort(404, f"Impossible de supprimer : le terminal avec l'identifiant {id} n'existe pas.")
        return {'status': 'deleted'}, 200
    

    @ns_terminal.expect(terminal_input_model, validate=True)
    @ns_terminal.marshal_with(terminal_model)
    def put(self, id):
        '''Modifie un terminal via son identifiant'''
        data = ns_terminal.payload

        if not data.get('nom_terminal'):
            abort(400, "Veuillez rentrer le nouveau nom du Terminal.")

        num_aero = data.get('numero_aeroport')
        if 'numero_aeroport' in data and not isinstance(num_aero, int):
            abort(400, "Le numéro d'aéroport doit être un entier(et > 0).")
        aeroport = Aeroport.query.get(num_aero)
        if not aeroport:
            abort(400, "Le numéro d'aéroport n'existe pas.")

        terminal = update_terminal(
            id_terminal=id,
            numero_aeroport=num_aero,
            nom_terminal=data.get('nom_terminal')
        )
        
        if not terminal:
            abort(404, f"Impossible de modifier : le terminal avec l'identifiant {id} n'existe pas.")
        return terminal
