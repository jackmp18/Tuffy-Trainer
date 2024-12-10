import SwiftUI

struct HomePageView: View {
    @AppStorage("username") private var username: String = "User"
    @AppStorage("currentWeight") private var currentWeight: Double = 0.0
    @AppStorage("heightCm") private var heightCm: String = ""
    @AppStorage("useKilograms") private var useKilograms: Bool = true

    @StateObject private var nutritionViewModel = NutritionViewModel()

    var body: some View {
        TabView {
            // Home Tab
            VStack(alignment: .leading, spacing: 16) {
                // Welcome Message
                Text("Welcome Back, \(username)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Progress Section
                VStack(alignment: .leading, spacing: 16) {
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

                    // Cards
                    VStack(spacing: 16) {
                        ProgressCard(
                            title: "Nutrition",
                            metrics: [
                                ("Calories", "\(nutritionViewModel.totalCalories) kcal", "flame.fill"),
                                ("Protein", "\(nutritionViewModel.totalProtein) g", "bolt.fill"),
                                ("Carbs", "\(nutritionViewModel.totalCarbs) g", "leaf.fill"),
                                ("Fats", "\(nutritionViewModel.totalFats) g", "drop.fill")
                            ]
                        )
                        .frame(height: 150)

                        ProgressCard(
                            title: "Body Stats",
                            metrics: [
                                ("Weight", "\(String(format: "%.1f", currentWeight)) \(useKilograms ? "kg" : "lb")", "scalemass"),
                                ("Height", "\(heightCm.isEmpty ? "N/A" : "\(heightCm) cm")", "arrow.up.arrow.down")
                            ]
                        )
                        .frame(height: 150)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            // Nutrition Tab
            NutritionView(viewModel: nutritionViewModel)
                .tabItem {
                    Label("Nutrition", systemImage: "leaf")
                }

            // Placeholder Tabs
            GoalProgressView(nutritionViewModel: nutritionViewModel)
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

// Progress Card Component
struct ProgressCard: View {
    var title: String
    var metrics: [(String, String, String)] // Includes icon names

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)

            ForEach(metrics, id: \.0) { metric in
                HStack {
                    Image(systemName: metric.2)
                        .foregroundColor(.purple)
                    Text(metric.0)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(metric.1)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
