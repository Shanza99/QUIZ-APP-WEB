# Quiz Application System

A complete **cross-platform quiz application** with PHP backend and Flutter mobile app.


https://github.com/user-attachments/assets/be46189a-c85f-4e35-92aa-397fdc274475


https://github.com/user-attachments/assets/6204220a-b6a5-4474-8873-c2028087b6be




<img width="925" height="438" alt="image" src="https://github.com/user-attachments/assets/877c54e7-6c07-4c8f-89ec-d8a47783d616" />

## 🏗️ Architecture

**Website**: PHP + MySQL  
**APP**: Flutter Mobile App  

## 📁 Project Structure
php/
├── db.php # Database connection
├── register.php # User registration
├── login.php # User login
├── get_questions.php # Fetch questions
├── upload_csv.php # CSV upload
├── *.html # Web interfaces

### Database Tables
- **users** - User accounts  
- **questions** - Quiz questions  
- **attempts** - Quiz attempts tracking

### Flutter App
- Single `main.dart` file with all components  
- Models: User, Question  
- Services: API, Auth  
- Screens: Login, Register, Dashboard, Quiz  

## 🚀 Quick Setup

### Backend Setup
1. Create MySQL database `quiz_app_db`
2. Run SQL schema to create tables
3. Upload PHP files to your web server (XAMPP or live host)
4. Update database credentials in `db.php`

### Flutter Setup
1. Create Flutter project
2. Replace `lib/main.dart` with provided code
3. Update API URL in `ApiService`
4. Run:
   ```bash
   flutter pub get
   flutter run
