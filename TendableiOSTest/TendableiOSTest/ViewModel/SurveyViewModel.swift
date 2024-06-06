//
//  SurveyViewModel.swift
//  TendableiOSTest
//
//  Created by Shravan Gundawar on 05/06/24.
//

import Foundation

protocol SurveyViewModelDelegate {
    func didQuestionPrepareSuccess()
    func didQuestionPrepareFail()
    func didSubmitSurveySuccess()
    func didSubmitSurveyFail()
    func didNetworkErrorOccure()
}

class SurveyViewModel {
    
    //MARK: Properties
    private let network = NetworkManager()
    var questionsArray: [Question] = []
    var delegate: SurveyViewModelDelegate?
    var totalScore: Double = 0.0
    let userDefaultsManager = UserDefaultsManager()
    private var completedQuestionsArray: [Question] = []
    private var inspectionId: Int = 0
    
    
    //MARK: Methods
    func fetchInspectionData(completion: @escaping (Result<InspectionDataModel, Error>) -> Void) {
        if !NetworkReachability.shared.isNetworkAvailable {
            delegate?.didNetworkErrorOccure()
            return
        }
        network.request(endpoint: AppConstants.APIConstants.inspection) { (result: Result<InspectionDataModel, Error>) in
            switch result {
            case .success(let inspectionData):
                completion(.success(inspectionData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func submitSurvey() {
        if !NetworkReachability.shared.isNetworkAvailable {
            delegate?.didNetworkErrorOccure()
            return
        }
        let surveyDetails = SurveyDetails(id: inspectionId, answeredQuestions: completedQuestionsArray)
        let surveyData = SurveyData(inspection: surveyDetails)

        network.postRequest(endpoint: AppConstants.APIConstants.submit, requestBody: surveyData) { [weak self] (result: Result<(ResponseData, Int), Error>) in
            switch result {
            case .success( (_, _)):
                self?.delegate?.didSubmitSurveySuccess()
            case .failure(_):
                self?.delegate?.didSubmitSurveyFail()
            }
        }
    }
    
    func prepareQuestionData() {
        fetchInspectionData { [weak self] result in
                switch result {
                case .success(let data):
                    self?.inspectionId = data.inspection.id
                    self?.questionsArray = data.inspection.survey.categories.flatMap{$0.questions}
                    self?.delegate?.didQuestionPrepareSuccess()
                case .failure(let error):
                    debugPrint("Error fetching country data: \(error)")
                    self?.delegate?.didQuestionPrepareFail()
            }
        }
        totalScore = getLastTotalScore()
    }
    
    func getLastQuestionNumber() -> Int {
        if let previousQuestionNumber: Int = userDefaultsManager.get(forKey: "questionNumber") {
            return previousQuestionNumber
        }
        return 0
    }
    
    func setCurrentQuestionNumber(questionNumber: Int) {
        userDefaultsManager.set(questionNumber, forKey: "questionNumber")
    }
    
    func getLastTotalScore() -> Double {
        if let lastScore: Double = userDefaultsManager.get(forKey: "totalScore") {
            return lastScore
        }
        
        return 0.0
    }
    
    func setCurrentTotalScore(totalScore: Double) {
        userDefaultsManager.set(totalScore, forKey: "totalScore")
    }
    
    func resetSurveyLocalData() {
        userDefaultsManager.set(0, forKey: "questionNumber")
        userDefaultsManager.set(0.0, forKey: "totalScore")
    }
    
    func calculateScore(currentQuestion: Question, selectedAnswer: Int) {
        completedQuestionsArray.append(currentQuestion)
        let selectedOption = currentQuestion.answerChoices[selectedAnswer]
        totalScore = totalScore + selectedOption.score
        setCurrentTotalScore(totalScore: totalScore)
    }
    
}
