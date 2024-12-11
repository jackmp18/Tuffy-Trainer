import SwiftUI

// MARK: - Models and ViewModels

struct FoodItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fats: Int
}

enum MealType {
    case breakfast, lunch, dinner
}

class NutritionViewModel: ObservableObject {
    @Published var breakfastItems: [FoodItem] = []
    @Published var lunchItems: [FoodItem] = []
    @Published var dinnerItems: [FoodItem] = []

    var totalCalories: Int {
        (breakfastItems + lunchItems + dinnerItems).reduce(0) { $0 + $1.calories }
    }

    var totalProtein: Int {
        (breakfastItems + lunchItems + dinnerItems).reduce(0) { $0 + $1.protein }
    }

    var totalCarbs: Int {
        (breakfastItems + lunchItems + dinnerItems).reduce(0) { $0 + $1.carbs }
    }

    var totalFats: Int {
        (breakfastItems + lunchItems + dinnerItems).reduce(0) { $0 + $1.fats }
    }
}

// MARK: - Views

struct NutritionView: View {
    @ObservedObject var viewModel: NutritionViewModel
    @State private var isAddingFood = false
    @State private var selectedMeal: MealType? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Cards
                    HStack(spacing: 15) {
                        NutritionCard(title: "Calories", value: viewModel.totalCalories)
                        NutritionCard(title: "Protein", value: viewModel.totalProtein)
                        NutritionCard(title: "Carbs", value: viewModel.totalCarbs)
                        NutritionCard(title: "Fats", value: viewModel.totalFats)
                    }
                    .padding(.horizontal)

                    // Meal Sections
                    MealSection(
                        title: "Breakfast",
                        items: $viewModel.breakfastItems,
                        onAddFood: {
                            selectedMeal = .breakfast
                            isAddingFood = true
                        }
                    )

                    MealSection(
                        title: "Lunch",
                        items: $viewModel.lunchItems,
                        onAddFood: {
                            selectedMeal = .lunch
                            isAddingFood = true
                        }
                    )

                    MealSection(
                        title: "Dinner",
                        items: $viewModel.dinnerItems,
                        onAddFood: {
                            selectedMeal = .dinner
                            isAddingFood = true
                        }
                    )
                }
                .padding()
            }
            .navigationTitle("Nutrition")
            .sheet(isPresented: $isAddingFood) {
                AddFoodModal { newFood in
                    if let meal = selectedMeal {
                        switch meal {
                        case .breakfast:
                            viewModel.breakfastItems.append(newFood)
                        case .lunch:
                            viewModel.lunchItems.append(newFood)
                        case .dinner:
                            viewModel.dinnerItems.append(newFood)
                        }
                    }
                }
            }
        }
    }
}

struct NutritionCard: View {
    let title: String
    let value: Int

    var body: some View {
        VStack {
            Text("\(value)")
                .font(.headline)
                .foregroundColor(.purple)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: 80, height: 80)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct MealSection: View {
    let title: String
    @Binding var items: [FoodItem]
    let onAddFood: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            ForEach(items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("\(item.calories) kcal")
                    Button(action: {
                        if let index = items.firstIndex(where: { $0.id == item.id }) {
                            items.remove(at: index)
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
            }

            Button(action: onAddFood) {
                Text("Add Food")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

struct AddFoodModal: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fats: String = ""

    let onAdd: (FoodItem) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Calories", text: $calories)
                    .keyboardType(.numberPad)
                TextField("Protein", text: $protein)
                    .keyboardType(.numberPad)
                TextField("Carbs", text: $carbs)
                    .keyboardType(.numberPad)
                TextField("Fats", text: $fats)
                    .keyboardType(.numberPad)
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    if let cal = Int(calories), let pro = Int(protein), let carb = Int(carbs), let fat = Int(fats) {
                        let food = FoodItem(name: name, calories: cal, protein: pro, carbs: carb, fats: fat)
                        onAdd(food)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            .navigationTitle("Add Food")
        }
    }
}

// Preview
struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView(viewModel: NutritionViewModel())
    }
}
