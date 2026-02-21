from .app import app, db

@app.cli.command()
def syncdb():
    ...