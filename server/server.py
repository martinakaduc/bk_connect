from flask import Flask,request,jsonify
from InfoManager import InfoManager
from flask_jwt_extended import JWTManager
from flask_jwt_extended import (create_access_token, jwt_required, get_jwt_identity, get_raw_jwt)
import datetime

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = 'this is a secret key'
revoked_tokens = []

jwt = JWTManager(app)

infoManager = InfoManager()

#@app.route("/test/", methods=["GET"])
#def test():
#    return "Hello World"

#@app.route("/printDB/", methods=["GET"])
#def printDB():
#    infoManager.printDB()
#    return ""

#@app.route("/deleteAllDocument/", methods=["GET"])
#def deleteAllDocument():
#    infoManager.deleteAllDocument(infoManager._collection)
#    return ""

@app.route("/login/",methods=["POST"])
def login():
    user = request.json

    if user["username"] == None or user["password"] == None:
        msg = {"status": "failure", "message": "incomplete login information"}
        return jsonify(msg)
    
    if infoManager.authorizeSignIn(username=user["username"], password=user["password"]):
        token = create_access_token(identity=user["username"], expires_delta=datetime.timedelta(minutes=1.0))
        msg = {
            "status": "success",
            "message": "loged in successfully",
            "access_token": token,
        }
        return jsonify(msg)
    else:
        msg = {"status": "failure", "message": "invalid username or password"}
        return jsonify(msg)
            

@app.route("/register/", methods=["POST"])
def register():
    user = request.json

    if user["username"] == None or user["id"] == None or user["email"] == None or user["phone"] == None or user["password"] == None:
        msg = {"status": "failure", "message": "incomplete register information"}
        return jsonify(msg)

    if infoManager.authorizeSignUp(username=user["username"]):
        infoManager.addUser(user)
        msg = {"status": "success", "message": "registered successfully"}
        return jsonify(msg)
    else:
        msg = {"status": "failure", "message": "username already taken"}
        return jsonify(msg)

@app.route("/profile/", methods=["GET"])
@jwt_required
def send_profile():
    username = get_jwt_identity()
    user = infoManager.getUser(username=username)
    msg = {
        "username": user["username"],
        "id": user["id"],
        "email": user["email"],
        "phone": user["phone"],          
    }
    return jsonify(msg)




if __name__ == "__main__":
    app.run(debug=True,host='localhost', port=5000)