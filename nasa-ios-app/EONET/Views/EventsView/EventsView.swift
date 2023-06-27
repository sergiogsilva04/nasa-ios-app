import SwiftUI

struct EventsView: View {
    @StateObject var viewModel = EventsViewModel()

    var body: some View {
        NavigationStack {
            Text("Natural Event Tracker")
                .pageTitleTextStyle()
            
            if (Common.checkInternetAvailability()) {
                LoadingDialogView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                        VStack {
                            HStack {
                                Button {
                                    viewModel.isShowingCategoryInfoDialog = true

                                } label: {
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
                            
                            HStack() {
                                Button {
                                    viewModel.isShowingFiltersDialog = true
                                    
                                } label: {
                                    Image(systemName: "line.horizontal.3.decrease.circle")
                                        .imageScale(.large)
                                    
                                    Text("Show filters")
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .sheet(isPresented: $viewModel.isShowingFiltersDialog) {
                                    VStack {
                                        Rectangle()
                                            .frame(width: 40, height: 5)
                                            .cornerRadius(2.5)
                                            .foregroundColor(.secondary)
                                        
                                        FilterView(viewModel: viewModel)
                                    }
                                    .padding()
                                    .presentationDetents([.height(viewModel.priorDaysFilter > 0 ? 260 : 350)])
                                }
                                
                                Toggle(isOn: $viewModel.isListModeActive) {
                                    Text("Lista?")
                                }
                                .frame(width: 160)
                            }
                        
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
                                if (viewModel.isListModeActive) {
                                    EventsListView(viewModel: viewModel)
                                    
                                } else {
                                    EventsGridView(viewModel: viewModel)
                                }
                            }
                        }
                    }
                    .padding(15)
                
            } else {
                NoInternetConnectionView {
                    viewModel.getData()
                }
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
