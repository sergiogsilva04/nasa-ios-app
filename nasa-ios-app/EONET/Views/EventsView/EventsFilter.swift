import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: EventsViewModel

    var body: some View {
        ZStack {
            Color
                .gray
                .opacity(0.1)
                .cornerRadius(20)
            
            VStack {
                Spacer(minLength: 20)
                
                HStack {
                    Button("Last week") {
                        viewModel.priorDaysFilter = viewModel.isPriorDaysWeekActive ? 0 : 7
                        
                        viewModel.isPriorDaysWeekActive.toggle()
                        viewModel.isPriorDaysMonthActive = false
                        viewModel.isPriorDaysYearActive = false
                    }
                    .buttonStyle(EventFilterButtonStyle(active: viewModel.isPriorDaysWeekActive))
                    
                    Button("Last month") {
                        viewModel.priorDaysFilter = viewModel.isPriorDaysMonthActive ? 0 : 30
                        
                        viewModel.isPriorDaysWeekActive = false
                        viewModel.isPriorDaysMonthActive.toggle()
                        viewModel.isPriorDaysYearActive = false
                    }
                    .buttonStyle(EventFilterButtonStyle(active: viewModel.isPriorDaysMonthActive))
                    
                    Button("Last year") {
                        viewModel.priorDaysFilter = viewModel.isPriorDaysYearActive ? 0 : 365
                        
                        viewModel.isPriorDaysWeekActive = false
                        viewModel.isPriorDaysMonthActive = false
                        viewModel.isPriorDaysYearActive.toggle()
                    }
                    .buttonStyle(EventFilterButtonStyle(active: viewModel.isPriorDaysYearActive))
                }
                .padding(.bottom, 10)
                
                HStack {
                    Text("Prior days: \(viewModel.priorDaysFilter)")
                    
                    Stepper("", value: $viewModel.priorDaysFilter, in: 0...500) { edited in
                        viewModel.isPriorDaysWeekActive = false
                        viewModel.isPriorDaysMonthActive = false
                        viewModel.isPriorDaysYearActive = false
                    }
                }
                
                if (viewModel.priorDaysFilter == 0) {
                    DatePicker("Start Date", selection: $viewModel.startDateFilter, in: viewModel.startDateFilterRange, displayedComponents: .date)
                    
                    DatePicker("End Date", selection: $viewModel.endDateFilter, in: viewModel.startDateFilter...Date(), displayedComponents: .date)
                }

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
    }
}

struct EventsFilter_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(viewModel: EventsView().viewModel)
    }
}
