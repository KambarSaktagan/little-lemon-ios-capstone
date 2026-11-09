import SwiftUI
import CoreData

struct Home: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var searchText = ""
    @State private var selectedCategory = ""
    
    let categories = ["Starters", "Mains", "Desserts", "Drinks"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 1. Navigation / Header Bar
                HStack {
                    Spacer()
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 38)
                    Spacer()
                    
                    NavigationLink(destination: UserProfile()) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.white)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // 2. Hero Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Little Lemon")
                                .font(.system(size: 38, weight: .bold, design: .serif))
                                .foregroundColor(Color(red: 0.957, green: 0.808, blue: 0.078))
                            
                            Text("Chicago")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            HStack(alignment: .top, spacing: 12) {
                                Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 0.93, green: 0.94, blue: 0.93))
                                    .lineSpacing(3)
                                
                                Spacer()
                                
                                Image("Hero")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 125, height: 125)
                                    .cornerRadius(14)
                                    .clipped()
                            }
                            
                            // Search bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.secondary)
                                TextField("Search menu...", text: $searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                
                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.top, 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.286, green: 0.369, blue: 0.341))
                        
                        // 3. Menu Breakdown Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ORDER FOR DELIVERY!")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(categories, id: \.self) { cat in
                                        Button(action: {
                                            if selectedCategory.lowercased() == cat.lowercased() {
                                                selectedCategory = ""
                                            } else {
                                                selectedCategory = cat.lowercased()
                                            }
                                        }) {
                                            Text(cat)
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .background(
                                                    selectedCategory.lowercased() == cat.lowercased() ?
                                                    Color(red: 0.286, green: 0.369, blue: 0.341) :
                                                    Color(.systemGray5)
                                                )
                                                .foregroundColor(
                                                    selectedCategory.lowercased() == cat.lowercased() ?
                                                    .white : Color(red: 0.286, green: 0.369, blue: 0.341)
                                                )
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 12)
                        
                        Divider()
                            .padding(.horizontal, 20)
                        
                        // 4. Food Menu List Section
                        FetchedObjects(
                            predicate: buildPredicate(),
                            sortDescriptors: buildSortDescriptors()
                        ) { (dishes: [Dish]) in
                            LazyVStack(spacing: 0) {
                                ForEach(dishes) { dish in
                                    DishRow(dish: dish)
                                    Divider()
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                getMenuData()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Core Data Predicate builder
    private func buildPredicate() -> NSPredicate {
        var subpredicates: [NSPredicate] = []
        
        if !searchText.isEmpty {
            subpredicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }
        
        if !selectedCategory.isEmpty {
            subpredicates.append(NSPredicate(format: "category ==[cd] %@", selectedCategory))
        }
        
        if subpredicates.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
        }
    }
    
    // Core Data Sort Descriptors builder
    private func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare)
            )
        ]
    }
    
    // API Fetch & Core Data ingestion
    private func getMenuData() {
        // Clear old dishes or synchronize
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch menu data: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let menuList = try decoder.decode(JSONMenu.self, from: data)
                
                DispatchQueue.main.async {
                    Dish.createDishesFrom(menuItems: menuList.menu, context: viewContext)
                }
            } catch {
                print("Decoding failed: \(error)")
            }
        }
        task.resume()
    }
}

// Single Dish Item Row Component
struct DishRow: View {
    let dish: Dish
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(dish.title ?? "Unknown Dish")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(dish.dishDescription ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text("$\(dish.price ?? "0.00")")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.286, green: 0.369, blue: 0.341))
                    .padding(.top, 2)
            }
            
            Spacer()
            
            if let imageURLString = dish.image, let url = URL(string: imageURLString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.secondary)
                            .frame(width: 80, height: 80)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

// Custom FetchedObjects Helper View
struct FetchedObjects<SubView: View>: View {
    let buildView: ([Dish]) -> SubView
    @FetchRequest var fetchRequest: FetchedResults<Dish>
    
    init(
        predicate: NSPredicate = NSPredicate(value: true),
        sortDescriptors: [NSSortDescriptor] = [],
        @ViewBuilder buildView: @escaping ([Dish]) -> SubView
    ) {
        self.buildView = buildView
        self._fetchRequest = FetchRequest<Dish>(
            entity: Dish.entity(),
            sortDescriptors: sortDescriptors,
            predicate: predicate,
            animation: .default
        )
    }
    
    var body: some View {
        buildView(Array(fetchRequest))
    }
}
