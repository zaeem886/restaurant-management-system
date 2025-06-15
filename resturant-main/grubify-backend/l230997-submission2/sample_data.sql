-- Insert into UserAuth
INSERT INTO UserAuth (Email, PasswordHash, LoginAttempts) VALUES
('admin@example.com', HASHBYTES('SHA2_256', 'admin123'), 0),
('employee1@example.com', HASHBYTES('SHA2_256', 'emp1234'), 0),
('customer1@example.com', HASHBYTES('SHA2_256', 'cust1234'), 0),
('customer2@example.com', HASHBYTES('SHA2_256', 'cust5678'), 0);

-- Insert into Users
INSERT INTO Users (AuthID, Role, FName, LName, DOB, Gender, PhoneNo, Address) VALUES
(1, 'Admin', 'Ali', 'Khan', '1985-04-23', 'Male', '03001234567', 'Lahore, Pakistan'),
(2, 'Employee', 'Sara', 'Ahmed', '1990-06-15', 'Female', '03123456789', 'Karachi, Pakistan'),
(3, 'Customer', 'Usman', 'Raza', '1995-09-10', 'Male', '03211223344', 'Islamabad, Pakistan'),
(4, 'Customer', 'Ayesha', 'Hassan', '1998-02-27', 'Female', '03451234567', 'Multan, Pakistan');

-- Insert into Admin
INSERT INTO Admin (UserID, AccessLevel) VALUES
(1, 'SuperAdmin');

-- Insert into Employee
INSERT INTO Employee (UserID, CNIC, Salary, BankAccount, ManagerID) VALUES
(2, '42201-1234567-8', 50000, 'HBL-123456789', NULL);

-- Insert into Role
INSERT INTO Role (EmployeeID, Role) VALUES
(1, 'Chef');

-- Insert into Customer
INSERT INTO Customer (UserID, LastVisitDate, TotalVisits, CustomerStatus, Blocked)
VALUES
(3, GETDATE(), 5, 'Regular', 'U'),
(4, GETDATE(), 8, 'Gold', 'U');

-- Insert into Orders
INSERT INTO Orders (CustomerID, OrderType, OrderDate, OrderStatus, Rating, Feedback) VALUES
(1, 'Dine-In', GETDATE(), 'Delivered', 5, 'Excellent food!'),
(2, 'Delivery', GETDATE(), 'Dispatched', 4, 'Tasty but late delivery.');

-- Insert into Invoice
INSERT INTO Invoice (OrderID, TotalAmount, Tax, DiscountApplied, PaidStatus, PaymentMethod) VALUES
(1, 1200, 16, 0, 'Paid', 'Cash'),
(2, 2000, 16, 100, 'Unpaid', 'Card');


-- Insert into Deal
INSERT INTO Deal (Prize) VALUES
(1000),
(1500);

-- Insert into OfferDetails
INSERT INTO DealDetails(DealID, ProductID, Quantity) VALUES
(1, 1, 2),
(2, 2, 1);

-- Insert into OrderItems
INSERT INTO OrderItems (OrderID, ProductID, Quantity, TotalPrice) VALUES

(2, 2, 1, 300);

-- Insert into Vendor
INSERT INTO Vendor (FName, LName, CNIC, Address, PhoneNo, Email) VALUES
('Imran', 'Sheikh', '42201-7654321-0', 'Faisalabad, Pakistan', '03011234567', 'vendor1@example.com');

-- Insert into Ingredient
INSERT INTO Ingredient (IngredientName, RemainingStock, Unit, ExpiryDate, VendorID, Type, LowStockAlert) VALUES
('Rice', 50, 'kg', '2025-12-31', 1, 'Dry', 0),
('Bread', 30, 'pcs', '2025-06-15', 1, 'Dry', 0);

-- Insert into Recipes
INSERT INTO Recipes (ProductID, IngredientID, Quantity) VALUES
(1, 1, 1),
(2, 2, 1);

-- Insert into Tables
INSERT INTO Tables (Capacity, IsAvailable) VALUES
(4, 1),
(6, 1);

-- Insert into ReservedTables
INSERT INTO ReservedTables (OrderID, TableID, ReservationTime) VALUES
(1, 1, GETDATE());

-- Insert into DeliveryDetails
INSERT INTO DeliveryDetails (OrderID, DeliveryAddress, ExpectedDeliveryTime, DeliveryFee, DeliveryInstructions) VALUES
(2, 'House #10, Street 5, Karachi', DATEADD(MINUTE, 45, GETDATE()), 90, 'Leave at the door');

-- Insert into Wallet
INSERT INTO Wallet (CustomerID, Balance) VALUES
(1, 5000),
(2, 3000);

-- Insert into WalletTransactions
INSERT INTO WalletTransactions (WalletID, TransactionType, Amount, TransactionDate, OrderID) VALUES
(1, 'Debit', 1200, GETDATE(), 1),
(2, 'Debit', 2000, GETDATE(), 2);



