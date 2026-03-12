from flask import jsonify, abort, make_response, request, url_for
from .models import *
from flask_restx import Resource, Namespace, fields
from datetime import datetime
from .app import app, db, api
from .api_models import aeroport_model, aeroport_input_model, terminal_model, terminal_input_model, vol_model, vol_input_model, compagnie_input_model, compagnie_model

ns_compagnie = api.namespace('compagnies')

@ns_compagnie.route('/')
class CompagnieCollection(Resource):
    @ns_compagnie.doc('list_compagnies')
    @ns_compagnie.marshal_list_with(compagnie_model)
    def get(self):
        '''Liste toutes les compagnies'''
        return get_all_compagnies()

    @ns_compagnie.doc('create_compagnie')
    @ns_compagnie.expect(compagnie_input_model, validate=True)
    @ns_compagnie.marshal_with(compagnie_model, code=201)
    def post(self):
        '''Crée une nouvelle compagnie'''
        data = ns_compagnie.payload
        
        if not data.get('nom_compagnie') or not isinstance(data.get('nom_compagnie'), str):
            abort(400, "La nom de la compagnie doit être une chaîne de caractères.")

        return create_compagnie(nom_compagnie=data.get('nom_compagnie')), 201

@ns_compagnie.route('/<int:id>')
@ns_compagnie.response(404, 'Compagnie non trouvé')
@ns_compagnie.param('id', 'L\'identifiant de la compagnie')
class CompagnieItem(Resource):
    @ns_compagnie.marshal_with(compagnie_model)
    def get(self, id):
        '''Récupère une compagnie via son identifiant'''
        compagnie = get_compagnie(id)
        if not compagnie:
            abort(404, f"La compagnie avec l'identifiant {id} n'existe pas.")
        return compagnie

    @ns_compagnie.response(200, 'Compagnie supprimé avec succès')
    def delete(self, id):
        '''Supprime une compagnie via son identifiant'''
        try:
            delete_compagnie(id)
        except CompagnieIdNotFoundException:
            abort(404, f"Impossible de supprimer : la compagnie avec l'identifiant {id} n'existe pas.")
        except CompagnieNotEmptyException:
            abort(400, "Il reste des vols dans la compagnie")
        return {'status': 'deleted'}, 200

    @ns_compagnie.expect(compagnie_input_model, validate=True)
    @ns_compagnie.marshal_with(compagnie_model)
    def put(self, id):
        '''Modifie une compagnie via son identifiant'''
        data = ns_compagnie.payload
        if 'nom_compagnie' in data and not isinstance(data.get('nom_compagnie'), str):
            abort(400, "Le nom de la compagnie doit être une chaîne de caractères.")
        compagnie = update_compagnie(id_compagnie=id, nom_compagnie=data.get('nom_compagnie'))
        if not compagnie:
            abort(404, f"Impossible de modifier : la compagnie avec l'identifiant {id} n'existe pas.")
        return compagnie
    
ns_aeroport = api.namespace('aeroports')

@ns_aeroport.route('/')
class AeroportCollection(Resource):
    @ns_aeroport.doc('list_aeroports')
    @ns_aeroport.marshal_list_with(aeroport_model)
    def get(self):
        '''Liste tous les aéroports'''
        return get_all_aeroports()

    @ns_aeroport.doc('create_aeroport')
    @ns_aeroport.expect(aeroport_input_model, validate=True)
    @ns_aeroport.marshal_with(aeroport_model, code=201)
    def post(self):
        '''Crée un nouvel aéroport'''
        data = ns_aeroport.payload
        
        if not data.get('nom_aeroport') or not isinstance(data.get('nom_aeroport'), str):
            abort(400, "Le nom de l'aéroport doit être une chaîne de caractères.")
        if not data.get('ville') or not isinstance(data.get('ville'), str):
            abort(400, "La ville doit être une chaîne de caractères.")
        if not data.get('pays') or not isinstance(data.get('pays'), str):
            abort(400, "Le pays doit être une chaîne de caractères.")

        return create_aeroport(nom_aeroport=data.get('nom_aeroport'), ville=data.get('ville'), pays=data.get('pays')), 201

@ns_aeroport.route('/<int:id>')
@ns_aeroport.response(404, 'Aéroport non trouvé')
@ns_aeroport.param('id', 'L\'identifiant de l\'aéroport')
class AeroportItem(Resource):
    @ns_aeroport.marshal_with(aeroport_model)
    def get(self, id):
        '''Récupère un aéroport via son identifiant'''
        aeroport = get_aeroport_by_id(id)
        if not aeroport:
            abort(404, f"L'aéroport avec l'identifiant {id} n'existe pas.")
        return aeroport

    @ns_aeroport.response(200, 'Aéroport supprimé avec succès')
    def delete(self, id):
        '''Supprime un aéroport via son identifiant'''
        if not delete_aeroport(id):
            abort(404, f"Impossible de supprimer : l'aéroport avec l'identifiant {id} n'existe pas.")
        return {'status': 'deleted'}, 200

    @ns_aeroport.expect(aeroport_input_model, validate=True)
    @ns_aeroport.marshal_with(aeroport_model)
    def put(self, id):
        '''Modifie un aéroport via son identifiant'''
        data = ns_aeroport.payload
        if 'nom_aeroport' in data and not isinstance(data.get('nom_aeroport'), str):
            abort(400, "Le nom de l'aéroport doit être une chaîne de caractères.")
        if 'ville' in data and not isinstance(data.get('ville'), str):
            abort(400, "La ville doit être une chaîne de caractères.")
        if 'pays' in data and not isinstance(data.get('pays'), str):
            abort(400, "Le pays doit être une chaîne de caractères.")
        aeroport = update_aeroport(id=id, nom_aeroport=data.get('nom_aeroport'), ville=data.get('ville'), pays=data.get('pays'))
        if not aeroport:
            abort(404, f"Impossible de modifier : l'aéroport avec l'identifiant {id} n'existe pas.")
        return aeroport

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
