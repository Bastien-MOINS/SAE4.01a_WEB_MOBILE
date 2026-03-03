from .app import app, db
from .models import Compagnie, Terminal, Aeroport

@app.cli.command()
def syncdb():
    c1 = Compagnie("Montenegro")
    t1_a1 = Terminal()