//
//  ViewModel.swift
//  ImdbApp
//
//  Created by Kerim Gaydan on 31.05.2023.
//

import Foundation
import SwiftUI

struct Api: Hashable, Codable {
    let categories
    
}

class ViewModel: ObservableObject {
    @Published var apies: [Api] = []
    func fetch () {
        guard let url = URL(string: "https://api.publicapis.org/entries") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let apies = try JSONDecoder().decode([Api].self, from: data)
                DispatchQueue.main.async {
                    self?.apies = apies
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
