create database hi;
go
USE hi;
GO


--Table: User Authorization
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
