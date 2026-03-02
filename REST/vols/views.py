from .models import Terminal, get_all_terminaux
from flask_restx import Resource, Namespace
from .app import api
from .api_models import terminal_model

ns_terminal = api.namespace('terminal')

@ns_terminal.route('/')
class TerminalCollection(Resource):
    @ns_terminal.doc('list_aeroports')
    @ns_terminal.marshal_list_with(terminal_model)
    def get(self):
        '''Liste tous les terminaux'''
        return get_all_terminaux()
