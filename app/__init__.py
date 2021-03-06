import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bootstrap import Bootstrap
from flask_script import Manager
from scripts_bank.netboxAPI import NetboxHost

app = Flask(__name__, instance_relative_config=True)
app.config.from_object('config')
app.config.from_pyfile('settings.py', silent=True)
db = SQLAlchemy(app)
Bootstrap(app)
try:
    netbox = NetboxHost(app.config['NETBOXSERVER'])
except KeyError:
    netbox = NetboxHost("''")

from app import views, models

manager = Manager(app)
if __name__ == "__main__":
    app.secret_key = os.urandom(25)
    manager.run()
