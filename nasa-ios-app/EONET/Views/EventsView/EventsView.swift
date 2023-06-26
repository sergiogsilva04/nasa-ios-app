import SwiftUI

struct EventsView: View {
    @StateObject var viewModel = EventsViewModel()

    var body: some View {
        VStack {
            Text("Natural Event Tracker")
                .multilineTextAlignment(.center)
                .font(.system(size: 35))
            
            if (Common.checkInternetAvailability()) {
                Spacer()
                
                LoadingView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                    VStack {
                        NavigationView {
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
                                
                                DisclosureGroup {
                                    ZStack {
                                        Color
                                            .gray
                                            .opacity(0.1)
                                            .cornerRadius(20)
                                        
                                        VStack {
                                            Spacer(minLength: 20)
                                            
                                            HStack {
                                                Button("Last week") {
                                                    viewModel.priorDaysFilter = 7
                                                    viewModel.isPriorDaysWeekActive = true
                                                    viewModel.isPriorDaysMonthActive = false
                                                    viewModel.isPriorDaysYearActive = false
                                                }
                                                .padding(.all, 10)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .background(viewModel.isPriorDaysWeekActive ? .cyan : .blue)
                                                .cornerRadius(50)
                                                
                                                Button("Last month") {
                                                    viewModel.priorDaysFilter = 30
                                                    viewModel.isPriorDaysWeekActive = false
                                                    viewModel.isPriorDaysMonthActive = true
                                                    viewModel.isPriorDaysYearActive = false
                                                }
                                                .padding(.all, 10)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .background(viewModel.isPriorDaysMonthActive ? .cyan : .blue)
                                                .cornerRadius(50)
                                                
                                                Button("Last year") {
                                                    viewModel.priorDaysFilter = 365
                                                    viewModel.isPriorDaysWeekActive = false
                                                    viewModel.isPriorDaysMonthActive = false
                                                    viewModel.isPriorDaysYearActive = true
                                                }
                                                .padding(.all, 10)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .background(viewModel.isPriorDaysYearActive ? .cyan : .blue)
                                                .cornerRadius(50)
                                            }
                                            .padding(.bottom, 10)
                                            
                                            HStack {
                                                Text("Prior days: \(viewModel.priorDaysFilter)")
                                                
                                                Stepper("", value: $viewModel.priorDaysFilter, in: 0...100) { edited in
                                                    viewModel.isPriorDaysWeekActive = false
                                                    viewModel.isPriorDaysMonthActive = false
                                                    viewModel.isPriorDaysYearActive = false
                                                }
                                            }
                                            
                                            DatePicker("Start Date", selection: $viewModel.startDateFilter, in: viewModel.startDateFilterRange, displayedComponents: .date)
                                            
                                            DatePicker("End Date", selection: $viewModel.endDateFilter, in: viewModel.startDateFilter...Date(), displayedComponents: .date)
                                            
                                            Button {
                                                viewModel.clearFilters()
                                                
                                            } label: {
                                                Text("Clear filters")
                                                
                                                Image(systemName: "xmark.circle.fill")
                                                    .background(.red)
                                                    .cornerRadius(50)
                                            }
                                            .padding(.all, 10)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .background(.gray)
                                            .cornerRadius(25)
                                            .shadow(radius: 5)
                                            .padding()
                                        }
                                        .padding(10)
                                    }
                                    
                                } label: {
                                    Image(systemName: "line.horizontal.3.decrease.circle")
                                        .imageScale(.large)
                                    
                                    Text("Show filters")
                                }
                                .padding(.top, 10)
                        
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
                                    List(viewModel.filteredEvents.lazy) { event in
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
                
                Spacer()
                
            } else {
                Image(systemName: "wifi.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.red)
                
                Text("No internet connection")
                
                Button("Retry") {
                    viewModel.getData()
                }
                .padding()
                .font(.headline)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(25)
                .shadow(radius: 5)
                .padding()
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
