import SwiftUI

struct EventsView: View {
    @StateObject var viewModel = EventsViewModel()

    var body: some View {
        VStack {
            if (Common.checkInternetAvailability()) {
                LoadingView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                    NavigationView {
                        VStack {
                            Text("Natural Event Track")
                                .font(.system(size: 35))
                
                            VStack {
                                HStack {
                                    Button(action: {
                                        viewModel.isShowingCategoryInfoDialog = true
                                    }) {
                                        Image(systemName: "info.circle")
                                    }
                                    .disabled($viewModel.selectedCategoryId.wrappedValue == "all")
                                    .foregroundColor($viewModel.selectedCategoryId.wrappedValue == "all" ? .gray : .blue)
                                    .sheet(isPresented: $viewModel.isShowingCategoryInfoDialog) {
                                        VStack {
                                            Rectangle()
                                               .frame(width: 40, height: 5)
                                               .cornerRadius(2.5)
                                               .foregroundColor(.secondary)
                                
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
                                    .padding(.bottom, 5)
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
            } else {
                Image(systemName: "wifi.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.red)
                
                Text("No internet connection")
                
                Button(action: {
                    print("checked internet")
                    viewModel.getData()
                    
                }) {
                    Text("Retry")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            viewModel.getData()
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
