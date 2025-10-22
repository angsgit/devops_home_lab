from flask import Flask
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

# --- Define metrics ---
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint'])

@app.before_request
def before_request():
    REQUEST_COUNT.labels(method='GET', endpoint='/').inc()

@app.route('/')
def home():
    return "<h1>TEST DEPLOYMENT SIMULATING FULL CI/CD FLOW</h1>"

@app.route('/health')
def health():
    return "ok"

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)