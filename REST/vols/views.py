
from flask import jsonify, abort, make_response, request, url_for
from flask_restx import Resource, fields
from .app import app, db, api
from .models import Vol, get_all_vols, get_vol_by_id, create_vol, update_vol, delete_vol 
from .api_models import vol_model, vol_input_model

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
        if not data.get('id_compagnie') or not isinstance(data.get('id_compagnie'), int): # TODO : Vérifier que id compagnie existe
            abort(400, "L'id de compagnie doit être un entier.")
        if not data.get('numero_aeroport_dep') or not isinstance(data.get('numero_aeroport_dep'), int):
            abort(400, "Le numéro de l'aéroport de départ doit être un entier.")
        if not data.get('numero_aeroport_arr') or not isinstance(data.get('numero_aeroport_arr'), int):
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

@ns_vol.route('/<int:id>')
@ns_vol.response(404, 'Vol non trouvé')
@ns_vol.param('numero_vol', 'L\'identifiant du vol')
class VolItem(Resource):
    @ns_vol.marshal_with(vol_model)
    def get(self, numero_vol):
        '''Récupère un vol via son identifiant'''
        aeroport = get_vol_by_id(numero_vol)
        if not aeroport:
            abort(404, f"L'aéroport avec l'identifiant {id} n'existe pas.")
        return aeroport

    @ns_vol.response(200, 'Aéroport supprimé avec succès')
    def delete(self, numero_vol):
        '''Supprime un vol via son numéro'''
        if not delete_vol(numero_vol):
            abort(404, f"Impossible de supprimer : l'aéroport avec l'identifiant {numero_vol} n'existe pas.")
        return {'status': 'deleted'}, 200

    @ns_vol.expect(vol_input_model, validate=True)
    @ns_vol.marshal_with(vol_model)
    def put(self, numero_vol):
        '''Modifie un aéroport via son identifiant'''
        data = ns_vol.payload
        if 'nom_aeroport' in data and not isinstance(data.get('nom_aeroport'), str):
            abort(400, "Le nom de l'aéroport doit être une chaîne de caractères.")
        if 'ville' in data and not isinstance(data.get('ville'), str):
            abort(400, "La ville doit être une chaîne de caractères.")
        if 'pays' in data and not isinstance(data.get('pays'), str):
            abort(400, "Le pays doit être une chaîne de caractères.")
        vol = update_vol(numero_vol=numero_vol, nom_aeroport=data.get('nom_aeroport'), ville=data.get('ville'), pays=data.get('pays'))
        if not vol:
            abort(404, f"Impossible de modifier : l'aéroport avec l'identifiant {id} n'existe pas.")
        return vol