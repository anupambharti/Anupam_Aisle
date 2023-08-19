//
//  OTPScreen.swift
//  Anupam_Aisle
//
//  Created by Anu on 18/08/23.
//

import UIKit

class OTPScreen: UIViewController {
    
    @IBOutlet weak var otpField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    func OTPAPI() {
      

        // The URL for the API endpoint
        if let url = URL(string: "https://app.aisle.co/V1/users/verify_otp") {

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            //Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let number = DataManager.shared.number

            // Dictionary to be sent as JSON in the request body
            let requestBody = [
                "number": number as Any,
                "otp": otpField.text as Any
            ]

            do {
                // Convert the dictionary to JSON data
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                print("Error converting dictionary to JSON")
                return
            }

            // Create and start the task
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error occurred: \(String(describing: error))")
                    return
                }

                do {
                    // Convert the response data to a dictionary
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print(jsonResponse)
                        print(jsonResponse.first?.value as Any)
                        if (jsonResponse.first?.value) != nil {
                           print("Success")
                            DataManager.shared.token = ((jsonResponse.first?.value) as! String)
                            DispatchQueue.main.async {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "NotesScreen") as! NotesScreen
                                self.navigationController?.pushViewController(resultViewController, animated: true)
                            }
                        }
                    }
                } catch {
                    print("Error parsing response JSON")
                }
            }

            task.resume()
        }

    }
    
    
    @IBAction func ContinueOTPPressed(_ sender: Any) {
        
        OTPAPI()
        
    }
    
}
