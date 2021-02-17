// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/02/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Combine
import Foundation

class FieldList: ObservableObject {
    @Published var fields: [Field] = []
    fileprivate var watchers: [AnyCancellable] = []
    
    init() {
    }
    
    init(decodedFrom strings: [String]) {
        print("Decoding \(strings)")
        fields = strings.map({ string in
            let items = string.split(separator: "•", maxSplits: 1)
            let kind = Field.Kind(rawValue: String(items[0])) ?? .string
            return makeField(name: String(items[1]), kind: kind)
        })
    }
    
    var encoded: [String] {
        let strings = fields.map({ field in
            "\(field.kind)•\(field.key)"
        })
        return strings
    }
    
    func newField() {
        fields.append(makeField())
    }
    
    func makeField(name: String? = nil, kind: Field.Kind = .string) -> Field {
        let key = name ?? "Untitled \(kind)"
        let field = Field(key: key, kind: kind)
        let watcher = field.objectWillChange.sink {
            print("field \(key) changed")
            self.objectWillChange.send()
        }
        self.watchers.append(watcher)
        
        return field
    }

    func moveFields(fromOffsets from: IndexSet, toOffset to: Int) {
        fields.move(fromOffsets: from, toOffset: to)
    }

    func deleteFields(atOffsets offsets: IndexSet) {
        fields.remove(atOffsets: offsets)
    }

}