import json
import firebase_admin
from firebase_admin import credentials, firestore

def load_data(collection_name, documents, db):
    for doc in documents:
        doc_ref = db.collection(collection_name).document(doc['id'])
        doc_ref.set(doc['data'])
        print(f"Seeded {collection_name}/{doc['id']}")

        # Handle subcollections if present
        subcollections = doc.get("subcollections", {})
        for subcol_name, subdocs in subcollections.items():
            for subdoc in subdocs:
                subdoc_ref = doc_ref.collection(subcol_name).document(subdoc["id"])
                subdoc_ref.set(subdoc["data"])
                print(f"  ↳ Seeded {collection_name}/{doc['id']}/{subcol_name}/{subdoc['id']}")

def main():
    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred)
    db = firestore.client()

    with open("firestore.seed.json", "r") as f:
        data = json.load(f)

    for collection_name, documents in data.items():
        load_data(collection_name, documents, db)

if __name__ == "__main__":
    main()
