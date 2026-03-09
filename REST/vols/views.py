from flask import jsonify, abort, make_response, request, url_for
from .app import app
from flask_restx import Resource, fields
from .models import *
from .api_models import compagnie_input_model, compagnie_model
from .extensions import api, db


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
            abort(404, f"Impossible de supprimer : la compagnie avec l'identifiant {id_compagnie} n'existe pas.")
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
