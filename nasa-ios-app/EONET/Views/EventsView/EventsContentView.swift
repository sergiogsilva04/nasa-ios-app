import SwiftUI

/// A view that displays the content of events.
struct EventContentView: View {
    @ObservedObject var viewModel: EventsViewModel

    var body: some View {
        // HStack containing the info button and category picker
        HStack {
            // Info button for displaying category information
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
        
                    // Display selected category title and description
                    let selectedCategory = viewModel.getCategoryById(categoryId: viewModel.selectedCategoryId)
                
                    Text(selectedCategory?.title ?? "Category")
                        .font(.title)
                        .padding(.bottom, 5)
                    
                    Text(selectedCategory?.description ?? "Description")
                }
                .padding()
                .presentationDetents([.height(200)])
            }
            
            // Category picker for selecting event categories
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

        // Picker for selecting the event status
        Picker("Status", selection: $viewModel.selectedEventsStatus) {
            ForEach(viewModel.eventsStatus, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        
        // HStack containing the filters button, list/grid toggle, and spacer
        HStack() {
            Spacer()
            
            // Button for showing the filters dialog
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
                    
                    // Display filter options
                    FilterView(viewModel: viewModel)
                }
                .padding()
                .presentationDetents([.height(viewModel.priorDaysFilter > 0 ? 260 : 350)])
            }
            
            // Toggle for switching between list and grid view modes
            Toggle(isOn: $viewModel.isListModeActive) {
                Text("Lista?")
            }
            .frame(width: 140)
            
            Spacer()
        }
    
        // Display appropriate content based on filtered events
        if (viewModel.filteredEvents.isEmpty) {
            // Display "No Results Found" message if there are no events matching the filters
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
            // Display either the list or grid view based on the selected mode
            if (viewModel.isListModeActive) {
                EventsListView(viewModel: viewModel)
                
            } else {
                EventsGridView(viewModel: viewModel)
            }
        }
    }
}

/// A preview provider for EventContentView.
struct EventContentView_Previews: PreviewProvider {
    static var previews: some View {
        EventContentView(viewModel: EventsView().viewModel)
    }
}
