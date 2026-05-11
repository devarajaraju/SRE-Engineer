from flask import Flask, jsonify
import os
import requests
from requests.auth import HTTPBasicAuth
import json

app = Flask(__name__)

@app.route("/createJIRA".methods=['POST'])
def createJIRA():
    url = "https://devarajakraju.atlassian.net//rest/api/3/issue"

auth = HTTPBasicAuth("devarajakraju@gmail.com", $JIRA_TOKEN)

headers = {
  "Accept": "application/json",
  "Content-Type": "application/json"
}

payload = json.dumps( {
  "fields": {
     "description": {
      "content": [
        {
          "content": [
            {
              "text": "Order entry fails when selecting supplier.",
              "type": "text"
            }
          ],
          "type": "paragraph"
        }
      ],
      "type": "doc",
      "version": 1
    },
    "issuetype": {
      "id": "10000"
    },    
    "summary": "Main order flow broken",
    "timetracking": {
      "originalEstimate": "10",
      "remainingEstimate": "5"
    },
    "versions": [
      {
        "id": "10000"
      }
    ]
  },
  "update": {}
} )

response = requests.request(
   "POST",
   url,
   data=payload,
   headers=headers,
   auth=auth
)

print(json.dumps(json.loads(response.text), sort_keys=True, indent=4, separators=(",", ": ")))
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
