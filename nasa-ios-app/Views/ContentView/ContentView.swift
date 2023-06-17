import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        LoadingView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
            NavigationView {
                VStack {
                    Text("Natural Event Tracker")
                        .font(.system(size: 35))
        
                    VStack {
                        HStack {
                            Button(action: {
                                viewModel.isShowingCategoryInfo = true
                            }) {
                                Image(systemName: "info.circle")
                            }
                            .disabled($viewModel.selectedCategoryId.wrappedValue == "all")
                            .foregroundColor($viewModel.selectedCategoryId.wrappedValue == "all" ? .gray : .blue)
                            .sheet(isPresented: $viewModel.isShowingCategoryInfo) {
                                VStack {
                                    Rectangle()
                                       .frame(width: 40, height: 5)
                                       .cornerRadius(2.5)
                                       .foregroundColor(Color.secondary)
                        
                                    let selectedCategory = viewModel.getCategoryById(categoryId: viewModel.selectedCategoryId)
                                
                                    Text(selectedCategory?.title ?? "Category")
                                        .font(.title)
                                        .padding(.bottom, 5)
                                    
                                    Text(selectedCategory?.description ?? "Description")
                                }
                                .padding()
                                .presentationDetents([.height(200)])
                            }
                            
                            Picker("Category", selection: $viewModel.selectedCategoryId) {
                                ForEach(viewModel.categoriesList) { category in
                                    HStack {
                                        Image(category.id)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30, height: 30)
                                        
                                        Text(category.title)
                                   }
                                    .tag(category.id)
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .foregroundColor(.black)
                        }
                    
                        Picker("Status", selection: $viewModel.selectedEventsStatus) {
                            ForEach(viewModel.eventsStatus, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Spacer(minLength: 20)
                    
                    if (viewModel.filteredEvents.isEmpty) {
                        VStack {
                            Image(systemName: "exclamationmark.circle")
                                .font(.largeTitle)
                            
                            Text("No Results Found")
                                .font(.title)
                            
                            Text("Try adjusting your filter criteria.")
                                .font(.body)
                        }
                        .foregroundColor(.gray)
                        .padding()
                        .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                    } else {
                        List(viewModel.filteredEvents) { event in
                            NavigationLink {
                                EventInfoView(event: event)
                                
                            } label: {
                                EventRowView(event: event)
                            }
                            .listRowBackground(event.closed == nil ? Color.green : Color.red)
                    
                        }
                        .cornerRadius(15)
                        .listStyle(.plain)
                    }
                }
            }
            .padding(15)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
