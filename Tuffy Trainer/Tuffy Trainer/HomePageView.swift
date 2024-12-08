import SwiftUI

struct HomePageView: View {
    var body: some View {
        TabView {
            // Home Page
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome Back, User!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // Progress Section
                VStack(alignment: .leading) {
                    HStack {
                        Text("Your Progress")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                        Text("View All")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 16) {
                        ProgressCard(title: "Training Level-2", subtitle: "3/6 sessions", icon: "figure.strengthtraining.traditional")
                        ProgressCard(title: "Weight", subtitle: "Now: 55kg", icon: "scalemass")
                    }
                    .padding(.horizontal)
                }
                
                // Training Journeys Section
                VStack(alignment: .leading) {
                    Text("Training Journeys")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    HStack(spacing: 16) {
                        ProgressCard(title: "Transformation", subtitle: "4 weeks", icon: "figure.walk")
                        ProgressCard(title: "LiveFit", subtitle: "12 weeks", icon: "figure.run")
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            // Placeholder Tabs
            Text("Progress View")
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                }
            
            NutritionView()
                            .tabItem {
                                Label("Nutrition", systemImage: "leaf")
                            }
            
            Text("Profile View")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

struct ProgressCard: View {
    var title: String
    var subtitle: String
    var icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.purple)
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
