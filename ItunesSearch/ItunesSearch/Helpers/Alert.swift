//
//  Alert.swift
//  ItunesSearch
//
//  Created by Admin on 29.08.2018.
//  Copyright © 2018 Iulia Sigida. All rights reserved.
//

import Foundation
import UIKit

func showNetworkError(controller: UIViewController) {
    let alert = UIAlertController(title: "Whoops...",
                                  message: "There was an error accessing the iTunes Store. Please try again.",
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: "OK",
                               style: .default, handler: nil)
    alert.addAction(action)
    controller.present(alert, animated: true, completion: nil)
}
