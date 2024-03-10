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
        case url
        case email
        case phone
        case address
        case datetime
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
                return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .email)
            } else {
                return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .url)
            }
        } else if match.resultType == .phoneNumber {
            return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .phone)
        } else if match.resultType == .address {
            return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .address)
        } else if match.resultType == .date {
            return DataDetectorResult(start: match.range.lowerBound,end: match.range.upperBound, type: .datetime)
        }
        
        return nil
    }
    
    
}
