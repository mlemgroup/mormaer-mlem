//
//  JSONDecoder+dateDecodingStrategyFormatters.swift
//  Mlem
//
//  Created by tht7 on 18/06/2023.
//

import Foundation

extension DateFormatter {
    static let expandedTWithTimezone: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    
    static let expandedT: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    
    static let standardT: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()

    static let standard: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()

    static let yearMonthDay: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
}

extension JSONDecoder {

    /// Assign multiple DateFormatter to dateDecodingStrategy
    ///
    /// Usage :
    ///
    ///      decoder.dateDecodingStrategyFormatters = [ DateFormatter.standard, DateFormatter.yearMonthDay ]
    ///
    /// The decoder will now be able to decode two DateFormat, the 'standard' one and the 'yearMonthDay'
    ///
    /// Throws a 'DecodingError.dataCorruptedError' if an unsupported date format is found while parsing the document
    var dateDecodingStrategyFormatters: [DateFormatter]? {
        @available(*, unavailable, message: "This variable is meant to be set only")
        get { return nil }
        set {
            guard let formatters = newValue else { return }
            self.dateDecodingStrategy = .custom { decoder in

                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)

                for formatter in formatters {
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                }

                throw DecodingError.failedToDecode //.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            }
        }
    }
}
