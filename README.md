# Little Lemon Food Ordering iOS Application (Capstone Project)

This repository contains the complete iOS Mobile Application for the Little Lemon restaurant developed in SwiftUI and Core Data as the final Capstone project for the Meta iOS Developer Professional Certificate.

---

## Features & Implementation Overview

1. **Wireframe Design Included:**
   - Includes `wireframe.jpg` exported from the design phase representing the comprehensive layout (Navigation Bar, Hero Section, Menu Breakdown categories, and Vertically Scrollable Menu Items).

2. **3-Page Onboarding Flow:**
   - Automatically displayed when the user opens the app for the first time (`kIsLoggedIn == false`).
   - Features 3 paginated cards with informative copy and a persistent **Next** button.
   - Page 3 captures personal details: **First Name**, **Last Name**, and **Email** with regex email verification.
   - Upon successful registration, sets `kIsLoggedIn = true` and navigates smoothly into the Home view.

3. **Home Screen Architecture:**
   - **Header Section:** Centered Little Lemon logo and user avatar button navigating to the profile screen.
   - **Hero Section:** Styled in Mediterranean green (`#495E57`) and yellow (`#F4CE14`), containing the restaurant title, Chicago location, family heritage description, hero food photo, and interactive search bar.
   - **Menu Breakdown:** Selectable category chips (**Starters**, **Mains**, **Desserts**, **Drinks**) that dynamically toggle filtering states.
   - **Food Menu List:** Vertically scrollable menu items showing title, description, price, and remote dish images loaded via `AsyncImage`.

4. **Core Data & Remote API Ingestion:**
   - Downloads live JSON data from the remote endpoint (`https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json`).
   - Decodes into `JSONMenu` / `MenuItem` structs and persists into the `Dish` entity within `PersistenceController`.
   - Utilizes `NSSortDescriptor` (alphabetical sort by title) and `NSPredicate` (supporting combined search filter and category selection).

5. **Profile Screen & Persistence:**
   - Pre-populates with user information entered during onboarding.
   - Retains changes across app launches using `UserDefaults`.
   - **Log out** button clears stored data, resets `kIsLoggedIn`, and routes back to Onboarding.
   - Full stack navigation with back button functionality.

---

## Suggested Future Improvements (For Peer Reviewers)
- Add a shopping cart and order checkout flow with Apple Pay support.
- Implement an offline badge or Core Data synchronization status indicator.
- Add dietary preference filters (e.g., Vegan, Gluten-Free, Halal).
