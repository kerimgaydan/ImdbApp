//
//  ContentView.swift
//  ImdbApp
//
//  Created by Kerim Gaydan on 31.05.2023.
//

import SwiftUI
struct APIResponse: Codable {
    let entries: [APIEntry]
}
struct APIEntry : Codable{
    let API: String
    let Category: String
    let Link: String
    let Description: String
}
struct ContentView: View {
    @State private var categories: Set<String> = []
    func fetch() {
        guard let url = URL(string: "https://api.publicapis.org/entries") else{
            print("error")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    let uniqueCategories = Set(response.entries.map{ $0.Category})
                    DispatchQueue.main.async {
                        self.categories = uniqueCategories
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    
                }
            }
        }.resume()
    }
    var body: some View {
        VStack {
            Text("Categories:")
                .font(.headline)
                .padding()
            
            List(categories.sorted(), id: \.self) { Category in
                Text(Category)
            }
            .onAppear(perform: fetch)
        }
    }
    
}

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
