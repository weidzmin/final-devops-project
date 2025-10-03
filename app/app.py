#!/usr/bin/env python3

from flask import Flask, jsonify
import socket
import os

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    pod_ip = socket.gethostbyname(hostname)
    
    return jsonify({
        'message': 'Hello from Python backend, 2.0!',
        'pod_name': hostname,
        'pod_ip': pod_ip,
        'status': 'OK'
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
