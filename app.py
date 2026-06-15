import os
import pymysql
from flask import Flask, request, render_template

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST")
DB_USER = os.environ.get("DB_USER")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
DB_NAME = os.environ.get("DB_NAME")

def get_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route("/", methods=["GET"])
def home():
    return render_template("index.html")

@app.route("/save", methods=["POST"])
def save():
    name = request.form.get("name")
    message = request.form.get("message")

    connection = get_connection()

    with connection:
        with connection.cursor() as cursor:
            sql = "INSERT INTO messages (name, message) VALUES (%s, %s)"
            cursor.execute(sql, (name, message))
        connection.commit()

    return "Data saved successfully!"

@app.route("/health", methods=["GET"])
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
