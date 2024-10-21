from flask import Flask, request, jsonify
import mysql.connector
from mysql.connector import Error
from flask_cors import CORS
# from flask_talisman import Talisman

app = Flask(__name__)
CORS(app)

# Talisman(app)

CORS(app, resources={r"/*": {"origins": "*"}})

def create_connection():
    connection = mysql.connector.connect(
        host="34.107.55.92",
        port="3306",
        user="",
        password="",
        database="users"
    )
    return connection

@app.route('/test')
def test():
    return "Test endpoint is working!"


@app.route('/users', methods=['POST'])
def create_user():
    user_data = request.json
    name = user_data.get("name")
    email = user_data.get("email")

    connection = create_connection()
    cursor = connection.cursor()
    query = "INSERT INTO users (name, email) VALUES (%s, %s)"
    cursor.execute(query, (name, email))
    connection.commit()
    cursor.close()
    connection.close()
    return jsonify({"message": "User created successfully!"}), 201

@app.route('/users', methods=['GET'])
def get_users():
    connection = create_connection()
    cursor = connection.cursor(dictionary=True)
    query = "SELECT * FROM users"
    cursor.execute(query)
    users = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify(users), 200

@app.route('/users', methods=['DELETE'])
def delete_user():
    user_data = request.json
    email = user_data.get("email")

    connection = create_connection()
    cursor = connection.cursor()
    query = "DELETE FROM users WHERE email = %s"
    cursor.execute(query, (email,))
    connection.commit()
    
    if cursor.rowcount == 0:
        return jsonify({"message": "User not found!"}), 404

    cursor.close()
    connection.close()
    return jsonify({"message": "User deleted successfully!"}), 200

if __name__ == '__main__':
    # app.run(host='0.0.0.0', port=5000)
    app.run(host='0.0.0.0', port=8443, ssl_context=('cert.pem', 'key.pem'))
