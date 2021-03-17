// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI
import SwiftUIExtensions
import ThreadExtensions

extension Binding where Value == String? {
    func onNone(_ fallback: String) -> Binding<String> {
        return Binding<String>(get: {
            return self.wrappedValue ?? fallback
        }) { value in
            self.wrappedValue = value
        }
    }
}

struct ListView: View {
    @EnvironmentObject var model: Model
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editMode
    @ObservedObject var list: CDList
    @State var selectedBook: UUID?
    
    var body: some View {
        
        return VStack {
            TextField("Notes", text: list.binding(forProperty: "notes"))
                .padding()

            if editMode?.wrappedValue == .active {
                FieldEditorView(fields: list.fields)
            }
            
            List(selection: $selectedBook) {
                ForEach(list.sortedBooks) { book in
                    LinkView(BookInList(book, in: list), selection: $selectedBook)
                }
                .onDelete(perform: handleDelete)
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                DeferredTextField(label: "Name", text: $list.name)
            }

            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: handleAdd) { Image(systemName: "plus") }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: handleDeleteList) { Image(systemName: "ellipsis.circle") }
            }
        }
    }

    func handleDelete(_ items: IndexSet?) {
        if let items = items {
            items.forEach { index in
                let entry = list.sortedBooks[index]
                model.delete(entry)
            }
            model.save()
        }
    }
    
    func handleDeleteList() {
        model.delete(list)
    }
    
    func handleAdd() {
        let book = CDBook(context: context)
        list.add(book)
        model.save()
    }

}
