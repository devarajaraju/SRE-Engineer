from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "environment": "staging",
        "version": os.getenv("APP_VERSION", "1.0.0")
    }), 200

@app.route('/ready')
def ready():
    return jsonify({
        "status": "ready",
        "checks": {
            "database": "ok",
            "cache": "ok"
        }
    }), 200

@app.route('/metrics')
def metrics():
    return jsonify({
        "uptime_percent": 99.9,
        "requests_total": 1024,
        "errors_total": 1
    }), 200

@app.route('/admin')
def admin():
    return jsonify({"error": "forbidden"}), 403

@app.route('/debug')
def debug():
    return jsonify({"error": "not found"}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
