from flask import Flask, render_template
import requests

# Returns the public IP Address of the user
def get_public_ip():
    public_ip = requests.get('https://checkip.amazonaws.com').text
    return public_ip


# Create a Flask app
app = Flask(__name__)

@app.route("/")
def index():
    public_ip = get_public_ip()
    return render_template('index.html',public_ip = public_ip)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8080)