//
//  NotesScreen.swift
//  Anupam_Aisle
//
//  Created by Anu on 18/08/23.
//

import UIKit

class NotesScreen: UIViewController {
    
    var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        token = DataManager.shared.token
        NotesAPI()
        
    }
    
    func NotesAPI() {
        

        // URL for the request
        if let url = URL(string: "https://app.aisle.co/V1/users/test_profile_list") {
            var request = URLRequest(url: url)

            // Specify the method 
            request.httpMethod = "GET"

            // Add custom headers
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token!, forHTTPHeaderField: "Authorization")

            // Initialize the data task
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle potential errors
                if let error = error {
                    print("Error:", error.localizedDescription)
                    return
                }

                // Check for the response and data
                if let httpResponse = response as? HTTPURLResponse, let data = data {
                    print("HTTP Status Code:", httpResponse.statusCode)
                    
                    // Parse JSON or handle data
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("JSON:", json)
                        }
                    } catch {
                        print("JSON Parsing Error:", error.localizedDescription)
                    }
                }
            }

            // Start the task
            task.resume()
        }

        
    }

 
}
