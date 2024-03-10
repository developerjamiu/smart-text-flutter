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
        let detector = NSDataDetector(dataTypes: DataDetectorType.allCases)
        
        let itemSpans: [DataDetectorResult] = detector.findMatches(in: text)
        
        return generateSmartTextItemsFromLinks(text: text, links: itemSpans)
    }
    
    private func generateSmartTextItemsFromLinks(text: String, links: [DataDetectorResult]) -> [ItemSpan] {
        var resultList = [ItemSpan]()
        
        if links.isEmpty {
            return text.isEmpty ? [ItemSpan(text: text, type: "text")] : []
        }
        
        var previousEnd = 0
        
        for link in links {
            let textBefore = String(text[text.index(text.startIndex, offsetBy: previousEnd)..<text.index(text.startIndex, offsetBy: link.start)])
            if !textBefore.isEmpty {
                resultList.append(ItemSpan(text: textBefore, type: "text"))
            }
            
            let entityType = link.type
            let linkType: String
            
            switch entityType {
            case .address:
                linkType = "address"
            case .phone:
                linkType = "phone"
            case .email:
                linkType = "email"
            case .datetime:
                linkType = "datetime"
            case .url:
                linkType = "url"
            }
            
            let linkSpan = ItemSpan(text: String(text[text.index(text.startIndex, offsetBy: link.start)..<text.index(text.startIndex, offsetBy: link.end)]), type: linkType)
            resultList.append(linkSpan)
            previousEnd = link.end
        }
        
        let textAfter = String(text[text.index(text.startIndex, offsetBy: links.last!.end)...])
        if !textAfter.isEmpty {
            resultList.append(ItemSpan(text: textAfter, type: "text"))
        }
        
        return resultList
    }
}

struct ItemSpan {
    let text: String
    let type: String
    
    func toMap() -> [String: Any] {
        return [
            "text": text,
            "type": type
        ]
    }
}
