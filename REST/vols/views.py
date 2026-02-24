from flask import jsonify, abort, make_response, request, url_for
from .app import app, db
from .models import *

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

@app.errorhandler(400)
def bad_request(error):
    return make_response(jsonify({'error': 'Bad request'}), 400)

@app.route('/vols_app/api/v1.0/compagnies', methods = ['GET'])
def get_compagnies():
    compagnies = get_all_compagnies()
    res = []
    if compagnies:
        for compagnie in compagnies:
            res.append(compagnie.to_json())
        return jsonify({'compagnies': res})
    return abort(404)

@app.route('/vols_app/api/v1.0/compagnies/<int:id_compagnie>', methods = ['GET'])
def get_compagnie_view(id_compagnie):
    compagnie = get_compagnie(id_compagnie)
    if compagnie:
        return jsonify({'compagnie': compagnie.to_json()})
    return abort(404)

@app.route('/vols_app/api/v1.0/compagnies', methods=['POST'])
def add_compagnie():
    if not request.json or 'nom_compagnie' not in request.json:
        abort(400)
    
    compagnie = create_compagnie(request.json['nom_compagnie'])
    return jsonify({'compagnie': compagnie.to_json()}), 201

@app.route('/vols_app/api/v1.0/compagnies/<int:id_compagnie>', methods=['PUT'])
def modif_compagnie(id_compagnie):
    compagnie = get_compagnie(id_compagnie)
    if not compagnie:
        abort(404)
    if not request.json:
        abort(400)
    
    if 'nom_compagnie' in request.json:
        update_compagnie(compagnie, request.json['nom_compagnie'])
        
    return jsonify({'compagnie': compagnie.to_json()})

@app.route('/vols_app/api/v1.0/compagnies/<int:id_compagnie>', methods=['DELETE'])
def remove_compagnie(id_compagnie):
    compagnie = get_compagnie(id_compagnie)
    if not compagnie:
        abort(404)
    delete_compagnie(compagnie)
    return jsonify({'status': 'deleted'})
