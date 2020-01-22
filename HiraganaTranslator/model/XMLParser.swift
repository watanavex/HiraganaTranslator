//
//  XMLParser.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/22.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import Foundation
import Ji

enum XMLParseError: Error {
    case invalidData
    case invalidXML(nodeName: String?)
    case invalidContent(nodeName: String?)
}

struct Word: Equatable {
    let surface: String
    let furigana: String
}

func parseXML(data: Data) throws -> [Word] {
    guard let jiDoc = Ji(xmlData: data) else {
        throw XMLParseError.invalidData
    }
    
    // <ResultSet>
    guard let resultSetNode = jiDoc.rootNode else {
        throw XMLParseError.invalidXML(nodeName: "Root")
    }
    // <Result>
    guard let resultNode = resultSetNode.firstChild else {
        throw XMLParseError.invalidXML(nodeName: resultSetNode.name)
    }
    // <WordList>
    guard let wordListNode = resultNode.firstChild else {
        throw XMLParseError.invalidXML(nodeName: resultNode.name)
    }
    
    // <Word>
    return try wordListNode.children.map { wordNode -> Word in
        // <Surface>
        guard let surfaceNode = wordNode.childrenWithName("Surface").first else {
            throw XMLParseError.invalidXML(nodeName: wordNode.name)
        }
        guard let surface = surfaceNode.content else {
            throw XMLParseError.invalidContent(nodeName: surfaceNode.name)
        }
        
        // <Furigana>
        guard let furiganaNode = wordNode.childrenWithName("Furigana").first else {
            throw XMLParseError.invalidXML(nodeName: wordNode.name)
        }
        guard let furigana = furiganaNode.content else {
            throw XMLParseError.invalidContent(nodeName: furiganaNode.name)
        }
        
        return Word(surface: surface, furigana: furigana)
    }
}
