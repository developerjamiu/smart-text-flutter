//
//  SmartTextFlutterBridge.swift
//  Runner
//
//  Created by Jamiu Okanlawon on 09/03/2024.
//

import Foundation

protocol TextClassifier {
    func classifyText(text: String) -> [ItemSpan]
}

class AppleTextClassifier : TextClassifier {
    func classifyText(text: String) -> [ItemSpan] {
        let normalizedText = text.replacingOccurrences(of: "\r\n", with: "\n")
        
        let detector = NSDataDetector(dataTypes: DataDetectorType.allCases)
        
        let itemSpans: [DataDetectorResult] = detector.findMatches(in: normalizedText)
        
        return generateSmartTextItemsFromLinks(text: normalizedText, links: itemSpans)
    }
    
    private func generateSmartTextItemsFromLinks(text: String, links: [DataDetectorResult]) -> [ItemSpan] {
        var resultList = [ItemSpan]()
        
        if links.isEmpty {
            return text.isEmpty ? [ItemSpan(text: text, type: "text", rawValue: text)] : []
        }
        
        var previousEnd = 0
        let textUTF16 = text.utf16
        
        for link in links {
            let utf16Start = textUTF16.index(textUTF16.startIndex, offsetBy: link.start)
            let utf16End = textUTF16.index(textUTF16.startIndex, offsetBy: link.end)
            
            // Convert UTF-16 indexes to String indexes
            let startIndex = String.Index(utf16Start, within: text)!
            let endIndex = String.Index(utf16End, within: text)!
            
            if previousEnd < link.start {
                let textBefore = String(text[text.index(text.startIndex, offsetBy: previousEnd)..<startIndex])
                if !textBefore.isEmpty {
                    resultList.append(ItemSpan(text: textBefore, type: "text", rawValue: textBefore))
                }
            }
            
            let entityType = link.type
            let linkType: String
            let rawValue: String
            
            switch entityType {
            case .address(let address):
                linkType = "address"
                rawValue = address
            case .phone(let phone):
                linkType = "phone"
                rawValue = phone
            case .email(let email):
                linkType = "email"
                rawValue = email
            case .datetime(let date):
                linkType = "datetime"
                rawValue = date
            case .url(let url):
                linkType = "url"
                rawValue = url
            }
            
            let linkText = String(text[startIndex..<endIndex])
            resultList.append(ItemSpan(text: linkText, type: linkType, rawValue: rawValue))
            
            previousEnd = link.end
        }
        
       
        if previousEnd < text.count {
            let textAfter = String(text[text.index(text.startIndex, offsetBy: previousEnd)...])
            if !textAfter.isEmpty {
                resultList.append(ItemSpan(text: textAfter, type: "text", rawValue: textAfter))
            }
        }
        
        return resultList
    }

}

struct ItemSpan {
    let text: String
    let type: String
    let rawValue: String
    
    func toMap() -> [String: Any] {
        return [
            "text": text,
            "type": type,
            "rawValue": rawValue
        ]
    }
}
