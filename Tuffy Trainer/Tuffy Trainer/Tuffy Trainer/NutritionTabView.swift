import SwiftUI

struct NutritionView: View {
    // Using @AppStorage for persistent storage
    @AppStorage("dailyCalories") private var dailyCalories: Int = 0
    @AppStorage("dailyProtein") private var dailyProtein: Int = 0
    @AppStorage("dailyCarbs") private var dailyCarbs: Int = 0
    @AppStorage("dailyFats") private var dailyFats: Int = 0

    @AppStorage("breakfastItems") private var breakfastItemsData: Data = Data()
    @AppStorage("lunchItems") private var lunchItemsData: Data = Data()
    @AppStorage("dinnerItems") private var dinnerItemsData: Data = Data()

    @State private var breakfastItems: [FoodItem] = []
    @State private var lunchItems: [FoodItem] = []
    @State private var dinnerItems: [FoodItem] = []

    @State private var showAddFoodModal: Bool = false
    @State private var currentSection: String = ""

    init() {
        loadData()
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Centered Title
                Text("Nutrition")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Macros Display
                HStack {
                    MacroBox(title: "Calories", value: "\(dailyCalories)")
                    MacroBox(title: "Protein", value: "\(dailyProtein)")
                    MacroBox(title: "Carbs", value: "\(dailyCarbs)")
                    MacroBox(title: "Fats", value: "\(dailyFats)")
                }
                .padding(.horizontal)

                // Breakfast Section
                MealSection(
                    title: "Breakfast",
                    items: $breakfastItems,
                    onAddFood: { currentSection = "Breakfast"; showAddFoodModal = true }
                )

                // Lunch Section
                MealSection(
                    title: "Lunch",
                    items: $lunchItems,
                    onAddFood: { currentSection = "Lunch"; showAddFoodModal = true }
                )

                // Dinner Section
                MealSection(
                    title: "Dinner",
                    items: $dinnerItems,
                    onAddFood: { currentSection = "Dinner"; showAddFoodModal = true }
                )

                // Reset Button
                Button(action: resetDailyMacros) {
                    Text("Reset")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showAddFoodModal) {
                AddFoodModal(
                    onAdd: { food in
                        addFood(food: food)
                    }
                )
            }
            .navigationBarHidden(true)
        }
    }

    private func addFood(food: FoodItem) {
        switch currentSection {
        case "Breakfast":
            breakfastItems.append(food)
        case "Lunch":
            lunchItems.append(food)
        case "Dinner":
            dinnerItems.append(food)
        default:
            break
        }

        // Update daily macros
        dailyCalories += food.calories
        dailyProtein += food.protein
        dailyCarbs += food.carbs
        dailyFats += food.fats

        // Save data to UserDefaults
        saveData()
    }

    private func resetDailyMacros() {
        dailyCalories = 0
        dailyProtein = 0
        dailyCarbs = 0
        dailyFats = 0

        breakfastItems.removeAll()
        lunchItems.removeAll()
        dinnerItems.removeAll()

        // Save data to UserDefaults
        saveData()
    }

    private func saveData() {
        // Encode and save food items to UserDefaults (as Data)
        if let breakfastData = try? JSONEncoder().encode(breakfastItems) {
            breakfastItemsData = breakfastData
        }
        if let lunchData = try? JSONEncoder().encode(lunchItems) {
            lunchItemsData = lunchData
        }
        if let dinnerData = try? JSONEncoder().encode(dinnerItems) {
            dinnerItemsData = dinnerData
        }
    }

    private func loadData() {
        // Decode food items from UserDefaults (Data -> [FoodItem])
        if let breakfast = try? JSONDecoder().decode([FoodItem].self, from: breakfastItemsData) {
            breakfastItems = breakfast
        }
        if let lunch = try? JSONDecoder().decode([FoodItem].self, from: lunchItemsData) {
            lunchItems = lunch
        }
        if let dinner = try? JSONDecoder().decode([FoodItem].self, from: dinnerItemsData) {
            dinnerItems = dinner
        }
    }
}

// Food Item Model
struct FoodItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fats: Int
}

// Macro Box Component
struct MacroBox: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}

// Meal Section Component
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

// Add Food Modal Component
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

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}
