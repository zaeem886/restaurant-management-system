create database hi;
go


USE hi;
GO

CREATE TABLE UserAuth 
(
    AuthID INT IDENTITY(1,1),
    Email VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARBinary(64) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
	LoginAttempts INT NOT NULL CHECK (LoginAttempts <= 3) DEFAULT 0,
	CONSTRAINT UserAuth_PK PRIMARY KEY(AuthID),
);
GO

--Table: Users Data
CREATE TABLE Users 
(
    UserID INT IDENTITY(1,1),
    AuthID INT UNIQUE,
    Role VARCHAR(50) NOT NULL CHECK (Role IN ('Customer', 'Employee', 'Admin')),
    FName VARCHAR(255) NOT NULL,
    LName VARCHAR(255) NOT NULL,
    DOB DATE NOT NULL CHECK (DOB < GETDATE()),
    Gender VARCHAR(6) NOT NULL CHECK (Gender IN ('Male', 'Female', 'Other')),
    PhoneNo CHAR(11) NOT NULL,
    Address VARCHAR(255) NOT NULL,
	CONSTRAINT Users_PK PRIMARY KEY(UserID),
	CONSTRAINT Users_FK_AuthID FOREIGN KEY (AuthID) REFERENCES UserAuth(AuthID) 
	ON UPDATE CASCADE
	ON DELETE CASCADE
);
GO 

