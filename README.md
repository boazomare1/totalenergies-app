# TotalEnergies Mobile App Development Checklist

## Project Overview
Creating a replica of the Rubis mobile app for TotalEnergies, maintaining the same UI structure and functionality while adapting branding, colors, and content to match TotalEnergies' brand identity.

## Brand Guidelines
- **Primary Color:** Bright Red (#E60012)
- **Gradient:** Red → Orange → Yellow → Green → Blue → Purple
- **Logo:** TotalEnergies stylized "t" and "e" symbol
- **Typography:** Bold sans-serif for branding
- **Background:** Black for headers, white/light grey for content

## Development Phases

### Phase 1: Core App Structure & Navigation
- [ ] **Main App Shell**
  - [ ] Bottom navigation bar (Home, My Orders, Anticounterfeit, My Card)
  - [ ] Status bar integration
  - [ ] App theme with TotalEnergies colors
  - [ ] Navigation routing setup

- [ ] **Logo & Branding Assets**
  - [ ] TotalEnergies logo (main version)
  - [ ] TotalEnergies logo (white version for dark backgrounds)
  - [ ] Splash screen logo
  - [ ] App icons (192x192, 512x512)
  - [ ] Assets folder structure setup

- [ ] **Home Screen**
  - [ ] Header with user greeting ("Good Afternoon")
  - [ ] Notification bell icon
  - [ ] Promotional banner carousel with 5 slides:
    - [ ] Slide 1: Castrol oil service scene
      - [ ] Mechanic pouring oil into car engine
      - [ ] Family watching service
      - [ ] "Castrol" branding with oil can icon
      - [ ] "Choose the right oil" text
      - [ ] "Find product" button
    - [ ] Slide 2: Enjoy convenience store scene
      - [ ] Family in convenience store
      - [ ] "enjoy" branded shopping bag
      - [ ] "Enjoy" and "Convenience meets quality!" text
      - [ ] "Find a store" button
    - [ ] Slide 3: Rubis Gas delivery scene
      - [ ] Gas station employees with cylinders
      - [ ] "Rubis Gas" and "Need your gas home" text
      - [ ] "Order Now" button
    - [ ] Slide 4: Rubis Card promotion
      - [ ] Card image with discount messaging
      - [ ] "Rubis Card" and "Enjoy a discount every time" text
      - [ ] "Explore" button with card chip icon
    - [ ] Slide 5: Brioche food service
      - [ ] Food items (wraps, pastries)
      - [ ] "Feeling Hungry?" and "Grab a bite from Brioche" text
      - [ ] "Order one now" button with Brioche logo
  - [ ] Left/right navigation arrows
  - [ ] Pagination dots (5 dots total)
  - [ ] Quick Actions section header
  - [ ] Offers button (yellow with gift icon)

### Phase 2: Service Cards & Quick Actions
- [ ] **Station Finder Card**
  - [ ] Map preview with location pins
  - [ ] "Station Finder" title and description
  - [ ] Yellow action button with arrow
  - [ ] Navigation to station picker

- [ ] **TotalEnergies Card**
  - [ ] Card image with TotalEnergies branding
  - [ ] "TotalEnergies Card" title
  - [ ] "Apply | Top Up | Manage..." description
  - [ ] Red action button with arrow
  - [ ] Navigation to card management

- [ ] **Pay at Station Card**
  - [ ] Driver/attendant interaction image
  - [ ] "Pay at station" title
  - [ ] "Pay for Fuel, Gas & Lub..." description
  - [ ] Blue action button with arrow
  - [ ] Payment flow integration

- [ ] **Castrol Card**
  - [ ] Engine oil bottles image
  - [ ] "Castrol" title
  - [ ] "Choose the right oil" description
  - [ ] Brown/grey action button with arrow
  - [ ] Product catalog integration

- [ ] **TotalEnergies Gas Card**
  - [ ] Gas cylinders image
  - [ ] "TotalEnergies Gas" title
  - [ ] Green action button with meter icon
  - [ ] Gas ordering functionality

### Phase 3: Station Finder & Map Integration
- [ ] **Station Picker Screen**
  - [ ] Search bar with location pin icon
  - [ ] "Pay at Station" section
  - [ ] Map integration (Google Maps)
  - [ ] TotalEnergies station markers
  - [ ] Location search functionality
  - [ ] "Confirm" button
  - [ ] Station selection logic

- [ ] **Map Features**
  - [ ] Green pins with TotalEnergies logo
  - [ ] Station information display
  - [ ] Distance calculation
  - [ ] Navigation integration
  - [ ] Real-time station status

### Phase 4: Orders Management
- [ ] **My Orders Screen**
  - [ ] Tab navigation (Active Orders, History)
  - [ ] Empty state with magnifying glass icon
  - [ ] "No items to display!" message
  - [ ] Order history cards (green placeholder cards)
  - [ ] Order status tracking
  - [ ] Order details view

- [ ] **Order States**
  - [ ] Active orders list
  - [ ] Order history with timestamps
  - [ ] Order status indicators
  - [ ] Order cancellation functionality

### Phase 5: Anticounterfeit System
- [ ] **Anticounterfeit Screen**
  - [ ] Dark background with hands/cylinder image
  - [ ] "Anticounterfeit" title
  - [ ] "Authenticity Check" heading
  - [ ] Verification code input field
  - [ ] "Submit" button
  - [ ] Verification logic
  - [ ] Success/error states

- [ ] **Verification Features**
  - [ ] Code validation
  - [ ] Product authenticity check
  - [ ] Results display
  - [ ] History of verifications

### Phase 6: Card Management System
- [ ] **Card Overview Screen**
  - [ ] "Explore Your TotalEnergies Card" title
  - [ ] Card image with TotalEnergies branding
  - [ ] "Link Card" and "Apply Now" buttons
  - [ ] Card features description

- [ ] **Self Registration Flow**
  - [ ] Card type selection (Physical/Virtual)
  - [ ] Application form with progress indicator
  - [ ] KYC process
  - [ ] Card settings configuration
  - [ ] Multi-step form navigation

- [ ] **Card Types**
  - [ ] Physical Card (Chip & Pin)
  - [ ] Virtual Card (Digital)
  - [ ] Corporate vs Individual options
  - [ ] Card management features

### Phase 7: Gas Cylinder Ordering
- [ ] **Gas Product Catalog**
  - [ ] "Cylinder" section title
  - [ ] Delivery time information (7:00 AM - 8:00 PM)
  - [ ] Product grid layout
  - [ ] Shopping cart integration

- [ ] **Product Cards**
  - [ ] 6KG Refill (KES 1,390.00)
  - [ ] 6KG Refill + Cylinder (KES 3,190.00)
  - [ ] 13KG Refill (KES 3,140.00)
  - [ ] 13KG Refill + Cylinder (KES 6,940.00)
  - [ ] "Add to cart" and "Buy Now" buttons

- [ ] **Ordering Features**
  - [ ] Cart management
  - [ ] Delivery scheduling
  - [ ] Payment integration
  - [ ] Order confirmation

### Phase 8: Beyond Fuel Services
- [ ] **Beyond Fuel Navigation**
  - [ ] Tab system (Enjoy, Brioche, Bills)
  - [ ] "Beyond fuel" header
  - [ ] Service-specific screens

- [ ] **Enjoy Store Integration**
  - [ ] "Enjoy Store" branding
  - [ ] Convenience store description
  - [ ] "Pay at Enjoy" functionality
  - [ ] Store locator

- [ ] **Partner Services**
  - [ ] Brioche bakery integration
  - [ ] Uber Eats ordering
  - [ ] "Pay at Brioche" functionality
  - [ ] Partner-specific branding

### Phase 9: Payment Integration
- [ ] **Payment Methods**
  - [ ] Mobile money integration
  - [ ] Card payments
  - [ ] Station payments
  - [ ] Digital wallet support

- [ ] **Payment Flows**
  - [ ] Fuel payment at station
  - [ ] Gas cylinder ordering
  - [ ] Card top-up
  - [ ] Partner service payments

### Phase 10: Additional Features
- [ ] **News & Promotions**
  - [ ] SMS opt-in popup
  - [ ] Promotional banners
  - [ ] Offers management
  - [ ] Notification system

- [ ] **Offers & Promos Screen**
  - [ ] "Offers & Promos" header with back navigation
  - [ ] Four promotional cards with "Enjoy life's journey" slogan
  - [ ] Card 1 (Green Theme): Castrol oil service station scene
    - [ ] Mechanic pouring oil into car engine
    - [ ] Family with child watching service
    - [ ] "Castrol" branding
    - [ ] Green right panel with TotalEnergies logo
  - [ ] Card 2 (Red Theme): Convenience store scene
    - [ ] Woman with shopping bag and children
    - [ ] "enjoy" store branding
    - [ ] Red right panel with TotalEnergies logo
  - [ ] Card 3 (Green Theme): Gas cylinder delivery scene
    - [ ] Delivery rider fist-bumping employee
    - [ ] Green gas cylinders in background
    - [ ] "Gas light.life" branding
    - [ ] Green right panel with TotalEnergies logo
  - [ ] Card 4 (Red Theme): Road trip lifestyle scene
    - [ ] Couple in open-top jeep
    - [ ] Heart-shaped balloons
    - [ ] Sunset background
    - [ ] Red right panel with TotalEnergies logo

- [ ] **Language Support**
  - [ ] Language selection
  - [ ] Multi-language content
  - [ ] Localization

- [ ] **App Store Integration**
  - [ ] Download buttons
  - [ ] App store links
  - [ ] Version management

## Technical Implementation Notes

### Flutter Structure
- **State Management:** Provider/Riverpod for state management
- **Navigation:** GoRouter for navigation
- **Maps:** Google Maps Flutter plugin
- **HTTP:** Dio for API calls
- **Local Storage:** SharedPreferences/Hive
- **UI Components:** Custom widgets following TotalEnergies design

### Key Dependencies
- `google_maps_flutter` for map integration
- `provider` or `riverpod` for state management
- `go_router` for navigation
- `dio` for HTTP requests
- `shared_preferences` for local storage
- `cached_network_image` for image caching

### Design System
- **Colors:** TotalEnergies brand colors with gradient support
- **Typography:** Bold sans-serif fonts
- **Spacing:** Consistent padding and margins
- **Components:** Reusable card components
- **Animations:** Smooth transitions and loading states

## Testing Checklist
- [ ] Unit tests for business logic
- [ ] Widget tests for UI components
- [ ] Integration tests for user flows
- [ ] Device testing (iOS/Android)
- [ ] Performance testing
- [ ] Accessibility testing

## Deployment Checklist
- [ ] App store preparation
- [ ] Icon and splash screen generation
- [ ] Build configuration
- [ ] Release notes
- [ ] Beta testing
- [ ] Production deployment

---

**Note:** This checklist will be updated as development progresses. Each completed item should be checked off and any issues or modifications should be noted in the comments.
