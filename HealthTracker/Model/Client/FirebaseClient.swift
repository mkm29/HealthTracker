//
//  Firebase.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/4/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import Firebase

class FirebaseClient {
    
    enum DocumentType: String {
        case cath = "cath"
        case bowel = "bowel"
        case medication = "medication"
    }
    
    private let db: Firestore! // = Firestore.firestore()
    
    init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func getDocuments(forType type: DocumentType, completion: @escaping (_ documents: [[String:Any]]?, _ error: Error?) -> Void) {
        
        db.collection(type.rawValue).getDocuments { (snapshot, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            var documents = [[String:Any]]()
            _ = snapshot!.documents.map({ document in documents.append(document.data())})
            completion(documents, nil)
        }
    }
    
    func addDocument(ofType type: String, data: [String:Any]) -> DocumentReference? {
        let ref: DocumentReference? = db.collection(type).addDocument(data: data)
        return ref
    }
    
}


