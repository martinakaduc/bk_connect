import pymongo, urllib.parse
from werkzeug.security import check_password_hash


class InfoManager:
    def __init__(self):
        self._client = pymongo.MongoClient("mongodb+srv://MyStic:asdsasfd@mysticdb-b06ey.mongodb.net/mydatabase?retryWrites=true&w=majority")
        self._db = self._client["mydatabase"]
        self._collection = self._db["users"]

    def authorizeSignUp(self, username):
        if self._collection.count({"username": username}) == 1:
            return False
        return True

    def authorizeSignIn(self, username, password):
        user = self.getUser(username)
        if user != None:
            return check_password_hash(user["password"], password)
        return False

    def addUser(self, info):
        self._collection.insert_one(info)

    def getUser(self, username):
        return self._collection.find_one({"username": username})

    def getUserViaID(self , studentID):
        return self._collection.find_one({"id": studentID})

    def addNewUserToFriendList(self, username , friendID):
        self._collection.find_and_modify(query={"username" : username , "FriendList" : {"$exists":False}} , update={"$set":{"FriendList": [friendID]}})
        self._collection.find_and_modify(query={"username":username , "FriendList" : {"$exists":True}} , update={"$addToSet":{"FriendList":friendID}})

    def removeUserInFriendList(self, username, friendID):
        result = self._collection.update_one({"username": username}, update={"$pull": {"FriendList": friendID}})
        return result.modified_count > 0

    def updatePosition(self, username, position):
        self._collection.find_and_modify(query={"username" : username}, update={"$set":{"position": position}})


    def printDB(self):
        for document in self._collection.find():
            print(document)

    def deleteAllDocument(self, collection):
        collection.delete_many({})
