import Foundation
import CoreData

@objc(Dish)
public class Dish: NSManagedObject {
    static func createDishesFrom(menuItems: [MenuItem], context: NSManagedObjectContext) {
        for item in menuItems {
            // Check if dish already exists to prevent duplicate entries
            let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title ==[cd] %@", item.title)
            
            do {
                let existingDishes = try context.fetch(fetchRequest)
                if existingDishes.isEmpty {
                    let dish = Dish(context: context)
                    dish.title = item.title
                    dish.dishDescription = item.description
                    dish.price = item.price
                    dish.image = item.image
                    dish.category = item.category
                }
            } catch {
                print("Error checking existing dish: \(error)")
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save dishes to Core Data: \(error)")
        }
    }
}