INSERT INTO Product (item_name, Category, SpiceLevel, CookingTime, current_price, AvailablityStatus, item_description, image, quantity)
VALUES 
    ('Sushi Balls', 'Chinese', 'Mild', 20, 606, 1, 'Delicious rice and seafood sushi balls, a popular Japanese-inspired delicacy.', 'pictures/sushi-balls-5878892_1280.jpg', 0),
    ('Japanese Ramen Bowl', 'Chinese', 'Spicy', 30, 1507, 1, 'A rich and flavorful noodle soup topped with sliced pork, egg, and fresh vegetables.', 'pictures/japanese-food-222255_1280.jpg', 0),
    ('Sweet and Sour Pork', 'Chinese', 'Medium', 25, 495, 1, 'Crispy pork chunks coated in a tangy sweet and sour sauce, served with bell peppers and pineapple.', 'pictures/pork-1690696_1280.jpg', 0),
    ('Steamed Dim Sum Platter', 'Chinese', 'Mild', 15, 999, 1, 'A variety of bite-sized dumplings filled with shrimp, pork, and vegetables, served with dipping sauce.', 'pictures/food-715542_1280.jpg', 0),
    ('Dragon Roll Sushi', 'Chinese', 'Mild', 20, 489, 1, 'A beautifully presented sushi roll filled with eel, avocado, and cucumber, topped with thinly sliced avocado and eel sauce.', 'pictures/sushi-2370265_1280.jpg', 0),

    ('Spaghetti Carbonara', 'Pasta', 'Mild', 25, 750, 1, 'Classic Italian pasta with creamy egg sauce, pancetta, and Parmesan cheese.', 'pictures/pasta-1264056_1280.jpg', 0),
    ('Penne Arrabbiata', 'Pasta', 'Spicy', 20, 680, 1, 'Spicy tomato sauce with garlic, chili, and fresh basil over penne pasta.', 'pictures/pasta-3547078_1280.jpg', 0),
    ('Fettuccine Alfredo', 'Pasta', 'Mild', 25, 820, 1, 'Creamy Alfredo sauce over fettuccine pasta with Parmesan and butter.', 'pictures/lasagne-1178514_1280.jpg', 0),
    ('Lasagna Bolognese', 'Pasta', 'Medium', 40, 950, 1, 'Layers of pasta, rich meat sauce, and creamy béchamel topped with melted cheese.', 'pictures/background-8266544_1280.jpg', 0),

    ('Lemon Iced Tea', 'Drinks', 'Mild', 5, 250, 1, 'Refreshing iced tea with a twist of lemon and honey.', 'pictures/cocktail-8076619_1280.jpg', 0),
    ('Cocktail', 'Drinks', 'Mild', 5, 300, 1, 'Creamy mango smoothie made with fresh mangoes and yogurt.', 'pictures/cocktail-818197_1280.jpg', 0),
    ('Black Coffee', 'Drinks', 'Mild', 5, 280, 1, 'Strong black coffee.', 'pictures/coffee-5589036_1280.jpg', 0),
    ('Strawberry Milkshake', 'Drinks', 'Mild', 5, 320, 1, 'Delicious strawberry milkshake with whipped cream topping.', 'pictures/milk-2585099_1280.jpg', 0),

    ('Chocolate Lava Cake', 'Desserts', 'Mild', 10, 450, 1, 'Rich chocolate cake with a gooey molten chocolate center.', 'pictures/dessert-6006446_1920.jpg', 0),
    ('Sweet Bread', 'Desserts', 'Mild', 10, 500, 1, 'Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cream.', 'pictures/bread-1284438_1280.jpg', 0),
    ('Pancake', 'Desserts', 'Mild', 10, 480, 1, 'Fluffy pancakes served with syrup.', 'pictures/pancakes-2291908_1920.jpg', 0),

    ('Chicken Karahi', 'Local', 'Spicy', 45, 2250, 1, 'Traditional Pakistani chicken karahi with rich spices.', 'pictures/chicken-karahi-7253714_1280.jpg', 0),
    ('Biryani', 'Local', 'Spicy', 40, 900, 1, 'Fragrant basmati rice with spiced meat and saffron.', 'pictures/biryani-8563961_1280.jpg', 0),
    ('Kabab', 'Local', 'Spicy', 20, 1350, 1, 'Grilled minced meat kebabs served with naan.', 'pictures/indian-5093242_1280.jpg', 0),
    ('Malai Boti', 'Local', 'Mild', 30, 1280, 1, 'Creamy marinated chicken skewers grilled to perfection.', 'pictures/kebob-3682282_1280.jpg', 0);



	-- Insert sample data for EmployeeAttendance
INSERT INTO EmployeeAttendance (EmployeeID, Date, AttendanceStatus) VALUES
(1, GETDATE(), 'P'),
(1, DATEADD(DAY, -1, GETDATE()), 'A'),
(1, DATEADD(DAY, -2, GETDATE()), 'L');
GO

-- Retrieve data from EmployeeAttendance
SELECT * FROM EmployeeAttendance;
GO