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

struct APIEntry: Codable {
    let API: String
    let Category: String
    let Link: String
    let Description: String
}

struct ContentView: View {
    @State private var categories: Set<String> = []

    func fetch() {
        guard let url = URL(string: "https://api.publicapis.org/entries") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    let uniqueCategories = Set(response.entries.map { $0.Category })
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
        NavigationView {
            VStack {
                Text("Categories:")
                    .font(.headline)
                    .padding()

                List(categories.sorted(), id: \.self) { category in
                    NavigationLink(destination: APIListView(category: category)) {
                        Text(category)
                    }
                }
                .onAppear(perform: fetch)
            }
            .navigationTitle("Categories")
        }
    }
}

struct APIListView: View {
    let category: String
    @State private var apiList: [APIEntry] = []

    func fetch() {
        guard let url = URL(string: "https://api.publicapis.org/entries") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    let filteredAPIs = response.entries.filter { $0.Category == category }
                    DispatchQueue.main.async {
                        self.apiList = filteredAPIs
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }

    var body: some View {
        List(apiList, id: \.API) { api in
            VStack(alignment: .leading) {
                NavigationLink(destination: APILinkView(link: api.Link)) {
                    VStack(alignment: .leading) {
                        Text(api.API)
                            .font(.headline)
                        Text(api.Description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear(perform: fetch)
        .navigationTitle(category)
    }
}
struct APILinkView: View {
    let link: String
    
    var body: some View {
        VStack {
            Text("Link:")
                .font(.headline)
                .padding()
            Link(link, destination: URL(string: link)!)
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .navigationTitle("Link")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
