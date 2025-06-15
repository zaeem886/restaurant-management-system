	----to create new acc and insert into database---
	CREATE PROCEDURE sp_RegisterUser
    @Email VARCHAR(255),
    @PasswordHash varchar(64),
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

        -- Insert into UserAuth
        INSERT INTO UserAuth (Email, PasswordHash)
        VALUES (@Email, @PasswordHash);

        DECLARE @AuthID INT = SCOPE_IDENTITY();

        -- Insert into Users
        INSERT INTO Users (AuthID, Role, FName, LName, DOB, Gender, PhoneNo, Address)
        VALUES (@AuthID, @Role, @FName, @LName, @DOB, @Gender, @PhoneNo, @Address);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
EXEC sp_RegisterUser
    @Email = 'testuser@example.com',
    @PasswordHash = 12123456,  -- sample binary hash
    @Role = 'Customer',
    @FName = 'John',
    @LName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'Male',
    @PhoneNo = '01234567890',
    @Address = '123 Main Street';
	select *  from UserAuth 

	drop procedure sp_AuthenticateUser


	-------to  login---
CREATE PROCEDURE sp_AuthenticateUser
    @Email VARCHAR(255),
    @PasswordHash VARBINARY(64)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1 
        FROM UserAuth AS ua
        JOIN Users AS u ON ua.AuthID = u.AuthID
        WHERE ua.Email = @Email
          AND ua.PasswordHash = @PasswordHash
    )
    BEGIN
        PRINT 'Login Successful';
    END
    ELSE
    BEGIN
        PRINT 'Invalid Email or Password';
    END
END;
GO



EXEC sp_AuthenticateUser
    @Email = 'testuser@example.com',
    @PasswordHash = 12123456;




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
    @OrderID = 3,
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
    @Amount INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Wallet
    SET Balance = Balance + @Amount
    WHERE CustomerID = @CustomerID;
END;
GO

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

EXEC sp_UpdateEmployeeRole @EmployeeID = 1, @NewRole = 'Sous Chef';
GO
