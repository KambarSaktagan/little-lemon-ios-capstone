import SwiftUI

// Keys for UserDefaults persistence
let kFirstName = "first_name_key"
let kLastName = "last_name_key"
let kEmail = "email_key"
let kPhoneNumber = "phone_number_key"
let kIsLoggedIn = "kIsLoggedIn"

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    
    @State private var firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    @State private var lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    @State private var email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    @State private var phoneNumber = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
    
    @State private var orderStatuses = true
    @State private var passwordChanges = true
    @State private var specialOffers = true
    @State private var newsletter = true
    
    @State private var showSaveAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Personal information")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                // Avatar section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Avatar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341))
                        
                        Button(action: {}) {
                            Text("Change")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color(red: 0.286, green: 0.369, blue: 0.341))
                                .cornerRadius(8)
                        }
                        
                        Button(action: {}) {
                            Text("Remove")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .border(Color(red: 0.286, green: 0.369, blue: 0.341), width: 1)
                        }
                    }
                }
                
                // Input Fields
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("First name")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("First Name", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last name")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Last Name", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Phone number")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Phone number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                    }
                }
                
                // Email Notifications section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Email notifications")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Toggle("Order statuses", isOn: $orderStatuses)
                    Toggle("Password changes", isOn: $passwordChanges)
                    Toggle("Special offers", isOn: $specialOffers)
                    Toggle("Newsletter", isOn: $newsletter)
                }
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.286, green: 0.369, blue: 0.341)))
                
                // Action Buttons
                VStack(spacing: 12) {
                    // Log out button (Clears User Data and returns to Onboarding)
                    Button(action: {
                        UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                        UserDefaults.standard.removeObject(forKey: kFirstName)
                        UserDefaults.standard.removeObject(forKey: kLastName)
                        UserDefaults.standard.removeObject(forKey: kEmail)
                        UserDefaults.standard.removeObject(forKey: kPhoneNumber)
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("Log out")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.957, green: 0.808, blue: 0.078))
                            .cornerRadius(10)
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            // Revert changes
                            firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
                            lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
                            email = UserDefaults.standard.string(forKey: kEmail) ?? ""
                            phoneNumber = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
                        }) {
                            Text("Discard changes")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .border(Color.secondary, width: 1)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            // Persist changes to UserDefaults
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            UserDefaults.standard.set(phoneNumber, forKey: kPhoneNumber)
                            showSaveAlert = true
                        }) {
                            Text("Save changes")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.286, green: 0.369, blue: 0.341))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showSaveAlert) {
            Alert(title: Text("Saved"), message: Text("Your profile changes have been successfully updated."), dismissButton: .default(Text("OK")))
        }
    }
}
