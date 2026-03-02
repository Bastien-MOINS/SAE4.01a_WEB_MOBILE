from flask import jsonify, abort, make_response, request, url_for
from flask_restx import Resource, fields
from .app import app, db, api
from .models import Aeroport, get_all_aeroports, get_aeroport_by_id, create_aeroport, update_aeroport, delete_aeroport
from .api_models import aeroport_model, aeroport_input_model

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
