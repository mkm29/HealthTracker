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
    
    func getDocument(ofType type: Constants.EntityType, documentID: String) {
        let docRef = db.collection(type.rawValue.lowercased()).document(documentID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func updateDocument(docRef: DocumentReference, newData: [String:Any]) {
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            
            let document: DocumentSnapshot
            do {
                try document = transaction.getDocument(docRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            transaction.updateData(newData, forDocument: docRef)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
    
    
}


