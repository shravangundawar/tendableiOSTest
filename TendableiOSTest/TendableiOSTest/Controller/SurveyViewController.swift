//
//  SurveyViewController.swift
//  TendableiOSTest
//
//  Created by Shravan Gundawar on 05/06/24.
//

import UIKit

class SurveyViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionOneButton: UIButton!
    @IBOutlet weak var optionTwoButton: UIButton!
    @IBOutlet weak var optionThreeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var scoreBackgroundView: UIView!
    
    var surveyVM: SurveyViewModel?
    var questioNumber: Int = 0
    var selectedAnswer: Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        surveyVM = SurveyViewModel()
        surveyVM?.delegate = self
        surveyVM?.prepareQuestionData()
    }
    
    func setupUI() {
        setupButtonCornerAndColor()
        resetButtons()
        setupView()
        optionOneButton.tag = 0
        optionTwoButton.tag = 1
        optionThreeButton.tag = 2
    }
    
    func showQuestionDetails(index: Int) {
        guard let questionData = surveyVM?.questionsArray[index] else { return }
        questionLabel.text = questionData.name
        optionOneButton.setTitle(questionData.answerChoices[0].name, for: .normal)
        optionTwoButton.setTitle(questionData.answerChoices[1].name, for: .normal)

        if questionData.answerChoices.count > 2 {
            optionThreeButton.isHidden = false
            optionThreeButton.setTitle(questionData.answerChoices[2].name, for: .normal)
        } else {
            optionThreeButton.isHidden = true
        }
    }
    
    func resetButtons() {
        let buttons = [optionOneButton, optionTwoButton, optionThreeButton]
        for button in buttons {
            button?.isSelected = false
            button?.backgroundColor = .lightGray
        }
        selectedAnswer = -1
    }

    func setupButtonCornerAndColor() {
        //set corner radius
        let buttons = [optionOneButton, optionTwoButton, optionThreeButton, nextButton]
        for button in buttons {
            button?.layer.cornerRadius = 10.0
            button?.clipsToBounds = true
        }
        
        //Other customisations
        nextButton.backgroundColor = .white
    }
    
    func setupView() {
        //set corner radius
        let views = [backgroundView, scoreBackgroundView]
        for vw in views {
            vw?.layer.cornerRadius = 10.0
            vw?.clipsToBounds = true
        }
        
        //Other customisations
        backgroundView.backgroundColor = .orange
        scoreBackgroundView.isHidden = true
    }
    
    @IBAction func answerOptionButtonTapped(_ sender: UIButton) {
        resetButtons()
        sender.isSelected = true
        sender.backgroundColor = .green
        selectedAnswer = sender.tag
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard selectedAnswer >= 0 else { return }
        guard let questionData = surveyVM?.questionsArray else { return }
        let selectedAnswer = questionData[(questioNumber)].answerChoices[(selectedAnswer)]
        surveyVM?.calculateScore(selectedOption: selectedAnswer)
        resetButtons()

        if questioNumber == (questionData.count - 1) { //last question
            backgroundView.removeFromSuperview()
            scoreBackgroundView.isHidden = false
            totalScoreLabel.text = String(describing: surveyVM?.totalScore ?? 0.0)
        } else {
            questioNumber += 1
            if (questioNumber) < questionData.count {
                if (questioNumber) == (questionData.count - 1) {
                    nextButton.setTitle("Submit", for: .normal)
                }
                showQuestionDetails(index: (questioNumber))
            } else {
                backgroundView.isHidden = true
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: UIView.AnimationOptions(), animations: { [weak self] in
            
            if self?.questioNumber != (questionData.count) { //last question
                self?.backgroundView.frame = CGRect(x: -(self?.view.frame.size.width ?? 0.0), y: 0, width: self?.view.frame.size.width ?? 0.0 ,height: self?.view.frame.size.height ?? 0.0)
            }
        }) { _ in

        }
    }
}

extension SurveyViewController: SurveyViewModelDelegate {
    func didQuestionPrepareSuccess() {
        DispatchQueue.main.async {[weak self] in
            self?.showQuestionDetails(index: (self?.questioNumber)!)
        }
    }
    
    func didQuestionPrepareFail() {
        
    }
}
