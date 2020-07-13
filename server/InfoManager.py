import pymongo, urllib.parse


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
        if self._collection.count({"username": username, "password": password}) == 1:
            return True
        return False

    def addUser(self, info):
        self._collection.insert_one(info)

    def getUser(self, username):
        return self._collection.find_one({"username": username})

    def getUserViaID(self , studentID):
        return self._collection.find_one({"id": studentID})

    def addNewUserToFriendList(self, myID , friendID):
        if self._collection.find({"id" : myID , "FriendList" : {"$exists":False}} ):
            self._collection.update({"id":myID} , {"$set"    :{"FriendList": [friendID]}})
        else:
            self._collection.update({"id":myID} , {"$addToSet":{"FriendList":friendID}})
    def printDB(self):
        for document in self._collection.find():
            print(document)

    def deleteAllDocument(self, collection):
        collection.delete_many({})