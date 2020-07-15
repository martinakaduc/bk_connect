import datetime
from flask import Flask, request, jsonify
import os
from flask_jwt_extended import JWTManager
from flask_jwt_extended import (create_access_token, jwt_required, get_jwt_identity)
import base64
from InfoManager import InfoManager
import numpy as np
from PIL import Image
import io
import classify
import preprocess
import cv2
app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = 'this is a secret key'
revoked_tokens = []

classifier = classify.Classify()

jwt = JWTManager(app)

infoManager = InfoManager()

@app.route("/test/", methods=["GET"])
def test():
    return "Hello World"

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
        token = create_access_token(identity=user["username"], expires_delta=datetime.timedelta(days=1))
        msg = {
            "status": "success",
            "message": "loged in successfully",
            "access_token": token,
        }
        return jsonify(msg)
    else:
        msg = {"status": "failure", "message": "invalid username or password"}
        return jsonify(msg)
            
@app.route("/recognize/", methods = ["POST"])
@jwt_required
def recognize():
    threshold = 0.2
    data = request.get_json()
    
    # print(data)
    if data is None:
        print("No valid request body, json missing!")
        return jsonify({'error': 'No valid request body, json missing!'})
    else:
        image = data["image"]
        username  = get_jwt_identity()
        image_array = convert_to_array(image)
        studentID = classifier.predict(image_array, threshold)
        if(studentID == 'Unknown face'):
            print(studentID)
            return
        user = infoManager.getUserViaID(studentID)
        if studentID != 'Unknown face':
            print("a")
            infoManager.addNewUserToFriendList(username , studentID)
        msg = {
        "username": user["username"],
        "id": user["id"],
        "email": user["email"],
        "phone": user["phone"],          
        }
        return jsonify(msg)
   


def convert_to_array(b64_string):
    with open("imageToSave.jpg", "wb") as fh:
        fh.write(base64.decodebytes(b64_string.encode()))
    tmp = base64.b64decode(b64_string)
    # print(tmp)
    image = Image.open(io.BytesIO(tmp))
    
    # cv2.imshow('dcm', np.array(image))
    # bb, pp_image, run_detect = preprocessor.align(image)
    return np.array(image)
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

@app.route("/getFriendList/", methods=["GET"])
@jwt_required
def getFriendList():
    username = get_jwt_identity()
    infoFriends = []
    user = infoManager.getUser(username = username)
    myInfo = {
        "username": user["username"],
        "id": user["id"],
        "email": user["email"],
        "phone": user["phone"],
    }
    infoFriends.append(myInfo)
    if "FriendList" in user:
        friendList = user["FriendList"]
        for friendID in friendList :
            tempInfo = infoManager.getUserViaID(friendID)
            info = {
                "username": tempInfo["username"],
                "id": tempInfo["id"],
                "email": tempInfo["email"],
                "phone": tempInfo["phone"],      
            }
            infoFriends.append(info)
    msg = {
        "infoFriends": infoFriends,
    }
    
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

# @app.route("/update_position", methods=["POST"])
# @jwt_required
# def update_position():
#     username = get_jwt_identity()


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)
