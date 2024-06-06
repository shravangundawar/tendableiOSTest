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
}

class SurveyViewModel {
    private let network = NetworkManager()
    private var inspectionDataArray: InspectionDataModel?
    var questionsArray: [Question] = []
    var delegate: SurveyViewModelDelegate?
    var totalScore: Double = 0.0
    //MARK: Methods
    func fetchInspectionData(completion: @escaping (Result<InspectionDataModel, Error>) -> Void) {
        network.request(endpoint: AppConstants.APIConstants.inspection) { [weak self] (result: Result<InspectionDataModel, Error>) in
            switch result {
            case .success(let inspectionData):
                completion(.success(inspectionData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func prepareQuestionData() {
        fetchInspectionData { [weak self] result in
                switch result {
                case .success(let data):
                    self?.questionsArray = data.inspection.survey.categories.flatMap{$0.questions}
                    self?.delegate?.didQuestionPrepareSuccess()
                case .failure(let error):
                    debugPrint("Error fetching country data: \(error)")
                    self?.delegate?.didQuestionPrepareFail()
            }
        }
    }
    
    func calculateScore(selectedOption: AnswerChoice) {
        totalScore = totalScore + selectedOption.score
    }
    
}
