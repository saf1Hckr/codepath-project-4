//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Mubashirul Islam on 3/27/25.
//

import Foundation

struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}

class TriviaQuestionService {
    private let baseURL = "https://opentdb.com/api.php"
    
    /// Fetch trivia questions from the API
    /// - Parameters:
    ///   - amount: Number of questions to fetch (default is 5)
    ///   - completion: Callback function returning an array of `TriviaQuestion`
    func fetchQuestions(amount: Int = 5, completion: @escaping ([TriviaQuestion]?) -> Void) {
        let urlString = "\(baseURL)?amount=\(amount)&type=multiple"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                completion(nil)
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.results)
                }
            } catch {
                print("❌ Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
