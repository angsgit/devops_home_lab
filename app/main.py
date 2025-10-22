from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>TEST DEPLOYMENT SIMULATING FULL CI/CD FLOW</h1>"

@app.route('/health')
def health():
    return "ok"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)

