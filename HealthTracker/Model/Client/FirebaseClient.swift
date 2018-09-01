//
//  Firebase.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/4/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import Firebase

class FirebaseClient {
    
    private let db: Firestore! // = Firestore.firestore()
    
    init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func getDocuments(forType type: Constants.EntityType, completion: @escaping (_ documents: [[String:Any]]?, _ error: Error?) -> Void) {
        
        db.collection(type.rawValue.lowercased()).getDocuments { (snapshot, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            var documents = [[String:Any]]()
            
            // need to also add documentID
            for document in snapshot!.documents {
                var documentDict = document.data()
                documentDict["documentID"] = document.documentID
                documents.append(documentDict)
            }
            //_ = snapshot!.documents.map({ document in documents.append(document.data())})
            completion(documents, nil)
        }
    }
    
    func addDocument(ofType type: String, data: [String:Any]) -> DocumentReference? {
        let ref: DocumentReference? = db.collection(type).addDocument(data: data)
        return ref
    }
    
    func getDocument(ofType type: Constants.EntityType, documentID: String, completion: @escaping (_ snapshot: DocumentSnapshot?) -> Void) {
        let docRef = db.collection(type.rawValue.lowercased()).document(documentID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
        
    }
    
    func updateDocument(_ type: String, documentID: String, newData: [String:Any], completion: @escaping (_ error: NSError?) -> Void) {
        let docRef = db.collection(type.lowercased()).document(documentID)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            
            let document: DocumentSnapshot
            do {
                try document = transaction.getDocument(docRef)
                print(document)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                completion(fetchError)
            }
            
            transaction.updateData(newData, forDocument: docRef)
            return nil
        }) { (object, error) in
            if let error = error {
                completion(error as NSError)
            } else {
                completion(nil)
            }
        }
    }
    
    
}


