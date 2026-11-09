import SwiftUI

struct Onboarding: View {
    @State private var currentPage = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            // Header Logo
            HStack {
                Spacer()
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding(.top, 10)
                Spacer()
            }
            
            // 3-Page TabView
            TabView(selection: $currentPage) {
                // Page 1: Welcome
                VStack(spacing: 20) {
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341))
                        .padding(.top, 40)
                    
                    Text("Welcome to Little Lemon")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Experience traditional Mediterranean recipes with a fresh, modern twist right in Chicago.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                }
                .tag(0)
                
                // Page 2: Explore Features
                VStack(spacing: 20) {
                    Image(systemName: "menucard.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color(red: 0.957, green: 0.808, blue: 0.078))
                        .padding(.top, 40)
                    
                    Text("Order for Delivery")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Browse delicious starters, savory mains, handcrafted desserts, and chilled drinks directly from your phone.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                }
                .tag(1)
                
                // Page 3: Registration Form
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Register with us")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        Text("Enter your details to begin ordering your favorite Mediterranean dishes.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("First Name *")
                                .font(.caption)
                                .fontWeight(.semibold)
                            TextField("Enter first name", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Last Name *")
                                .font(.caption)
                                .fontWeight(.semibold)
                            TextField("Enter last name", text: $lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email *")
                                .font(.caption)
                                .fontWeight(.semibold)
                            TextField("Enter email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            // Bottom Action Controls
            HStack {
                if currentPage > 0 {
                    Button(action: {
                        withAnimation {
                            currentPage -= 1
                        }
                    }) {
                        Text("Back")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        validateAndRegister()
                    }
                }) {
                    Text(currentPage == 2 ? "Register" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.286, green: 0.369, blue: 0.341))
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid Details"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateAndRegister() {
        let trimmedFirst = firstName.trimmingCharacters(in: .whitespaces)
        let trimmedLast = lastName.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedFirst.isEmpty, !trimmedLast.isEmpty else {
            alertMessage = "First name and Last name cannot be empty."
            showAlert = true
            return
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard !trimmedEmail.isEmpty, emailPredicate.evaluate(with: trimmedEmail) else {
            alertMessage = "Please enter a valid e-mail address."
            showAlert = true
            return
        }
        
        // Save to UserDefaults
        UserDefaults.standard.set(trimmedFirst, forKey: kFirstName)
        UserDefaults.standard.set(trimmedLast, forKey: kLastName)
        UserDefaults.standard.set(trimmedEmail, forKey: kEmail)
        UserDefaults.standard.set(true, forKey: kIsLoggedIn)
        
        withAnimation {
            isLoggedIn = true
        }
    }
}
