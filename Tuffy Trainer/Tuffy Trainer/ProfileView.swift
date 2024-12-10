import SwiftUI

struct ProfileView: View {
    @State private var profileImage: UIImage? = nil
    @State private var showingImagePicker = false
    
    @AppStorage("currentWeight") private var currentWeight: Double = 0.0
    @AppStorage("username") private var username: String = "User"
    @AppStorage("heightCm") private var heightCm: String = "" // Store height as AppStorage
    
    @State private var birthday = Date()
    @State private var age: Int? = nil
    @State private var isBirthdayPickerPresented: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Username
                VStack {
                    TextField("Enter your username", text: $username)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(6)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(6)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .frame(width: 200)
                }

                // Profile Picture
                VStack {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.purple, lineWidth: 3))
                    } else {
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Text("Add Photo")
                                    .foregroundColor(.purple)
                                    .font(.subheadline)
                            )
                            .onTapGesture {
                                showingImagePicker = true
                            }
                    }
                }
                .padding(.top, 10)
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $profileImage)
                }
                
                // Birthday Input
                VStack(spacing: 8) {
                    Text("Birthday")
                        .font(.headline)
                    
                    Text(birthdayFormatted())
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .onTapGesture {
                            isBirthdayPickerPresented = true
                        }
                    
                    if let age = age {
                        Text("Age: \(age) years")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .sheet(isPresented: $isBirthdayPickerPresented) {
                    VStack(spacing: 20) {
                        Text("Select Your Birthday")
                            .font(.headline)
                        
                        DatePicker(
                            "Select your birthday",
                            selection: $birthday,
                            displayedComponents: .date
                        )
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            calculateAge()
                            isBirthdayPickerPresented = false
                        }) {
                            Text("Confirm")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
                
                // Weight Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weight (kg)")
                        .font(.headline)
                    
                    TextField(
                        "Enter your weight in kg",
                        value: $currentWeight,
                        formatter: NumberFormatter()
                    )
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Height Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Height (cm)")
                        .font(.headline)
                    
                    TextField("Enter your height in cm", text: $heightCm)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .onAppear {
                calculateAge()
            }
            .navigationTitle("Profile")
        }
    }
    
    private func calculateAge() {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        age = ageComponents.year
    }
    
    private func birthdayFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: birthday)
    }
}


// Image Picker Implementation
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
