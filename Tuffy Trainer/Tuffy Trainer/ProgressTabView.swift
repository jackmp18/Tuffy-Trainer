import SwiftUI

// Widget for the progress
struct ProgressWidget: View {
    let title: String
    let progress: Double
    let progressText: String
    let barColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.purple)
                .padding(.bottom, 4)

            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: barColor))
                .scaleEffect(x: 1, y: 3, anchor: .center)

            Text(progressText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// Main view
struct GoalProgressView: View {
    @ObservedObject var nutritionViewModel: NutritionViewModel

    @AppStorage("dailyCalorieGoal") private var dailyCalorieGoal: Int = 2000
    @AppStorage("currentWeight") private var currentWeight: Double = 0.0
    @AppStorage("weightGoal") private var weightGoal: Double = 70.0
    @AppStorage("startingWeight") private var startingWeight: Double = 75.0

    // Progress calculations
    private var calorieProgress: Double {
        let totalCalories = nutritionViewModel.totalCalories
        return min(Double(totalCalories) / Double(dailyCalorieGoal), 1.0)
    }

    private var weightProgress: Double {
        let weightLoss = startingWeight - currentWeight
        let weightChange = startingWeight - weightGoal
        return max(weightLoss / weightChange, 0.0)
    }

    @State private var isEditingGoals = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ProgressWidget(
                    title: "Calorie Progress",
                    progress: calorieProgress,
                    progressText: "\(nutritionViewModel.totalCalories)/\(dailyCalorieGoal) kcal",
                    barColor: .purple
                )
                .frame(height: 150)

                ProgressWidget(
                    title: "Weight Progress",
                    progress: weightProgress,
                    progressText: "\(String(format: "%.1f", currentWeight)) kg -> \(String(format: "%.1f", weightGoal)) kg",
                    barColor: .purple
                )
                .frame(height: 150)

                Spacer()
            }
            .padding()
            .navigationTitle("Goal Progress")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        isEditingGoals = true
                    }
                    .foregroundColor(.purple)
                }
            }
            .sheet(isPresented: $isEditingGoals) {
                EditGoalsView(
                    dailyCalorieGoal: $dailyCalorieGoal,
                    weightGoal: $weightGoal
                )
            }
        }
    }
}

struct EditGoalsView: View {
    @Binding var dailyCalorieGoal: Int
    @Binding var weightGoal: Double

    @Environment(\.presentationMode) private var presentationMode

    @State private var calorieInput: String = ""
    @State private var weightInput: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Calorie Goal")) {
                    TextField("Enter daily calorie goal", text: $calorieInput)
                        .keyboardType(.numberPad)
                        .onAppear {
                            calorieInput = String(dailyCalorieGoal)
                        }
                        .onChange(of: calorieInput) { newValue in
                            if let number = Int(newValue) {
                                dailyCalorieGoal = number
                            }
                        }
                }

                Section(header: Text("Weight Goal")) {
                    TextField("Enter weight goal", text: $weightInput)
                        .keyboardType(.decimalPad)
                        .onAppear {
                            weightInput = String(format: "%.1f", weightGoal)
                        }
                        .onChange(of: weightInput) { newValue in
                            if let number = Double(newValue) {
                                weightGoal = number
                            }
                        }
                }
            }
            .navigationTitle("Edit Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct GoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        GoalProgressView(nutritionViewModel: NutritionViewModel())
    }
}
