//
//  PhoneNumberScreen.swift
//  Anupam_Aisle
//
//  Created by Anu on 17/08/23.
//

import UIKit
import Foundation

class PhoneNumberScreen: UIViewController {
    
    
    @IBOutlet weak var countryCode: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func PhoneNumberAPI() {
        
    
        // The URL for the API
        if let url = URL(string: "https://app.aisle.co/V1/users/phone_number_login") {

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            //Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let number = (countryCode.text ?? "+91") + "" + (phoneNumber.text ?? "9876543212")
         print(number)
            
            DataManager.shared.number = number
            
            // Dictionary to be sent as JSON in the request body
            let requestBody = [
                "number": number,
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
                        if (jsonResponse.first?.value) as! Int == 1 {
                           //print("Success")
                            DispatchQueue.main.async {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "OTPScreen") as! OTPScreen
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
 
    
    @IBAction func ContinuePhonePressed(_ sender: Any) {
        
        PhoneNumberAPI()
        
    }
    

}


