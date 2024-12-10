//
//  SleepTabView.swift
//  Tuffy Trainer
//
//  Created by Jaytee Okonkwo on 12/10/24.
//

import SwiftUI

struct SleepTabView: View {
    @AppStorage("dailySleepLog") private var dailySleepLogData: Data = Data()
    @State private var dailySleepLog: [SleepEntry] = []
    @State private var selectedDate = Date()
    @State private var sleepInput: String = ""
    @State private var showError: Bool = false

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init() {
        if let savedData = try? JSONDecoder().decode([SleepEntry].self, from: dailySleepLogData) {
            _dailySleepLog = State(initialValue: savedData)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("Sleep Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Select Date Section
                HStack {
                    Text("Select Date:")
                        .font(.headline)
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(CompactDatePickerStyle())
                }
                .frame(maxWidth: .infinity, alignment: .center)

                // Hours Slept Section
                HStack {
                    Text("Hours Slept:")
                        .font(.headline)
                    Spacer()
                    TextField("Enter hours", text: $sleepInput)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                }
                .padding(.horizontal)

                // Add Entry Button
                Button(action: {
                    if let hours = Double(sleepInput), hours >= 0 {
                        let dateString = formatter.string(from: selectedDate)
                        dailySleepLog.append(SleepEntry(date: dateString, hoursSlept: hours))
                        if let data = try? JSONEncoder().encode(dailySleepLog) {
                            dailySleepLogData = data
                        }
                        sleepInput = ""
                    } else {
                        showError = true
                    }
                }) {
                    Text("Add Entry")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                // Sleep Log Section
                VStack(alignment: .leading) {
                    Text("Sleep Log")
                        .font(.headline)
                        .padding(.leading, 16)

                    List {
                        ForEach(dailySleepLog) { entry in
                            HStack {
                                Text(entry.date)
                                Spacer()
                                Text("\(entry.hoursSlept, specifier: "%.1f") hours")
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .frame(maxWidth: .infinity)

                // Reset Log Button
                Button(action: {
                    dailySleepLog.removeAll()
                    if let data = try? JSONEncoder().encode(dailySleepLog) {
                        dailySleepLogData = data
                    }
                }) {
                    Text("Reset Log")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Invalid Input"),
                      message: Text("Please enter a valid number for hours slept."),
                      dismissButton: .default(Text("OK")))
            }
            .navigationBarHidden(true) // put in to hide the smaller navigation bar title
        }
    }
}

struct SleepEntry: Identifiable, Codable {
    let id = UUID()
    let date: String
    let hoursSlept: Double
}

#Preview {
    SleepTabView()
}

