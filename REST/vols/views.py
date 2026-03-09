from flask import jsonify, abort, make_response, request, url_for
from .models import Aeroport, Vol, Terminal, get_all_terminaux, create_terminal, get_terminal_by_id, \
                    get_all_vols, get_vol_by_id, create_vol, update_vol, delete_vol, update_terminal, \
                    delete_terminal, terminal_est_occupe_ou_reserve
from flask_restx import Resource, Namespace, fields
from .app import api, db, app
from .api_models import terminal_model, terminal_input_model, vol_model, vol_input_model
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
        if terminal_est_occupe_ou_reserve(id):
            abort(400, "Impossible de supprimer ce terminal. Des vols y sont rattachés.")

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
    


ns_vol = api.namespace('vol')

@ns_vol.route('/')
class VolCollection(Resource):
    @ns_vol.doc('list_vols')
    @ns_vol.marshal_list_with(vol_model)
    def get(self):
        '''Liste tous les vols'''
        return get_all_vols()

    @ns_vol.doc('create_vol')
    @ns_vol.expect(vol_input_model, validate=True)
    @ns_vol.marshal_with(vol_model, code=201)
    def post(self):
        '''Crée un nouveau vol'''
        data = ns_vol.payload
        
        if not data.get('date_debut') or not isinstance(data.get('date_debut'), str):
            abort(400, "La date de début doit être une chaîne de caratères.")
        if not data.get('heure_debut') or not isinstance(data.get('heure_debut'), str):
            abort(400, "L'heure du début doit être une chaîne de caractères.")
        if not data.get('date_arrivee') or not isinstance(data.get('date_arrivee'), str):
            abort(400, "La date d'arrivée doit être une chaîne de caractères.")
        if not data.get('heure_arrivee') or not isinstance(data.get('heure_arrivee'), str):
            abort(400, "L'heure d'arrivée doit être une chaîne de caractères.")
        if data.get('id_compagnie') is None or not isinstance(data.get('id_compagnie'), int): # TODO : Vérifier que id compagnie existe
            abort(400, "L'id de compagnie doit être un entier.")
        if data.get('numero_aeroport_dep') is None or not isinstance(data.get('numero_aeroport_dep'), int):
            abort(400, "Le numéro de l'aéroport de départ doit être un entier.")
        if data.get('numero_aeroport_arr') is None or not isinstance(data.get('numero_aeroport_arr'), int):
            abort(400, "Le numéro de l'aéroport d'arrivé doit être un entier.")

        return create_vol(
            date_debut=data.get('date_debut'), 
            heure_debut=data.get('heure_debut'), 
            date_arrivee=data.get('date_arrivee'), 
            heure_arrivee=data.get('heure_arrivee'), 
            id_compagnie=data.get('id_compagnie'), 
            numero_aeroport_dep=data.get('numero_aeroport_dep'), 
            numero_aeroport_arr=data.get('numero_aeroport_arr')
        ), 201

@ns_vol.route('/<int:numero_vol>')
@ns_vol.response(404, 'Vol non trouvé')
@ns_vol.param('numero_vol', 'L\'identifiant du vol')
class VolItem(Resource):
    @ns_vol.marshal_with(vol_model)
    def get(self, numero_vol):
        '''Récupère un vol via son identifiant'''
        vol = get_vol_by_id(numero_vol)
        if not vol:
            abort(404, f"Le vol avec l'identifiant {numero_vol} n'existe pas.")
        return vol

    @ns_vol.response(200, 'Vol supprimé avec succès')
    def delete(self, numero_vol):
        '''Supprime un vol via son numéro'''
        if not delete_vol(numero_vol):
            abort(404, f"Impossible de supprimer : le vol avec l'identifiant {numero_vol} n'existe pas.")
        return {'status': 'deleted'}, 200

    @ns_vol.expect(vol_input_model, validate=True)
    @ns_vol.marshal_with(vol_model)
    def put(self, numero_vol):
        '''Modifie un vol via son identifiant'''
        data = ns_vol.payload
        if 'date_debut' in data and not isinstance(data.get('date_debut'), str):
            abort(400, "La date de début doit être une chaîne de caractères.")
        if 'heure_debut' in data and not isinstance(data.get('heure_debut'), str):
            abort(400, "L'heure du début doit être une chaîne de caractères.")
        if 'date_arrivee' in data and not isinstance(data.get('date_arrivee'), str):
            abort(400, "La date d'arrivée doit être une chaîne de caractères.")
        if 'heure_arrivee' in data and not isinstance(data.get('heure_arrivee'), str):
            abort(400, "L'heure d'arrivée doit être une chaîne de caractères.")
        if 'id_compagnie' in data and not isinstance(data.get('id_compagnie'), int):
            abort(400, "L'id de compagnie doit être un entier.")
        if 'numero_aeroport_dep' in data and not isinstance(data.get('numero_aeroport_dep'), int):
            abort(400, "Le numéro de l'aéroport de départ doit être un entier.")
        if 'numero_aeroport_arr' in data and not isinstance(data.get('numero_aeroport_arr'), int):
            abort(400, "Le numéro de l'aéroport d'arrivé doit être un entier.")

        vol = update_vol(
            numero_vol=numero_vol,
            date_debut=data.get('date_debut'),
            heure_debut=data.get('heure_debut'),
            date_arrivee=data.get('date_arrivee'),
            heure_arrivee=data.get('heure_arrivee'),
            id_compagnie=data.get('id_compagnie'),
            numero_aeroport_dep=data.get('numero_aeroport_dep'),
            numero_aeroport_arr=data.get('numero_aeroport_arr'),
        )
        if not vol:
            abort(404, f"Impossible de modifier : le vol avec l'identifiant {numero_vol} n'existe pas.")
        return vol
