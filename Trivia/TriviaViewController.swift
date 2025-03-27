//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit


struct TriviaAPIResponse: Decodable {
    let results: [TriviaQuestion]
}


class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
    private var questions: [TriviaQuestion] = []

  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    fetchTriviaQuestions()
  }
  
  private func fetchTriviaQuestions() {
    // Example code for fetching trivia questions from an API
      let url = URL(string: "https://opentdb.com/api.php?amount=10&type=multiple")!

    let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      if let error = error {
        print("Error fetching trivia questions: \(error)")
        return
      }
      guard let data = data else { return }
      do {
        let response = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
        self?.questions = response.results
        DispatchQueue.main.async {
          self?.updateQuestion(withQuestionIndex: self?.currQuestionIndex ?? 0)
        }
      } catch {
        print("Error decoding trivia questions: \(error)")
      }
    }
    task.resume()
  }
  
//  private func updateQuestion(withQuestionIndex questionIndex: Int) {
//    guard questions.indices.contains(questionIndex) else { return }
//    
//    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
//    let question = questions[questionIndex]
//    questionLabel.text = question.question
//    categoryLabel.text = question.category
//    let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
//    
//    // Hide all answer buttons first
//    answerButton0.isHidden = true
//    answerButton1.isHidden = true
//    answerButton2.isHidden = true
//    answerButton3.isHidden = true
//    
//    // Display answers
//    if answers.count > 0 {
//      answerButton0.setTitle(answers[0], for: .normal)
//      answerButton0.isHidden = false
//    }
//    if answers.count > 1 {
//      answerButton1.setTitle(answers[1], for: .normal)
//      answerButton1.isHidden = false
//    }
//    if answers.count > 2 {
//      answerButton2.setTitle(answers[2], for: .normal)
//      answerButton2.isHidden = false
//    }
//    if answers.count > 3 {
//      answerButton3.setTitle(answers[3], for: .normal)
//      answerButton3.isHidden = false
//    }
//  }
    
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        guard questions.indices.contains(questionIndex) else { return }

        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        let question = questions[questionIndex]
        questionLabel.text = question.question
        categoryLabel.text = question.category
        let answers = question.allAnswers

        // Hide all buttons first
        answerButton0.isHidden = true
        answerButton1.isHidden = true
        answerButton2.isHidden = true
        answerButton3.isHidden = true

        // Show only the necessary number of buttons
        let buttons = [answerButton0, answerButton1, answerButton2, answerButton3]
        for (index, button) in buttons.enumerated() {
            if index < answers.count {
                button?.setTitle(answers[index], for: .normal)
                button?.isHidden = false
            }
        }
    }
  
  private func updateToNextQuestion(answer: String) {
    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
    return answer == questions[currQuestionIndex].correctAnswer
  }
  
  private func showFinalScore() {
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                            preferredStyle: .alert)
    let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
      currQuestionIndex = 0
      numCorrectQuestions = 0
      updateQuestion(withQuestionIndex: currQuestionIndex)
    }
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

// Data model to decode the trivia response

