// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 27/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import BookishImporter
import SwiftUI
import SwiftUIExtensions
import ThreadExtensions

struct AllBooksView: View {
    @EnvironmentObject var model: Model
    @FetchRequest(
        entity: CDBook.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) var books: FetchedResults<CDBook>

    @SceneStorage("selectedBook") var selectedBook = ""

    var body: some View {
        
        return VStack {
            List(selection: selection) {
                ForEach(books) { book in
                    if !book.isDeleted {
                        LinkView(book, selection: selection)
                    }
                }
                .onDelete(perform: handleDelete)
            }
        }
        .navigationTitle("All Books")
        .navigationBarItems(
            leading: EditButton(),
            trailing:
                HStack {
                    Button(action: handleAdd) { Image(systemName: "plus") }
                }
        )
    }

    
    var selection: Binding<UUID?> {
        Binding<UUID?> { () -> UUID? in
            print("selected book is \(selectedBook)")
            return selectedBook.isEmpty ? nil : UUID(uuidString: selectedBook)
        } set: { uuid in
            selectedBook = uuid?.uuidString ?? ""
            print("set to \(selectedBook)")
        }

    }
 
    func handleDelete(_ items: IndexSet?) {
        if let items = items {
            items.forEach { index in
                let book = books[index]
                model.delete(book)
            }
        }
    }
    
    func handleAdd() {
        let _ : CDBook = model.add()
    }
}
