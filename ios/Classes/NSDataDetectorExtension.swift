//
//  SmartTextFlutterBridge.swift
//  Runner
//
//  Created by Jamiu Okanlawon on 09/03/2024.
//
import Foundation

enum DataDetectorType: CaseIterable {
    case url
    case date
    case address
    case phoneNumber
    
    var nsDetectorType: NSTextCheckingResult.CheckingType {
        switch self {
        case .url:
            return .link
        case .address:
            return .address
        case .phoneNumber:
            return .phoneNumber
        case .date:
            return .date
        }
    }
}

struct DataDetectorResult {
    let start: Int
    let end: Int
    let type: ResultType
    
    enum ResultType {
        case url(String)
        case email(String)
        case phone(String)
        case address(String)
        case datetime(String)
    }
}


extension NSDataDetector {
    convenience init(dataTypes: [DataDetectorType]) {
        if dataTypes.isEmpty {
            preconditionFailure("dataTypes array cannot be empty")
        }
        
        var result = dataTypes.first!.nsDetectorType.rawValue
        for type in dataTypes.dropFirst() {
            result = result | type.nsDetectorType.rawValue
        }
        
        try! self.init(types: result)
    }
    
    func findMatches(in text: String) -> [DataDetectorResult] {
        let matches = matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        return matches.compactMap { (match) -> DataDetectorResult? in
            guard let range = Range(match.range, in: text) else { return nil }
            
            return processMatch(match, range: range)
        }
    }
    
    private func processMatch(_ match: NSTextCheckingResult, range: Range<String.Index>) -> DataDetectorResult? {
        if match.resultType == .link {
            guard let url = match.url else { return nil }
            
            if url.absoluteString.hasPrefix("mailto:") {
                return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .email(url.absoluteString))
            } else {
                return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .url(url.absoluteString))
            }
        } else if match.resultType == .phoneNumber {
            guard let phone = match.phoneNumber else { return nil }
            
            return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .phone("tel://" + phone))
        } else if match.resultType == .address {
            guard let address = match.addressComponents?.values.first else { return nil }
            
            return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .address(address))
        } else if match.resultType == .date {
            guard let date = match.date else { return nil }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dateString = dateFormatter.string(from: date)
            
            return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .datetime(dateString))
        }
        
        return nil
    }
}
