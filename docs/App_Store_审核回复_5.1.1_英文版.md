# App Store Review Response - Guideline 5.1.1

## Subject: Response to Guideline 5.1.1 - Unauthenticated User Access

Dear App Review Team,

Thank you for your feedback regarding Guideline 5.1.1 - Legal - Privacy - Data Collection and Storage.

We have carefully reviewed the guideline requirements and confirmed that our app **already supports unauthenticated users to freely browse most content without registration or login**.

## ✅ Features Available to Unauthenticated Users

Our app allows unauthenticated users (guest mode) to freely access the following features **without registration or login**:

### 1. **Home Page Browsing**
- **Path**: App launches directly to the home page
- **Features**: Users can browse all product listings, including:
  - Question bank products (exam papers, mock exams, chapter exercises)
  - Online course products
  - Live streaming products
  - Flash sale recommended products
- **Displayed Content**: Complete product information including names, prices, cover images, and descriptions

### 2. **Product Detail Pages**
- **Path**: Home page → Tap any product → Product detail page
- **Features**: Users can view complete product details, including:
  - Product descriptions
  - Price information
  - Course outlines (for online courses)
  - Question counts (for question banks)
  - Validity period information
- **Note**: Unauthenticated users can browse all product information completely

### 3. **Question Bank Page**
- **Path**: Bottom navigation bar → "Question Bank" Tab
- **Features**: Users can browse the question bank homepage, including:
  - Daily practice products
  - Skill simulation products
  - Chapter exercise products
  - Product lists and price information

### 4. **Course Page**
- **Path**: Bottom navigation bar → "Course" Tab
- **Features**: Users can browse course listings, including:
  - Online course lists
  - Live streaming lists
  - Course details and price information

### 5. **Major Selection**
- **Path**: Top of home page → Major selector
- **Features**: Unauthenticated users can select different majors and browse corresponding product content

### 6. **Other Public Pages**
- Privacy Policy
- User Service Agreement
- About Us
- Settings page (partial features)

## ⚠️ Features Requiring Login (Account-Based Features)

The following features require user login because they are directly related to user accounts:

1. **Purchase Products** - Requires an account to manage orders and payment records
2. **Start Practice/Learning** - Requires an account to save learning progress and answer records
3. **Check-in Function** - Requires an account to record check-in data
4. **Personal Center** - Requires an account to view personal information, learning statistics, order records, etc.
5. **Favorite Function** - Requires an account to save favorite content
6. **Wrong Answer Book** - Requires an account to save wrong answer records

## User Experience Flow

### Unauthenticated User Experience

1. **App Launch** → Directly enters home page, no login required
2. **Browse Products** → Can freely browse all product lists and details
3. **View Prices** → All product price information is fully displayed
4. **Attempt Purchase** → When tapping "Purchase" or "Start Practice", a friendly login prompt appears
5. **Login Prompt** → Informs user "This operation requires login. Please log in first" with "Go to Login" and "Cancel" options
6. **After Login** → User can continue the previous operation (purchase, practice, etc.)

### Login Prompt Design

- **Friendly Prompt**: Uses a unified confirmation dialog explaining why login is needed
- **Non-Forced**: Users can choose "Cancel" to continue browsing other content
- **Convenient Login**: Provides multiple login methods (SMS code login, password login, WeChat login)

## Testing Steps

To verify that unauthenticated users can freely browse content, the review team can follow these steps:

### Test Step 1: Verify Home Page Browsing
1. Install the app for the first time (or clear app data)
2. Launch the app
3. **Expected Result**: Directly enters home page, displays product list, no login required
4. **Verification Point**: Can see product names, prices, cover images

### Test Step 2: Verify Product Details
1. Tap any product on the home page
2. **Expected Result**: Enters product detail page, displays complete product information
3. **Verification Point**: Can see product descriptions, prices, course outlines, etc.

### Test Step 3: Verify Question Bank Page
1. Tap the "Question Bank" Tab in the bottom navigation bar
2. **Expected Result**: Enters question bank page, displays product list
3. **Verification Point**: Can see daily practice, skill simulation, and other products

### Test Step 4: Verify Course Page
1. Tap the "Course" Tab in the bottom navigation bar
2. **Expected Result**: Enters course page, displays course list
3. **Verification Point**: Can see online courses, live streaming, and other course information

### Test Step 5: Verify Login Prompt
1. Tap "Purchase" or "Start Practice" button on product detail page
2. **Expected Result**: Login prompt dialog appears, explaining login is required
3. **Verification Point**: Can choose "Cancel" to continue browsing, or choose "Go to Login"

## Technical Implementation

### Route Configuration

Our app uses a route interception mechanism, dividing pages into two categories:

1. **Public Pages** (No login required):
   - Home page (`/main-tab`)
   - Product detail pages (`/goods-detail`, `/course-goods-detail`, etc.)
   - Question bank page (accessed via Tab navigation)
   - Course page (accessed via Tab navigation)
   - Other settings and agreement pages

2. **Pages Requiring Login**:
   - Personal center (partial features)
   - Order pages
   - Learning record pages

### Data Loading Strategy

- **Unauthenticated State**: All public data loads normally; data requiring login is handled silently (no error prompts)
- **Authenticated State**: All data loads normally, including user-specific data

## Compliance with Guideline 5.1.1

According to Guideline 5.1.1:

> "Apps may not require users to enter personal information to function, except when directly relevant to the core functionality of the app or required by law."

Our app:
- ✅ **Allows unauthenticated users to browse content**: Users can browse all products, view prices, and learn about course content without providing any personal information
- ✅ **Only requires login when necessary**: Login is only required when users want to perform account-related operations such as purchasing or starting to learn
- ✅ **Provides clear login prompts**: Clearly explains why login is needed and allows users to choose not to login and continue browsing

## Summary

Our app fully complies with Guideline 5.1.1:
- Unauthenticated users can freely browse app content
- Login is only required for account-related operations (purchase, learning)
- Login prompts are friendly and non-forced

We believe that after testing, the review team will find that unauthenticated users can completely freely browse app content without registration or login.

If you encounter any issues during testing or need additional information, please feel free to contact us. We are happy to assist you in completing the review.

Thank you for your patience and review!

Best regards,
[Your Team Name]
[Date]
