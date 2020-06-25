import pymongo, urllib.parse


class InfoManager:
    def __init__(self):
        self._client = pymongo.MongoClient("mongodb://localhost:27017/")
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

    def printDB(self):
        for document in self._collection.find():
            print(document)

    def deleteAllDocument(self, collection):
        collection.delete_many({})