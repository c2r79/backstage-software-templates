import os
import datetime
import socket
from flask import Flask, jsonify

app = Flask(__name__)

host = os.getenv("FLASK_RUN_HOST", "0.0.0.0")
message = {"time": datetime.datetime.now().strftime("%I:%M:%S%p  on %B %d, %Y"), 
           "hostname": socket.gethostname(), 
           "data": "AI is here, gotta learn it!",
           "app_name": '${{values.app_name}}',
           "environment": '${{values.app_env}}'}
health_message = {"status": "up"}

@app.route('/api/v1/details')

def details():
    return jsonify(message)

@app.route('/api/v1/health')

def health():
    return jsonify(health_message), 200

if __name__ == '__main__':
    app.run(host=host)