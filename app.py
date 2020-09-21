import os

from flask import Flask
app = Flask(__name__)

HOST = os.environ.get('HOST', '127.0.0.1')

@app.route("/")
def hello():
    return "Goodbye, World!"

if __name__ == "__main__":
    app.run(host=HOST)