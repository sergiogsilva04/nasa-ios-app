import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Natural Event tracker")
                    .font(.system(size: 35))
                
                VStack {
                    HStack {
                        Button(action: {
                            viewModel.isShowingCategoryInfo = true
                        }) {
                            Image(systemName: "info.circle")
                        }
                        .foregroundColor(.blue)
                        .sheet(isPresented: $viewModel.isShowingCategoryInfo) {
                            VStack {
                                Rectangle()
                                   .frame(width: 40, height: 5)
                                   .cornerRadius(2.5)
                                   .foregroundColor(Color.secondary)
                                
//                                Text(viewModel.selectedCategory?.title ?? "Category").font(.title)
//                                Text(viewModel.selectedCategory?.description ?? "Description")
                            }
                            .padding()
                            .presentationDetents([.height(200)])
                        }
                        
                        Picker("Category", selection: $viewModel.selectedCategory) {
                            ForEach(viewModel.categoriesList, id: \.id) {
                                Text($0.title).tag($0.id)
                            }
                        }
                    }
                
                    Picker("Status", selection: $viewModel.selectedEventsStatus) {
                        ForEach(viewModel.eventsStatus, id: \.self) {
                            Text($0)
                        }
                        
                    }
                    .pickerStyle(.segmented)
                }
                
                Spacer(minLength: 20)
                
                List(viewModel.filteredEvents) { event in
                    NavigationLink {
                        Text("teste")
                        
                    } label: {
                        EventRow(event: event)
                    }
                    .listRowBackground(event.closed == nil ? Color.green : Color.red)
                }
                .cornerRadius(15)
                .listStyle(.plain)
            }
        }
        .padding(15)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
