//
//  LVStorage.swift
//  boilerplate
//
//  Created by Leo Vigna on 20/12/2017.
//  Copyright © 2017 Leo Vigna. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase

///Firebase Storage Upload/Download
struct LVStorage {
    ///Firebase File Storage reference
    private let storageRef:StorageReference;
    
    /**
     Initialize Storage client
     
     - parameter url: Url for the storage reference.
     - returns: The Storage client.
     
     ## Example ##
     ````
     LVStorage(url:"http://storage.boilerplate.com")
     ````
     
     */
    init(url: String) {
        self.storageRef = Storage.storage().reference(forURL: url);
    }
    
    ///Initalize with Storage Reference
    init(ref: StorageReference) {
        self.storageRef = ref;
    }
    
    /**
     Uploads image to Firebase storage
     - parameter image: UIImage to upload.
     - parameter name: Image name.
     - parameter storage_endpoint: Endpoint folder to upload image.
     - returns: Promise with File metadata.
     */
    func uploadImageFile(image:UIImage, name:String, storage_endpoint:String? = "images") -> Promise<StorageMetadata> {
        return Promise { fulfill, reject in
            
            ///default is "images/" (eg. "driver_images/" ect...)
            let endpointRef = self.storageRef.child(storage_endpoint!)
            let imageRef = endpointRef.child(name + ".jpg")
            
            
            let resize = image.resizeToMax()
            let jpegData = resize?.compressToJpeg(compression:0.0)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // Upload file to path
            imageRef.putData(jpegData!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    // Uh-oh, an error occurred!
                    print(error?.localizedDescription ?? "Error upload")
                    reject(error!)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let downloadURL = metadata!.downloadURL()
                    print("Upload complete \(String(describing: downloadURL))")
                    
                    let fileURL = try! FileManager.default
                        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        .appendingPathComponent("\(name)")
                    try? jpegData?.write(to: fileURL)
                    
                    fulfill(metadata!)
                }
            }
        }
    }
    
    /**
     Downloads image from Firebase storage
     - parameter name: Image name.
     - parameter storage_endpoint: Endpoint folder from which to download image.
     - returns: Promise with UIImage.
     */
    func downloadImageFile(name: String, storage_endpoint:String = "images") -> Promise<UIImage> {
        return Promise { fulfill, reject in
            
            let fileURL = try! FileManager.default
                .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("\(name)") //\(storage_endpoint)/
            
            if let image = UIImage(contentsOfFile: fileURL.path)  {
                print("Cache load \(name) file")
                fulfill(image)
            }
                
            else {
                // Get storage reference
                //endpointRef = storage_ref/images  (or storage_ref/driver_images ect...) default is /images
                //imageRef = storage_ref/endpointRef/name
                let endpointRef = self.storageRef.child(storage_endpoint)
                let imageRef = endpointRef.child(name)
                
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        // Uh-oh, an error occurred!
                        print(error?.localizedDescription ?? "Error download")
                        reject(error!)
                    }
                    else {
                        print("Download complete \(name) file")
                        let image = UIImage(data: data!)
                        
                        try? data?.write(to: fileURL)
                        fulfill(image!)
                    }
                }
            }
        }
        
    }
}
