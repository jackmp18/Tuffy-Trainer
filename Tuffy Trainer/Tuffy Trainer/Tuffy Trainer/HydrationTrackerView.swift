//
//  HydrationTrackerView.swift
//  Tuffy Trainer
//
//  Created by Gaurav Gudaliya on 10/12/24.
//


import SwiftUI
import UserNotifications

struct HydrationTrackerView: View {
    @State private var waterCount = 0
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 40) {
            Text("How much have you drank today?")
                .font(.title2)
                .bold()
            
            Image(systemName:"wineglass.fill")
                .resizable()
                .frame(width: 100, height: 150)
                .foregroundColor(.purple)
            VStack(spacing: 20){
                Text("\(waterCount) glass")
                    .font(.largeTitle)
                    .bold()
                HStack(spacing: 20){
                    Button(action: decreaseWaterCount) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                    }
                    .disabled(waterCount == 0)
                    
                    Button(action: increaseWaterCount) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)
                    }
                }
            }
            Spacer()
            Button {
                setupNotifications()
            } label: {
                Text("Setup Notification")
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(.green)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func increaseWaterCount() {
        waterCount += 1
    }
    
    private func decreaseWaterCount() {
        if waterCount > 0 {
            waterCount -= 1
        }
    }
    
    private func setupNotifications() {
        // Request permission for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                scheduleDailyNotifications()
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    // Schedule 8 daily notifications
    func scheduleDailyNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests() // Clear previous notifications
        
        let times = [
            "08:00", "10:00", "12:00", "14:00",
            "16:00", "18:00", "20:00", "22:00"
        ]
        for (index, time) in times.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "Drink Water Reminder"
            content.body = "Time to drink a glass of water!"
            content.sound = .default
            
            // Parse time (e.g., "08:00") into hours and minutes
            let components = time.split(separator: ":").compactMap { Int($0) }
            guard components.count == 2 else { continue }
            
            var dateComponents = DateComponents()
            dateComponents.hour = components[0]
            dateComponents.minute = components[1]
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "WaterReminder_\(index)", content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
        }
        print("Daily notifications scheduled!")
        dismiss()
    }
}

struct HydrationTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        HydrationTrackerView()
    }
}
