//
//  ViewController.swift
//  HackifyEverything
//
//  Created by Ryan Klein on 12/19/17.
//  Copyright © 2017 Base11 Studios. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAuthCore
import AWSCore
import AWSAPIGateway

class ViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        doInvokeAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func doInvokeAPI() {
        // change the method name, or path or the query string parameters here as desired
        let httpMethodName = "GET"
        let URLString = "/HelloWorld"
        let queryStringParameters = ["TableName":"HackifyEverything"]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: nil)
        
        // Create a service configuration object for the region your AWS API was created in
        let serviceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast1,
            credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_CSVYYQ2BKL_LambdaMicroserviceClient.register(with: serviceConfiguration!, forKey: "CloudLogicAPIKey")
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient =
            AWSAPI_CSVYYQ2BKL_LambdaMicroserviceClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { [weak self](
            task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            // Handle successful result here
            let result = task.result!
            let responseString =
                String(data: result.responseData!, encoding: .utf8)
            DispatchQueue.main.async {
                self?.textLabel.text = responseString!
            }
            print(responseString)
            print(result.statusCode)
            
            return nil
        }
    }
}

