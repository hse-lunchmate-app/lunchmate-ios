//
//  FilterViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 26.05.2024.
//

import Foundation


class FilterViewModel {
    
    // MARK: - Properties
    
    enum FilterType: String, CaseIterable {
        case office = "Офис"
    }
    
    let apiManager = APIManager.shared
    var offices = Dynamic([Office]())
    var userOfficeId: Int
    lazy var selectedIndexPath: [IndexPath] = {
        var array: [IndexPath] = []
        for i in 0..<FilterType.allCases.count {
            array.append(IndexPath(row: 0, section: i))
        }
        return array
    }()
    
    // MARK: - Init
    
    init(userOfficeId: Int) {
        self.userOfficeId = userOfficeId
    }
    
    // MARK: - Methods
    
    func getOffices() {
        apiManager.getOffices{ [weak self] result in
            switch result {
            case .success(let offices):
                self?.offices.value = offices
                for i in offices.enumerated() {
                    if i.element.id == self?.userOfficeId {
                        self?.selectedIndexPath[0] = IndexPath(row: i.offset, section: 0)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isAnotherOffice() -> Bool {
        return offices.value[selectedIndexPath[0].row].id != userOfficeId
    }
    
}
