//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

//import Foundation
//
//struct TriviaQuestion: Decodable {
//    let category: String
//    let question: String
//    let correctAnswer: String
//    let incorrectAnswers: [String]
//
//    var allAnswers: [String] {
//        ([correctAnswer] + incorrectAnswers).shuffled()
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case category
//        case question
//        case correctAnswer = "correct_answer"
//        case incorrectAnswers = "incorrect_answers"
//    }
//}


struct TriviaQuestion: Decodable {
    let category: String
    let type: String  // "multiple" or "boolean"
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    var allAnswers: [String] {
        if type == "boolean" {
            return ["True", "False"]
        }
        return ([correctAnswer] + incorrectAnswers).shuffled()
    }

    private enum CodingKeys: String, CodingKey {
        case category, type, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}