--Table: Admins
CREATE TABLE Admin 
(
    AdminID INT IDENTITY(1,1),
    UserID INT UNIQUE,
    AccessLevel VARCHAR(50) NOT NULL CHECK (AccessLevel IN ('SuperAdmin', 'Manager'))
	CONSTRAINT Admin_PK  PRIMARY KEY(AdminID)
	CONSTRAINT Admin_FK_UserID FOREIGN KEY(UserID) REFERENCES Users(UserID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);
GO

--Table: Employees
CREATE TABLE Employee
(
	EmployeeID INT IDENTITY(1,1),
	UserID INT UNIQUE,
	CNIC CHAR(15) NOT NULL,
	Salary INT NOT NULL,
	BankAccount VARCHAR(255),
	ManagerID INT,
	CONSTRAINT Employee_PK PRIMARY KEY(EmployeeID),
	CONSTRAINT Employee_FK_UserID FOREIGN KEY(UserID) REFERENCES Users(UserID)
	ON UPDATE CASCADE
	ON DELETE NO ACTION,
	CONSTRAINT Employee_FK_ManagerID FOREIGN KEY(ManagerID) REFERENCES Employee(EmployeeID) --Updating or setting manager id null manually using update before deleting or updating the manager id
	ON UPDATE NO ACTION 
	ON DELETE NO ACTION
);
GO

--Table: Employee Roles
CREATE TABLE Role
(
	EmployeeID INT,
	Role VARCHAR(255),
	CONSTRAINT Role_PK PRIMARY KEY(EmployeeID, Role),
	CONSTRAINT Role_FK_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);
GO

--Table: Customers
CREATE TABLE Customer
(
	CustomerID INT IDENTITY(1,1),
	UserID INT NOT NULL UNIQUE,
	LastVisitDate DATETIME NOT NULL CHECK (LastVisitDate <= GETDATE()) DEFAULT GETDATE(),
	TotalVisits INT NOT NULL CHECK (TotalVisits >= 0) DEFAULT 0,
    CustomerStatus VARCHAR(50) CHECK (CustomerStatus IN ('Regular', 'Gold', 'Premium')),
    Blocked CHAR(1) NOT NULL DEFAULT 'U' CHECK (Blocked IN ('B','U')),
	CONSTRAINT Customer_PK PRIMARY KEY(CustomerID),
	CONSTRAINT Customer_FK_UserID FOREIGN KEY(UserID) REFERENCES Users(UserID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);
GO

alter table orders 
add constraint ck_status
check (OrderStatus IN ('Pending', 'Received', 'Cooking', 'Dispatched', 'Delivered', 'Cancelled','completed'))
--Table: Orders
CREATE TABLE Orders
(
	OrderID INT IDENTITY(1,1),
	CustomerID INT,
	OrderType VARCHAR(30) NOT NULL CHECK (OrderType IN ('Dine-In', 'Pick-up', 'Delivery')),
	OrderDate DATETIME2 NOT NULL DEFAULT GETDATE(),
	OrderStatus VARCHAR(30) NOT NULL CHECK (OrderStatus IN ('Pending', 'Received', 'Cooking', 'Dispatched', 'Delivered', 'Cancelled')),
	Rating INT CHECK (Rating >= 1 AND Rating <= 5),
	Feedback TEXT,
	CONSTRAINT Orders_PK PRIMARY KEY(OrderID),
	CONSTRAINT Orders_FK_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
	ON UPDATE CASCADE
	ON DELETE SET NULL
);
GO


-- Add the CHECK constraint first
ALTER TABLE orders
ADD CONSTRAINT chk_OrderType CHECK (OrderType IN ('Dine-In', 'Pick-up', 'Delivery'));

-- Set NOT NULL constraint for the column
ALTER TABLE orders
ALTER COLUMN OrderType VARCHAR(30) NOT NULL;

-- Set the DEFAULT value
ALTER TABLE orders
ADD CONSTRAINT df_OrderType DEFAULT 'Dine-In' FOR OrderType;


-- Repeat the process for OrderStatus
ALTER TABLE orders
ADD CONSTRAINT chk_OrderStatus CHECK (OrderStatus IN ('Pending', 'Received', 'Cooking', 'Dispatched', 'Delivered', 'Cancelled'));

ALTER TABLE orders
ALTER COLUMN OrderStatus VARCHAR(30) NOT NULL;

ALTER TABLE orders
ADD CONSTRAINT df_OrderStatus DEFAULT 'Pending' FOR OrderStatus;





--Table: Invoices
CREATE TABLE Invoice
(
	InvoiceID INT IDENTITY(1,1),
	OrderID INT NOT NULL UNIQUE,
	TotalAmount INT NOT NULL CHECK (TotalAmount > 0),
 	Tax INT NOT NULL CHECK (Tax IN (16, 5)) DEFAULT 16,
	DiscountApplied INT NOT NULL CHECK (DiscountApplied >= 0) DEFAULT 0,
	PaidStatus VARCHAR(10) CHECK (PaidStatus IN ('Paid', 'Unpaid')),
	PaymentMethod VARCHAR (255) NOT NULL CHECK (PaymentMethod IN ('Cash', 'Card', 'Wallet')),
	CONSTRAINT Invoices_PK PRIMARY KEY(InvoiceID),
	CONSTRAINT Invoices_FK_OrderID FOREIGN KEY(OrderID) REFERENCES Orders(OrderID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);
GO

--Table: Products
CREATE TABLE Product
(
	id INT IDENTITY(1, 1) ,
	item_description varchar(500),
	quantity int ,
	image varchar(200),
	item_name VARCHAR(255) NOT NULL UNIQUE,
	Category VARCHAR(255) NOT NULL,
	SpiceLevel VARCHAR(255) NOT NULL CHECK (SpiceLevel IN ('Mild', 'Medium', 'Spicy')),
	CookingTime INT NOT NULL CHECK (CookingTime > 0),
	current_price INT NOT NULL CHECK (current_price > 0),
    AvailablityStatus INT NOT NULL CHECK (AvailablityStatus IN (1, 0)) DEFAULT 0,
	CONSTRAINT Product_PK PRIMARY KEY(id)
);
GO

--Table: Deals
CREATE TABLE Deal
(
	DealID INT IDENTITY(1,1),
	Prize INT NOT NULL CHECK (Prize > 0)
	CONSTRAINT Deal_PK PRIMARY KEY(DealID)
);
GO

--Table: Deal Details
CREATE TABLE DealDetails
(
	DealID INT NOT NULL,
	ProductID INT NOT NULL,
	Quantity INT NOT NULL CHECK (Quantity > 0),
	CONSTRAINT OfferDetails_PK PRIMARY KEY(DealID, ProductID),
	CONSTRAINT OfferDetails_FK_OfferID FOREIGN KEY(DealID) REFERENCES Deal(DealID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT OfferDetails_FK_ProductID FOREIGN KEY(ProductID) REFERENCES Product(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);
GO
select * from Product
--Table: Order Details
CREATE TABLE OrderItems
(
	OrderID INT NOT NULL,
	ProductID INT Not NULL,
	Quantity INT NOT NULL CHECK (Quantity > 0),
	TotalPrice INT NOT NULL CHECK (TotalPrice > 0),
	CONSTRAINT OrderItems_CPK PRIMARY KEY(OrderID, ProductID),
	CONSTRAINT OrderItems_FK_OrderID FOREIGN KEY(OrderID) REFERENCES Orders(OrderID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT OrderItems_FK_ProductID FOREIGN KEY(ProductID) REFERENCES Product(id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
);
GO

--Table: Vendors
CREATE TABLE Vendor
(
	VendorID INT Identity(1,1),
	FName VARCHAR(255) NOT NULL,
	LName VARCHAR(255) NOT NULL,
	CNIC VARCHAR(15) NOT NULL,
	Address VARCHAR(255) NOT NULL,
	PhoneNo VARCHAR(11) NOT NULL,
	Email VARCHAR(255) NOT NULL,
	CONSTRAINT Vendor_PK PRIMARY KEY(VendorID)
);
GO

--Table: Ingredients
CREATE TABLE Ingredient
(
	IngredientID INT IDENTITY(1,1),
	IngredientName VARCHAR(255) NOT NULL UNIQUE,
	RemainingStock INT NOT NULL CHECK (RemainingStock >= 0),
	Unit VARCHAR(255) NOT NULL,
	ExpiryDate DATE NOT NULL,
	VendorID INT,
	Type VARCHAR(10) CHECK (Type IN('Frozen', 'Dry')),
	LowStockAlert BIT NOT NULL,
	CONSTRAINT Ingredient_PK PRIMARY KEY(IngredientID),
	CONSTRAINT Ingredient_FK_VendorID FOREIGN KEY(VendorID) REFERENCES Vendor(VendorID)
	ON UPDATE CASCADE
	ON DELETE SET NULL
);
GO

--Table Recipes
CREATE TABLE Recipes
(
	ProductID INT,
	IngredientID INT,
	Quantity INT CHECK (Quantity > 0),
	CONSTRAINT Recipes_CPK PRIMARY KEY(ProductID, IngredientID),
	CONSTRAINT Recipes_FK_ProductID FOREIGN KEY(ProductID) REFERENCES Product(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT Recipes_FK_IngredientID FOREIGN KEY(IngredientID) REFERENCES Ingredient(IngredientID)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
);
GO

--Table: Ingredient Supply
CREATE TABLE IngredientSupply
(
	IngredientID INT NOT NULL,
	VendorID INT NOT NULL,
	PurchaseDate DATE NOT NULL CHECK (PurchaseDate <= GETDATE()) DEFAULT GETDATE(),
	PurchaseAmount INT NOT NULL CHECK (PurchaseAmount > 0),
	PurchaseRate INT NOT NULL CHECK (PurchaseRate > 0),
	CONSTRAINT IngredientSupply_CPK PRIMARY KEY(IngredientID, VendorID),
	CONSTRAINT IngredientSupply_FK_IngredientID FOREIGN KEY(IngredientID) REFERENCES Ingredient(IngredientID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT IngredientSupply_FK_VendorID FOREIGN KEY(VendorID) REFERENCES Vendor(VendorID) --Updating or setting vendor id null manually using update before updating or deleting the vendor id
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
);
GO


select * from tables
select * from ReservedTables


--Table: Tables
CREATE TABLE Tables
(
	TableID INT IDENTITY(1,1),
	Capacity INT NOT NULL CHECK (Capacity > 0),
	IsAvailable BIT NOT NULL DEFAULT 1,
	CONSTRAINT Tables_PK PRIMARY KEY(TableID)
);
GO

-- Table: Reserved Table Details
CREATE TABLE ReservedTables
(
	ReservationID INT IDENTITY(1,1),
	OrderID INT NOT NULL,
	TableID INT NOT NULL,
	ReservationTime DATETIME NOT NULL,
	CONSTRAINT ReservedTables_PK PRIMARY KEY(ReservationID),
	CONSTRAINT ReservedTables_FK_OrderID FOREIGN KEY(OrderID) REFERENCES Orders(OrderID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT ReservedTables_FK_TableID FOREIGN KEY(TableID) REFERENCES Tables(TableID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);
GO

--Table: Delivery Details
CREATE TABLE DeliveryDetails 
(
    DeliveryID INT IDENTITY(1,1),
    OrderID INT UNIQUE,
    DeliveryAddress VARCHAR(255) NOT NULL,
    ExpectedDeliveryTime DATETIME NOT NULL,
    DeliveryFee INT NOT NULL CHECK (DeliveryFee >= 0) DEFAULT 90,
	DeliveryInstructions TEXT NULL,
	CONSTRAINT DeliveryDetails_PK PRIMARY KEY(DeliveryID),
    CONSTRAINT DeliveryDetails_FK_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);
GO

--Table: Customer Wallet
CREATE TABLE Wallet
(
	WalletID INT IDENTITY(1,1),
	CustomerID INT UNIQUE,
	Balance INT NOT NULL CHECK(Balance >= 0),
	CONSTRAINT Wallet_PK PRIMARY KEY(WalletID),
	CONSTRAINT Wallet_FK_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
	ON UPDATE CASCADE
	ON DELETE SET NULL
);
GO

--Table: Wallet Transactions
CREATE TABLE WalletTransactions
(
	TransactionsID INT IDENTITY(1,1),
	WalletID INT NOT NULL,
	TransactionType VARCHAR(255) CHECK (TransactionType IN ('Credit', 'Debit')),
	Amount INT NOT NULL CHECK (Amount > 0),
	TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
	OrderID INT NULL,
	CONSTRAINT WalletTransactions_PK PRIMARY KEY (TransactionsID),
	CONSTRAINT WalletTransactions_FK_OrderID FOREIGN KEY(OrderID) REFERENCES Orders(OrderID)
	ON UPDATE CASCADE
	ON DELETE SET NULL
);
GO






CREATE TABLE EmployeeAttendance
(
	EmployeeID INT,
	Date DATE NOT NULL CHECK (Date <= GETDATE()) DEFAULT GETDATE(),
	AttendanceStatus CHAR(1) NOT NULL CHECK (AttendanceStatus IN ('A', 'P', 'L')) DEFAULT 'A',
	CONSTRAINT EmployeeAttendance_PK PRIMARY KEY(EmployeeID, Date),
	CONSTRAINT EmployeeAttendance_FK_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- Insert into UserAuth
INSERT INTO UserAuth (Email, PasswordHash, LoginAttempts) VALUES
('admin1@example.com', HASHBYTES('2256', 'admin123'), 0),
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

INSERT INTO Vendor (FName, LName, CNIC, Address, PhoneNo, Email) VALUES
('ali', 'Sheikh', '42201-7654311-0', 'lahore, Pakistan', '03011231567', 'vendor2@example.com');

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


	--ingredients add
	INSERT INTO Ingredient (IngredientName, RemainingStock, Unit, ExpiryDate, VendorID, Type, LowStockAlert)
VALUES
-- Common
('Salt', 1000, 'grams', '2025-12-31', 1, 'Dry', 0),
('Black Pepper', 500, 'grams', '2025-12-31', 1, 'Dry', 0),
('Oil', 10000, 'ml', '2025-12-31', 2, 'Dry', 0),

-- Sushi related

('Seaweed', 300, 'sheets', '2025-11-30', 2, 'Dry', 0),
('Eel', 100, 'grams', '2025-05-30', 2, 'Frozen', 0),
('Avocado', 100, 'grams', '2025-04-20', 2, 'Dry', 0),
('Cucumber', 100, 'grams', '2025-04-20', 1, 'Dry', 0),
('Soy Sauce', 500, 'ml', '2025-12-31', 1, 'Dry', 0),

-- Ramen & Dim Sum
('Noodles', 1000, 'grams', '2025-12-31', 2, 'Dry', 0),
('Pork', 800, 'grams', '2025-05-15', 1, 'Frozen', 0),
('Eggs', 300, 'pieces', '2025-04-30', 1, 'Dry', 0),
('Shrimp', 500, 'grams', '2025-05-10', 2, 'Frozen', 0),
('Vegetables', 2000, 'grams', '2025-04-20', 2, 'Dry', 0),

-- Pasta
('Pasta', 2000, 'grams', '2025-12-31', 2, 'Dry', 0),
('Tomato Sauce', 800, 'ml', '2025-06-30', 1, 'Dry', 0),
('Parmesan Cheese', 300, 'grams', '2025-05-30', 2, 'Frozen', 0),
('Cream', 500, 'ml', '2025-05-15', 2, 'Frozen', 0),
('Basil', 100, 'grams', '2025-06-15', 1, 'Dry', 0),

-- Drinks
('Tea Leaves', 200, 'grams', '2025-12-31', 1, 'Dry', 0),
('Lemon', 100, 'pieces', '2025-04-30', 2, 'Dry', 0),
('Honey', 300, 'ml', '2025-12-31', 2, 'Dry', 0),
('Coffee Beans', 500, 'grams', '2025-12-31', 1, 'Dry', 0),
('Milk', 1000, 'ml', '2025-04-30', 1, 'Dry', 0),
('Strawberry', 500, 'grams', '2025-04-20', 2, 'Frozen', 0),

-- Desserts
('Chocolate', 300, 'grams', '2025-06-15', 2, 'Dry', 0),
('Flour', 1000, 'grams', '2025-11-30', 1, 'Dry', 0),
('Sugar', 1500, 'grams', '2025-12-31', 1, 'Dry', 0),

-- Local
('Chicken', 1500, 'grams', '2025-05-20', 1, 'Frozen', 0),
('Rice Basmati', 2000, 'grams', '2025-12-31', 1, 'Dry', 0),
('Yogurt', 500, 'grams', '2025-04-30', 1, 'Dry', 0),
('Naan', 100, 'pieces', '2025-04-20', 2, 'Dry', 0),
('Spices Mix', 300, 'grams', '2025-12-31', 2, 'Dry', 0);

INSERT INTO Recipes (ProductID, IngredientID, Quantity) VALUES 
(1, 1, 100),   -- Sushi Balls - Rice
(1, 10, 2),     -- Seaweed
(1, 11, 1),     -- Avocado
(1, 12, 1),     -- Cucumber
(1, 13, 2),    -- Soy Sauce

(2, 11, 100),  -- Japanese Ramen Bowl - Noodles
(2, 12, 50),   -- Pork
(2, 13, 1),    -- Eggs
(2, 15, 30),   -- Vegetables
(2, 10, 1),    -- Soy Sauce

(3, 12, 100),  -- Sweet and Sour Pork
(3, 15, 30),   -- Vegetables
(3, 13, 1),    -- Eggs
(3, 16, 20),   -- Pasta (used as starch base)
(3, 17, 20),   -- Tomato Sauce

(5, 16, 100),  -- Spaghetti Carbonara - Pasta
(5, 13, 1),    -- Eggs
(5, 18, 20),   -- Parmesan Cheese
(5, 19, 30),   -- Cream
(5, 2, 1),     -- Salt

(6, 16, 100),  -- Penne Arrabbiata - Pasta
(6, 17, 50),   -- Tomato Sauce
(6, 20, 5),    -- Basil
(6, 10, 1),     -- Salt

(7, 16, 100),  -- Fettuccine Alfredo
(7, 18, 30),   -- Parmesan Cheese
(7, 19, 40),   -- Cream
(7, 10, 1),     -- Salt

(8, 16, 100),  -- Lasagna Bolognese
(8, 17, 50),   -- Tomato Sauce
(8, 15, 30),   -- Vegetables
(8, 18, 30),   -- Parmesan Cheese

(9, 21, 2),    -- Lemon Iced Tea - Tea Leaves
(9, 22, 1),    -- Lemon
(9, 23, 2),    -- Honey

(10, 22, 1),   -- Cocktail - Lemon
(10, 23, 1),   -- Honey
(10, 15, 20),  -- Vegetables (used for garnish)

(11, 24, 2),   -- Black Coffee - Coffee Beans
(11, 23, 1),   -- Honey

(12, 25, 200), -- Strawberry Milkshake - Milk
(12, 26, 3),   -- Strawberry
(12, 28, 10),  -- Sugar

(13, 27, 50),  -- Chocolate Lava Cake - Chocolate
(13, 28, 10),  -- Sugar
(13, 29, 50),  -- Flour
(13, 13, 1),   -- Eggs

(14, 29, 50),  -- Sweet Bread - Flour
(14, 28, 10),  -- Sugar
(14, 13, 1),   -- Eggs

(15, 29, 50),  -- Pancake - Flour
(15, 28, 10),  -- Sugar
(15, 13, 1),   -- Eggs
(15, 25, 100), -- Milk

(16, 30, 100), -- Chicken Karahi - Chicken
(16, 17, 30),  -- Tomato Sauce
(16, 33, 10),  -- Spices Mix
(16, 13, 1),   -- Eggs (for thickening)

(17, 31, 100), -- Biryani - Rice Basmati
(17, 30, 100), -- Chicken
(17, 32, 50),  -- Yogurt
(17, 33, 10),  -- Spices Mix

(18, 30, 100), -- Kabab - Chicken
(18, 33, 10),  -- Spices Mix
(18, 13, 1),   -- Eggs
(18, 29, 30),  -- Flour

(19, 30, 100), -- Malai Boti - Chicken
(19, 19, 30),  -- Cream
(19, 32, 20),  -- Yogurt
(19, 33, 10);  -- Spices Mix

select IngredientID,IngredientName from Ingredient order by IngredientID asc

	-- Insert sample data for EmployeeAttendance
INSERT INTO EmployeeAttendance (EmployeeID, Date, AttendanceStatus) VALUES
(1, GETDATE(), 'P'),
(1, DATEADD(DAY, -1, GETDATE()), 'A'),
(1, DATEADD(DAY, -2, GETDATE()), 'L');
GO

-- Retrieve data from EmployeeAttendance
SELECT * FROM EmployeeAttendance;
GO
CREATE PROCEDURE sp_RegisterUser
    @Email VARCHAR(255),
    @PasswordHash VARCHAR(64),
    @Role VARCHAR(50),
    @FName VARCHAR(255),
    @LName VARCHAR(255),
    @DOB DATE,
    @Gender VARCHAR(6),
    @PhoneNo CHAR(11),
    @Address VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insert into UserAuth (convert PasswordHash to VARBINARY)
        INSERT INTO UserAuth (Email, PasswordHash)
        VALUES (@Email, CONVERT(VARBINARY(64), @PasswordHash));

        DECLARE @AuthID INT = SCOPE_IDENTITY();

        -- Insert into Users
        INSERT INTO Users (AuthID, Role, FName, LName, DOB, Gender, PhoneNo, Address)
        VALUES (@AuthID, @Role, @FName, @LName, @DOB, @Gender, @PhoneNo, @Address);

        DECLARE @UserID INT = SCOPE_IDENTITY();

        -- If role is Customer, insert into Customer table
        IF @Role = 'Customer'
        BEGIN
            INSERT INTO Customer (UserID)
            VALUES (@UserID);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

GO
EXEC sp_RegisterUser
    @Email = 'admin222@example.com',
    @PasswordHash = 123123,  -- sample binary hash
    @Role = 'Admin',
    @FName = 'John',
    @LName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'Male',
    @PhoneNo = '01234567890',
    @Address = '123 Main Street';
	select *  from UserAuth 
	select * from users
	select * from admin
	drop procedure sp_AuthenticateUser
	insert into admin (UserID,AccessLevel)
	values (18,'SuperAdmin')


	CREATE PROCEDURE sp_AuthenticateUser
    @Email VARCHAR(255),
    @PasswordHash VARBINARY(64),
    @LoginSuccess INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AuthID INT;
    DECLARE @UserID INT;
    DECLARE @cus INT;

    -- Step 1: Match credentials
    SELECT @AuthID = AuthID 
    FROM UserAuth 
    WHERE Email = @Email AND PasswordHash = @PasswordHash;

    PRINT 'AuthID: ' + CAST(@AuthID AS VARCHAR);

    IF @AuthID IS NOT NULL
    BEGIN
        -- Step 2: Match customer role
        SELECT @UserID = UserID 
        FROM Users 
        WHERE AuthID = @AuthID AND Role = 'Customer';

        PRINT 'UserID: ' + CAST(@UserID AS VARCHAR);

        IF @UserID IS NOT NULL
        BEGIN
            -- Step 3: Get CustomerID
            SELECT @cus = CustomerID 
            FROM Customer 
            WHERE UserID = @UserID;

            PRINT 'CustomerID: ' + CAST(@cus AS VARCHAR);

            IF @cus IS NOT NULL
                SET @LoginSuccess = @cus;
            ELSE
                SET @LoginSuccess = @cus;  -- Customer row not found
        END
        ELSE
        BEGIN
            SET @LoginSuccess = -2;  -- No user with role Customer
        END
    END
    ELSE
    BEGIN
        SET @LoginSuccess = 0;  -- Invalid credentials
    END
END;
GO




DECLARE @Result INT;

EXEC sp_AuthenticateUser
    @Email = 'fareed11111@gmail.com',
    @PasswordHash =0x313233343536, -- replace with actual hash
    @LoginSuccess = @Result OUTPUT;

SELECT @Result AS LoginSuccess;

	select* from UserAuth
	select * from customer
	select * from users

	------place a new order---

	CREATE PROCEDURE sp_PlaceOrder
    @CustomerID INT,
    @OrderType VARCHAR(30),
    @OrderStatus VARCHAR(30) = 'Pending'
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Orders (CustomerID, OrderType, OrderStatus)
    VALUES (@CustomerID, @OrderType, @OrderStatus);

    SELECT SCOPE_IDENTITY() AS NewOrderID;
END;
GO


select * from Orders
EXEC sp_PlaceOrder
    @CustomerID = 1,   -- assume CustomerID 1 exists
    @OrderType = 'Delivery';






-----feedback and rating ----
	CREATE PROCEDURE UpdateOrderFeedback
    @OrderID INT,
    @UserID INT,
    @Rating INT,         -- Rating scale (e.g., 1 to 5)
    @Feedback TEXT       -- User feedback
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the order exists and belongs to the user
    IF EXISTS (
        SELECT 1 
        FROM Orders 
        WHERE OrderID = @OrderID AND CustomerID = @UserID
    )
    BEGIN
        -- Update the Orders table with feedback and rating
        UPDATE Orders
        SET Rating = @Rating, Feedback = @Feedback,OrderStatus='received'
		
        WHERE OrderID = @OrderID;

        PRINT 'Feedback updated successfully';
    END
    ELSE
    BEGIN
        PRINT 'Invalid OrderID or Unauthorized User';
    END
END;
GO

EXEC UpdateOrderFeedback
    @OrderID = 3,
    @UserID = 1,
    @Rating = 5,
    @Feedback = 'The food was delicious and fresh!';


	----place order item--

	CREATE PROCEDURE AddOrderItem
    @OrderID INT,
    @ProductID INT,
    @Quantity INT,
    @TotalPrice INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO OrderItems (OrderID, ProductID, Quantity, TotalPrice)
    VALUES (@OrderID, @ProductID, @Quantity, @TotalPrice);
END;
GO

EXEC AddOrderItem
    @OrderID = 1,      -- assume OrderID 1 exists
    @ProductID = 1,    -- assume ProductID 1 exists
    @Quantity = 2,
    @TotalPrice = 500;

	select * from OrderItems


	-----update order status----

	CREATE PROCEDURE UpdateOrderStatus
    @OrderID INT,
    @NewStatus VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Orders
    SET OrderStatus = @NewStatus
    WHERE OrderID = @OrderID;
END;
GO

EXEC UpdateOrderStatus
    @OrderID = 1,
    @NewStatus = 'Cooking';

	select * from Orders


	-------generate invoice---

	CREATE PROCEDURE GenerateInvoice
    @OrderID INT,
    @TotalAmount INT,
    @Tax INT = 16,
    @DiscountApplied INT = 0,
    @PaidStatus VARCHAR(10),
    @PaymentMethod VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Invoice (OrderID, TotalAmount, Tax, DiscountApplied, PaidStatus, PaymentMethod)
    VALUES (@OrderID, @TotalAmount, @Tax, @DiscountApplied, @PaidStatus, @PaymentMethod);

    SELECT SCOPE_IDENTITY() AS NewInvoiceID;
END;
GO

EXEC GenerateInvoice
    @OrderID = 40,
    @TotalAmount = 1500,
    @Tax = 16,
    @DiscountApplied = 50,
    @PaidStatus = 'Paid',
    @PaymentMethod = 'Card';

	select * from Invoice

	----reserve a table---
	CREATE PROCEDURE ReserveTable
    @OrderID INT,
    @TableID INT,
    @ReservationTime DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ReservedTables (OrderID, TableID, ReservationTime)
    VALUES (@OrderID, @TableID, @ReservationTime);

    SELECT SCOPE_IDENTITY() AS NewReservationID;
END;
GO

EXEC ReserveTable
    @OrderID = 1,
    @TableID = 1,    -- assume TableID 1 exists
    @ReservationTime = '2025-03-23 19:00:00';

	
select * from ReservedTables


------wallet transaction-----

CREATE PROCEDURE AddWalletTransaction
    @CustomerID INT,
    @TransactionType VARCHAR(255),
    @Amount INT,
    @OrderID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @WalletID INT;
    SELECT @WalletID = WalletID FROM Wallet WHERE CustomerID = @CustomerID;

    IF @WalletID IS NULL
    BEGIN
        RAISERROR ('Wallet not found for CustomerID %d', 16, 1, @CustomerID);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insert transaction
        INSERT INTO WalletTransactions (WalletID, TransactionType, Amount, OrderID)
        VALUES (@WalletID, @TransactionType, @Amount, @OrderID);

        -- Update wallet balance
        IF @TransactionType = 'Credit'
            UPDATE Wallet SET Balance = Balance + @Amount WHERE WalletID = @WalletID;
        ELSE IF @TransactionType = 'Debit'
            UPDATE Wallet SET Balance = Balance - @Amount WHERE WalletID = @WalletID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

EXEC AddWalletTransaction
    @CustomerID = 1,
    @TransactionType = 'Credit',  -- or 'Debit'
    @Amount = 200,
    @OrderID = 1;   -- optional, if linked to an order

	select * from WalletTransactions

----customer order history----

drop procedure GetCustomerOrderHistory
CREATE PROCEDURE GetCustomerOrderHistory
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT o.OrderID, o.OrderType, o.OrderDate, o.OrderStatus, i.TotalAmount, i.PaidStatus
    FROM Orders AS o
    LEFT JOIN Invoice AS i ON o.OrderID = i.OrderID
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate DESC;
END;
GO
use hi

EXEC GetCustomerOrderHistory
    @CustomerID = 1


	-----add ingrediesnt supply record----

	CREATE PROCEDURE AddIngredientSupply
    @IngredientID INT,
    @VendorID INT,
    @PurchaseDate DATE,
    @PurchaseAmount INT,
    @PurchaseRate INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO IngredientSupply (IngredientID, VendorID, PurchaseDate, PurchaseAmount, PurchaseRate)
    VALUES (@IngredientID, @VendorID, @PurchaseDate, @PurchaseAmount, @PurchaseRate);
END;
GO

EXEC AddIngredientSupply
    @IngredientID = 1,  -- assume IngredientID 1 exists
    @VendorID = 1,      -- assume VendorID 1 exists
    @PurchaseDate = '2025-03-22',
    @PurchaseAmount = 100,
    @PurchaseRate = 50;

	select * from IngredientSupply

	-------Get Daily Sales Report-----

	CREATE VIEW DailySalesReport AS
SELECT 
    CAST(o.OrderDate AS DATE) AS OrderDate,
    COUNT(*) AS TotalOrders,
    SUM(i.TotalAmount) AS TotalSales
FROM Orders AS o
JOIN Invoice AS i ON o.OrderID = i.OrderID
GROUP BY CAST(o.OrderDate AS DATE);

SELECT * FROM DailySalesReport
WHERE OrderDate = '2025-3-22';  -- Replace with desired date


-------add new product-----
CREATE PROCEDURE AddNewProduct
    @ItemDescription VARCHAR(500),
    @Quantity INT,
    @Image VARCHAR(200),
    @ItemName VARCHAR(255),
    @Category VARCHAR(255),
    @SpiceLevel VARCHAR(255),
    @CookingTime INT,
    @CurrentPrice INT,
    @AvailabilityStatus INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Product (item_description, quantity, image, item_name, Category, SpiceLevel, CookingTime, current_price, AvailablityStatus)
    VALUES (@ItemDescription, @Quantity, @Image, @ItemName, @Category, @SpiceLevel, @CookingTime, @CurrentPrice, @AvailabilityStatus);

    SELECT SCOPE_IDENTITY() AS NewProductID;
END;
GO

EXEC AddNewProduct
    @ItemDescription = 'Delicious Spaghetti with meat sauce',
    @Quantity = 50,
    @Image = 'spaghetti.jpg',
    @ItemName = 'Spaghetti Bolognese',
    @Category = 'Main Course',
    @SpiceLevel = 'Mild',
    @CookingTime = 30,
    @CurrentPrice = 200,
    @AvailabilityStatus = 1;

  ------update emplyee salary---

  CREATE PROCEDURE UpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Employee
    SET Salary = @NewSalary
    WHERE EmployeeID = @EmployeeID;
END;
GO

EXEC UpdateEmployeeSalary
    @EmployeeID = 1,   -- assume EmployeeID 1 exists
    @NewSalary = 503000;

	select * from Employee

	-----get vendor ingredients----
	CREATE PROCEDURE GetVendorIngredients
    @VendorID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IngredientID, IngredientName, RemainingStock, Unit, ExpiryDate, Type, LowStockAlert
    FROM Ingredient
    WHERE VendorID = @VendorID;
END;
GO


EXEC GetVendorIngredients
    @VendorID = 1;

	select * from Vendor

	---update login attempts--
	CREATE PROCEDURE UpdateLoginAttempts
    @Email VARCHAR(255),
    @NewAttempts INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE UserAuth
    SET LoginAttempts = @NewAttempts
    WHERE Email = @Email;
END;
GO


EXEC UpdateLoginAttempts
    @Email = 'testuser@example.com',
    @NewAttempts = 1;

	-----product inventory status---

	CREATE VIEW ProductInventory AS
SELECT 
    item_name AS ProductName,
    quantity AS AvailableQuantity,
    current_price AS Price,
    AvailablityStatus
FROM Product;
GO

SELECT * FROM ProductInventory;

----indredients inventory status--
CREATE VIEW IngredientInventory AS
SELECT 
    IngredientName,
    RemainingStock,
    Unit,
    ExpiryDate,
    LowStockAlert
FROM Ingredient;
GO

select * from IngredientInventory


-----daily invoice and orders details---
CREATE VIEW DailyOrderDetails AS
SELECT 
    CAST(o.OrderDate AS DATE) AS OrderDate,
    o.OrderID,
    o.OrderStatus,
    i.TotalAmount,
    i.PaidStatus
FROM Orders o
LEFT JOIN Invoice i ON o.OrderID = i.OrderID;
GO

select * from DailyOrderDetails
-----top sell products----

CREATE VIEW TopSellingProducts AS
SELECT top 1
    p.item_name AS ProductName,
    SUM(od.Quantity) AS TotalQuantitySold,
    SUM(od.Quantity * p.current_price) AS TotalRevenue
FROM OrderItems as  od
JOIN Product as p ON od.ProductID = p.id
GROUP BY p.item_name
ORDER BY TotalQuantitySold DESC;
GO

select *  from TopSellingProducts

drop view menu
-----view menu---
CREATE VIEW Menu AS
SELECT 
   
    item_name AS ProductName,
    item_description AS Description,
    Category,
    SpiceLevel,
    CookingTime,
    current_price AS Price,
    
    
    image AS ImagePath
FROM Product
where AvailablityStatus=1;
GO

select * from Menu
--,UserAuth,Users

select * from Employee
select * from UserAuth
select * from Users
-- new apis 
CREATE PROCEDURE sp_AddEmployee
    @Email VARCHAR(255),
    @Password VARCHAR(255),
    @FName VARCHAR(255),
    @LName VARCHAR(255),
    @DOB DATE,
    @Gender VARCHAR(10),
    @PhoneNo CHAR(11),
    @Address VARCHAR(255),
    @CNIC CHAR(15),
    @Salary INT,
    @BankAccount VARCHAR(255),
    @ManagerID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into UserAuth
    INSERT INTO UserAuth (Email, PasswordHash, LoginAttempts)
    VALUES (@Email, HASHBYTES('SHA2_256', @Password), 0);

    DECLARE @AuthID INT = SCOPE_IDENTITY();

    -- Insert into Users with Role = 'Employee'
    INSERT INTO Users (AuthID, Role, FName, LName, DOB, Gender, PhoneNo, Address)
    VALUES (@AuthID, 'Employee', @FName, @LName, @DOB, @Gender, @PhoneNo, @Address);

    DECLARE @UserID INT = SCOPE_IDENTITY();

    -- Insert into Employee
    INSERT INTO Employee (UserID, CNIC, Salary, BankAccount, ManagerID)
    VALUES (@UserID, @CNIC, @Salary, @BankAccount, @ManagerID);
END;
GO


-----add menu item---
select * from Product

CREATE PROCEDURE sp_AddMenuItem
    @item_name VARCHAR(255),
    @Category VARCHAR(255),
    @SpiceLevel VARCHAR(50),
    @CookingTime INT,
    @current_price INT,
    @AvailablityStatus INT,
    @item_description VARCHAR(500),
    @image VARCHAR(200),
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Product (item_name, Category, SpiceLevel, CookingTime, current_price, AvailablityStatus, item_description, image, quantity)
    VALUES (@item_name, @Category, @SpiceLevel, @CookingTime, @current_price, @AvailablityStatus, @item_description, @image, @quantity);
END;
GO

----- remove -- prodct
CREATE PROCEDURE sp_RemoveMenuItem
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Product WHERE id = @ProductID;
END;
GO

-- Test Run (adjust the ProductID accordingly):
EXEC sp_RemoveMenuItem @ProductID = 21;  -- Use an existing product id to test
GO

--- ad table---
CREATE PROCEDURE sp_AddTable
    @Capacity INT,
    @IsAvailable BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Tables (Capacity, IsAvailable)
    VALUES (@Capacity, @IsAvailable);
END;
GO

--- remove table---

CREATE PROCEDURE sp_RemoveTable
    @TableID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Tables WHERE TableID = @TableID;
END;
GO

--update table capacity---
CREATE PROCEDURE sp_UpdateTableCapacity
    @TableID INT,
    @NewCapacity INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Tables
    SET Capacity = @NewCapacity
    WHERE TableID = @TableID;
END;
GO
--
select * from Wallet


-- add money in walet
CREATE PROCEDURE sp_AddMoneyToWallet
    @CustomerID INT,
    @Amount DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @CustomerID)
    BEGIN
        RETURN -1;
    END
    
    IF NOT EXISTS (SELECT 1 FROM Wallet WHERE CustomerID = @CustomerID)
    BEGIN
        INSERT INTO Wallet (CustomerID, Balance)
        VALUES (@CustomerID, @Amount);
    END
    ELSE
    BEGIN
        UPDATE Wallet
        SET Balance = Balance + @Amount
        WHERE CustomerID = @CustomerID;
    END
    
    RETURN 1;
END
select * from wallet
--   update employee
CREATE PROCEDURE sp_UpdateEmployeeRole
    @EmployeeID INT,
    @NewRole VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    -- If role already exists, update it; otherwise insert a new role record.
    IF EXISTS (SELECT 1 FROM Role WHERE EmployeeID = @EmployeeID)
    BEGIN
        UPDATE Role
        SET Role = @NewRole
        WHERE EmployeeID = @EmployeeID;
    END
    ELSE
    BEGIN
        INSERT INTO Role (EmployeeID, Role)
        VALUES (@EmployeeID, @NewRole);
    END
END;
GO

EXEC sp_UpdateEmployeeRole @EmployeeID = 1, @NewRole = 'Sous Chef';
GO

CREATE PROCEDURE sp_ViewActiveOrders
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        o.OrderID,
        CONCAT(u.FName, ' ', u.LName) AS CustomerName,
        o.OrderDate,
        o.OrderStatus,
        p.item_name AS ProductName,
        oi.Quantity,
        oi.TotalPrice
    FROM Orders o
    INNER JOIN Customer c ON o.CustomerID = c.CustomerID
    INNER JOIN Users u ON c.UserID = u.UserID
    INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
    INNER JOIN Product p ON oi.ProductID = p.id
    WHERE o.OrderStatus NOT IN ('Delivered', 'Cancelled','Completed')
    ORDER BY o.OrderID;
END;
GO

exec sp_ViewActiveOrders

INSERT INTO OrderItems (OrderID, ProductID, Quantity, TotalPrice) VALUES
(2, 2, 1, 300),
(2, 1, 1, 300);
drop procedure sp_DeductFromWallet
select * from wallet

CREATE PROCEDURE sp_DeductFromWallet
    @CustomerID INT,
    @Amount DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentBalance DECIMAL(18,2);

    BEGIN TRY
        IF @Amount IS NULL OR @Amount <= 0
            THROW 50000, 'Amount must be positive', 1;

        SELECT @CurrentBalance = Balance
        FROM Wallet
        WHERE CustomerID = @CustomerID;

        IF @CurrentBalance IS NULL
            THROW 50001, 'Customer wallet not found', 1;

        IF @CurrentBalance < @Amount
            THROW 50002, 'Insufficient balance', 1;

        BEGIN TRANSACTION;

        UPDATE Wallet
        SET Balance = Balance - @Amount
        WHERE CustomerID = @CustomerID;

        COMMIT;

        SELECT 
            1 AS Success,
            'Deduction successful' AS Message,
            @CustomerID AS CustomerID,
            @Amount AS AmountDeducted,
            @CurrentBalance - @Amount AS NewBalance;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;

        SELECT 
            0 AS Success,
            ERROR_MESSAGE() AS Message,
            @CustomerID AS CustomerID,
            NULL AS AmountDeducted,
            NULL AS NewBalance;
    END CATCH
END
GO



use hi
delete from OrderItems
where productid=20

CREATE  PROCEDURE UpdateInventoryOnOrder
    @OrderID        INT,
    @ProductID      INT,
    @OrderQuantity  INT = 1,
	@current_price  INT 

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insert into OrderItem table with default TotalPrice of 50
        INSERT INTO OrderItems (OrderID, ProductID, Quantity, TotalPrice)
        VALUES (@OrderID, @ProductID, @OrderQuantity, @current_price*@OrderQuantity);

        -- Compute how much of each ingredient is needed for this product
        WITH IngredientConsumption AS (
            SELECT 
                r.IngredientID,
                SUM(r.Quantity * @OrderQuantity) AS TotalUsed
            FROM Recipes r
            WHERE r.ProductID = @ProductID
            GROUP BY r.IngredientID
        )
        -- Deduct from stock and update low-stock flag
        UPDATE i
        SET 
            i.RemainingStock = i.RemainingStock - ic.TotalUsed,
            i.LowStockAlert = CASE 
                                WHEN (i.RemainingStock - ic.TotalUsed) <= (0.1 * i.RemainingStock) 
                                THEN 1 
                                ELSE 0 
                              END
        FROM Ingredient i
        INNER JOIN IngredientConsumption ic 
            ON i.IngredientID = ic.IngredientID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE 
            @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(),
            @ErrorSeverity INT = ERROR_SEVERITY(),
            @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO


CREATE PROCEDURE [dbo].[GetAllIngredientNames]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        IngredientID,
        IngredientName
    FROM Ingredient
    ORDER BY IngredientName ASC;
END


-- reserve a table 

CREATE PROCEDURE sp_ReserveAvailableTable
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AvailableTableID INT;

    -- Step 1: Find an available table
    SELECT TOP 1 @AvailableTableID = TableID
    FROM Tables
    WHERE IsAvailable = 1
    ORDER BY TableID;

    -- Step 2: If no table available, return failure
    IF @AvailableTableID IS NULL
    BEGIN
        SELECT 'No table available' AS Message, NULL AS TableID;
        RETURN;
    END

    -- Step 3: Insert reservation
    INSERT INTO ReservedTables (OrderID, TableID, ReservationTime)
    VALUES (@OrderID, @AvailableTableID, GETDATE());

    -- Step 4: Mark table as unavailable
    UPDATE Tables
    SET IsAvailable = 0
    WHERE TableID = @AvailableTableID;

    -- Step 5: Return success message and reserved table ID
    SELECT 'Table reserved successfully' AS Message, @AvailableTableID AS TableID;
END

EXEC sp_ReserveAvailableTable @OrderID = 17;
select * from tables
    -- automatically un reserved a table 

CREATE TRIGGER trg_UnreserveTableOnOrderComplete
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE T
    SET T.IsAvailable = 1
    FROM Tables T
    INNER JOIN ReservedTables RT ON T.TableID = RT.TableID
    INNER JOIN inserted i ON RT.OrderID = i.OrderID
    WHERE i.OrderStatus = 'Completed';
END
UPDATE Orders
SET OrderStatus = 'Completed'
WHERE OrderID = 17;

use hi
-- admin login 
drop procedure sp_AuthenticateAdmin
CREATE PROCEDURE sp_AuthenticateAdmin
    @Email VARCHAR(255),
    @PasswordHash VARBINARY(64),
    @LoginSuccess INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AuthID INT;
    DECLARE @UserID INT;
    DECLARE @a INT;

    -- Step 1: Match credentials
    SELECT @AuthID = AuthID 
    FROM UserAuth 
    WHERE Email = @Email AND PasswordHash = @PasswordHash;

    PRINT 'AuthID: ' + CAST(@AuthID AS VARCHAR);

    IF @AuthID IS NOT NULL
    BEGIN
        -- Step 2: Match customer role
        SELECT @UserID = UserID 
        FROM Users 
        WHERE AuthID = @AuthID AND Role = 'admin';

        PRINT 'UserID: ' + CAST(@UserID AS VARCHAR);
	
        IF @UserID IS NOT NULL
        BEGIN
            -- Step 3: Get CustomerID
            SELECT @a= AdminID
            FROM admin 
            WHERE UserID = @UserID;

            PRINT 'Adminid: ' + CAST(@a AS VARCHAR);

            IF @a IS NOT NULL
                SET @LoginSuccess = 1;
            ELSE
                SET @LoginSuccess = 1;  -- Customer row not found
        END
        ELSE
        BEGIN
            SET @LoginSuccess = -2;  -- No user with role Customer
        END
    END
    ELSE
    BEGIN
        SET @LoginSuccess = 0;  -- Invalid credentials
    END
END;
GO



 CREATE PROCEDURE AddIngredient
    @IngredientName VARCHAR(255),
    @RemainingStock INT,
    @Unit VARCHAR(255),
    @ExpiryDate DATE,
    @VendorID INT = NULL,
    @Type VARCHAR(10),
    @LowStockAlert BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Ingredient (
            IngredientName,
            RemainingStock,
            Unit,
            ExpiryDate,
            VendorID,
            Type,
            LowStockAlert
        )
        VALUES (
            @IngredientName,
            @RemainingStock,
            @Unit,
            @ExpiryDate,
            @VendorID,
            @Type,
            @LowStockAlert
        );
    END TRY
    BEGIN CATCH
        -- Optional: Raise an error or print it
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO



CREATE PROCEDURE AddIngredientSupply
    @IngredientID   INT,
    @VendorID       INT,
    @PurchaseDate   DATE,
    @PurchaseAmount INT,
    @PurchaseRate   INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1) Log the supply
        INSERT INTO IngredientSupply
            (IngredientID, VendorID, PurchaseDate, PurchaseAmount, PurchaseRate)
        VALUES
            (@IngredientID, @VendorID, @PurchaseDate, @PurchaseAmount, @PurchaseRate);

        -- 2) Add purchased amount to remaining stock
        UPDATE Ingredient
        SET RemainingStock = RemainingStock + @PurchaseAmount
        WHERE IngredientID = @IngredientID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;  -- propagate the error
    END CATCH
END;
GO

ALTER TABLE dbo.IngredientSupply
    DROP CONSTRAINT IngredientSupply_CPK;
GO


CREATE TRIGGER trg_UpdateLowStockAlert
ON Ingredient
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Update LowStockAlert to 1 if RemainingStock is less than 100, else 0
    UPDATE i
    SET LowStockAlert = 
        CASE 
            WHEN i.RemainingStock < 10000 THEN 1
            ELSE 0
        END
    FROM Ingredient i
    INNER JOIN inserted ins ON i.IngredientID = ins.IngredientID;
END;



CREATE PROCEDURE GetIngredientInventory
AS
BEGIN
    SELECT 
	IngredientID,
        IngredientName,
        RemainingStock,
        Unit,
        ExpiryDate,
        LowStockAlert
    FROM Ingredient;
END;
GO

CREATE PROCEDURE GetAllEmployees
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        E.EmployeeID,
        E.UserID,
        U.FName,
        E.CNIC,
        E.Salary,
        E.BankAccount,
        E.ManagerID,
        M.UserID AS ManagerUserID,
        MU.FName AS ManagerName
    FROM Employee E
    LEFT JOIN Users U ON E.UserID = U.UserID
    LEFT JOIN Employee M ON E.ManagerID = M.EmployeeID
    LEFT JOIN Users MU ON M.UserID = MU.UserID
END;
GO

CREATE PROCEDURE RemoveEmployeeByID
    @EmployeeID INT
AS
BEGIN
   
    DELETE FROM Employee WHERE EmployeeID = @EmployeeID;
END;

CREATE TRIGGER trg_OrderCancelled
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

 
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.OrderID = d.OrderID
        WHERE i.OrderStatus = 'Cancelled' AND d.OrderStatus != 'Cancelled'
    )
    BEGIN
       
        DECLARE @OrderID INT, @CustomerID INT, @Amount INT;

        SELECT TOP 1 
            @OrderID = i.OrderID,
            @CustomerID = o.CustomerID,
            @Amount = inv.TotalAmount
        FROM inserted i
        JOIN Orders o ON i.OrderID = o.OrderID
        JOIN Invoice inv ON i.OrderID = inv.OrderID;

        DELETE FROM Invoice WHERE OrderID = @OrderID;

  
        UPDATE Wallet
        SET Balance = Balance + @Amount
        WHERE CustomerID = @CustomerID;
    END
END;

