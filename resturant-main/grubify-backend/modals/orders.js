const { sql, poolPromise } = require("../db.js");

const User = {


    async getAllIngredientNames() {
        try {
            const pool = await poolPromise;
            
            const result = await pool.request()
                .execute("GetAllIngredientNames"); 
            return result.recordset;
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to fetch ingredient names");
        }
    },


    async updateIngredients(orderData) {
        try {
            const pool = await poolPromise;
            const { order, customer_id,order_type ,PaymentMethod} = orderData;
      
            console.log("customer_id:", customer_id);
            const customer_idd= parseInt(customer_id);
           console.log(typeof customer_idd);
            if (!Number.isInteger(customer_idd) || customer_idd <= 0) {
                throw new Error(`Invalid customer_id: ${customer_idd}`);
            }
    
         
            const orderResult = await pool.request()
                .input("CustomerID", sql.Int, customer_idd)
                .input("OrderType", sql.VarChar,order_type)
                .input("OrderDate", sql.DateTime, new Date())
                .input("OrderStatus", sql.VarChar, "Pending")
                .input("Rating", sql.Int, null)
                .input("Feedback", sql.VarChar, null)
                .query(`
                    INSERT INTO [Orders] (CustomerID, OrderType, OrderDate, OrderStatus, Rating, Feedback)
                    OUTPUT INSERTED.OrderID
                    VALUES (@CustomerID, @OrderType, @OrderDate, @OrderStatus, @Rating, @Feedback)
                `);
    
            const OrderID = orderResult.recordset[0].OrderID;
            console.log("Generated OrderID:", OrderID);
    
            if (!Number.isInteger(OrderID) || OrderID <= 0) {
                throw new Error(`Invalid OrderID: ${OrderID}`);
            }
    
            if (!Array.isArray(order) || order.length === 0) {
                throw new Error("order must be a non-empty array");
            }
            let TotalAmount=99;
    
            for (const item of order) {
                const { item_id, quantity ,current_price} = item;
                TotalAmount+=current_price*quantity;
                if (!Number.isInteger(item_id) || item_id <= 0) {
                    throw new Error(`Invalid item_id: ${item_id}`);
                }
                if (!Number.isInteger(quantity) || quantity <= 0) {
                    throw new Error(`Invalid quantity for item_id ${item_id}: ${quantity}`);
                }
    
                await pool.request()
                    .input("OrderID", sql.Int, OrderID)
                    .input("productid", sql.Int, item_id)
                    .input("orderquantity", sql.Int, quantity)
                    .input("current_price", sql.Int, current_price)
                    .execute("UpdateInventoryOnOrder");
            }

               let Tax = 16;
               if(PaymentMethod==="card"){
                Tax = 5;
            }

            if (order_type.toLowerCase() === "dine-in") {
                TotalAmount-=99;
                const tableRes = await pool.request()
                    .input("OrderID", sql.Int, OrderID)
                    .execute("sp_ReserveAvailableTable");
            
                const reservationResult = tableRes.recordset[0];
            
                if (!reservationResult || reservationResult.Message !== 'Table reserved successfully') {
                    throw new Error("Table reservation failed after placing order.");
                }
            
                console.log("Reserved Table ID:", reservationResult.TableID);
            }
            
            const invoiceResult = await pool.request()
    .input("OrderID", sql.Int, OrderID)
    .input("TotalAmount", sql.Int, TotalAmount)
    .input("Tax", sql.Int, Tax) 
    .input("DiscountApplied", sql.Int, 0) 
    .input("PaidStatus", sql.VarChar, "paid")
    .input("PaymentMethod", sql.VarChar, PaymentMethod)
    .execute("GenerateInvoice");

const invoiceID = invoiceResult.recordset[0].NewInvoiceID;
console.log("Invoice created with ID:", invoiceID);
    
            return { message: "Order placed and ingredients updated  successfully", OrderID };
        } catch (error) {
            console.error("Database query failed:", error);
            if (error.message.includes("Insufficient stock")) {
                throw new Error("Insufficient stock for one or more ingredients");
            }
            if (error.message.includes("CHECK constraint")) {
                throw new Error("Update failed due to insufficient ingredient stock");
            }
            throw new Error(`Failed to update ingredients: ${error.message}`);
        }
    },
    async  placeorder(userData) {
        try {
            const pool = await poolPromise;
    
            const result = await pool.request()
                .input("customer_id", sql.Int, userData.customer_id)
                .input("OrderType", sql.VarChar,  userData.OrderType) 
                .input("OrderStatus", sql.VarChar,  userData.OrderStatus)
                .execute("sp_PlaceOrder");
         return { message: "order placed successfully", result: result.recordset };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error(" failed");
        }
    },

    async  feedback(userData) {
        try {
            const pool = await poolPromise;
    
            const result = await pool.request()
                .input("OrderID", sql.Int, userData.OrderID)
                .input("UserID", sql.Int,  userData.UserID) 
                .input("Rating", sql.Int,  userData.Rating)
                .input("Feedback", sql.Text,  userData.Feedback)
                .execute("UpdateOrderFeedback");
         return { message: "feedback placed successfully", result: result.recordset };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error(" failed");
        }
    },

    async  addorderitem(userData) {
        try {
            const pool = await poolPromise;
    
            const result = await pool.request()
                .input("OrderID", sql.Int, userData.OrderID)
                .input("ProductID", sql.Int,  userData.ProductID) 
                .input("Quantity", sql.Int,  userData.Quantity)
                .input("TotalPrice", sql.Int,  userData.TotalPrice)
                .execute("AddOrderItem");
         return { message: "order items added   successfully", result: result.recordset };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error(" failed");
        }
    },
    async  UpdateOrderStatus(userData) {
        try {
            const pool = await poolPromise;
    
            const result = await pool.request()
                .input("OrderID", sql.Int, userData.OrderID)
                .input("NewStatus", sql.VarChar,  userData.NewStatus) 

                .execute("UpdateOrderStatus");
         return { message: "update order status   successfully", result: result.recordset };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error(" failed");
        }
    },
  
  
        async generateInvoice(userData) {
            try {
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("OrderID", sql.Int, userData.OrderID)
                    .input("TotalAmount", sql.Int, userData.TotalAmount)
                    .input("Tax", sql.Int, userData.Tax || 16)
                    .input("DiscountApplied", sql.Int, userData.DiscountApplied || 0)
                    .input("PaidStatus", sql.VarChar, userData.PaidStatus)
                    .input("PaymentMethod", sql.VarChar, userData.PaymentMethod)
                    .execute("GenerateInvoice");
    
                return { message: "Invoice generated successfully", InvoiceID: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Invoice generation failed");
            }
        },
    
  
        async reserveTable(userData) {
            try {
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("OrderID", sql.Int, userData.OrderID)
                    .input("TableID", sql.Int, userData.TableID)
                    .input("ReservationTime", sql.DateTime, userData.ReservationTime)
                    .execute("ReserveTable");
    
                return { message: "Table reserved successfully", ReservationID: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Table reservation failed");
            }
        },
    
   
        async addWalletTransaction(userData) {
            try {
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("customer_id", sql.Int, userData.customer_id)
                    .input("TransactionType", sql.VarChar, userData.TransactionType)
                    .input("Amount", sql.Int, userData.Amount)
                    .input("OrderID", sql.Int, userData.OrderID || null)
                    .execute("AddWalletTransaction");
    
                return { message: "Wallet transaction successful", TransactionID: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Wallet transaction failed");
            }
        },
  
        async getCustomerOrderHistory(userData) {
            try {
                const customer_id = parseInt(userData.customer_id);
                if (isNaN(customer_id)) {
                    throw new Error("Invalid customer_id provided");
                }
           console.log("Received customer_id:", customer_id);
                console.log("Received customer_id:", customer_id);
        
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("CustomerID", sql.Int, customer_id)
                    .execute("GetCustomerOrderHistory");
        
                return {
                    message: "Order history retrieved successfully",
                    Orders: result.recordset
                };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Database operation failed: " + error.message);
            }
        },
        
        
        async addIngredientSupply(userData) {
            try {
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("IngredientID", sql.Int, userData.IngredientID)
                    .input("VendorID", sql.Int, userData.VendorID)
                    .input("PurchaseDate", sql.Date, userData.PurchaseDate)
                    .input("PurchaseAmount", sql.Int, userData.PurchaseAmount)
                    .input("PurchaseRate", sql.Int, userData.PurchaseRate)
                    .execute("AddIngredientSupply");
    
                return { message: "Ingredient supply record added successfully" };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to add ingredient supply record");
            }
        },
    
    
        async DailySalesReport(userData) {
            try {
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("OrderDate", sql.Date, userData.OrderDate)
                    .query("SELECT * FROM DailySalesReport WHERE OrderDate = @OrderDate");
    
                return { message: "", Report: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to fetch daily sales report");
            }
        },

        async addproduct(userData) {
            try {
                const pool = await poolPromise;
                console.log(userData);
                const result = await pool.request()
                    .input("ItemDescription", sql.VarChar(500), userData.ItemDescription)
                    .input("Quantity", sql.Int, userData.Quantity)
                    .input("Image", sql.VarChar(200), userData.Image)
                    .input("ItemName", sql.VarChar(255), userData.ItemName)
                    .input("Category", sql.VarChar(255), userData.Category)
                    .input("SpiceLevel", sql.VarChar(255), userData.SpiceLevel)
                    .input("CookingTime", sql.Int, userData.CookingTime)
                    .input("CurrentPrice", sql.Int, userData.CurrentPrice)
                    .input("AvailabilityStatus", sql.Int, userData.AvailabilityStatus || 0)
                    .execute("AddNewProduct");
    
                return { message: "Product added successfully", result: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to add new product");
            }
        },
        async addRecipeItems(productID, recipeItems) {
            try {
                const pool = await poolPromise;
        
                for (const item of recipeItems) {
                    const { IngredientID, Quantity } = item;
            
                    await pool.request()
                        .input("ProductID", sql.Int, productID)
                        .input("IngredientID", sql.Int, IngredientID)
                        .input("Quantity", sql.Int, Quantity)
                        .query(`
                            INSERT INTO Recipes (ProductID, IngredientID, Quantity)
                            VALUES (@ProductID, @IngredientID, @Quantity)
                        `);
                }
        
                return { message: "Recipe added successfully for product ID: " + productID };
            } catch (error) {
                console.error("Database query failed while adding recipe:", error);
                throw new Error("Failed to add recipe");
            }
        },
        
        async updatesalary(userData) {
            try {
                const pool = await poolPromise;
                await pool.request()
                    .input("EmployeeID", sql.Int, userData.EmployeeID)
                    .input("NewSalary", sql.Int, userData.NewSalary)
                    .execute("UpdateEmployeeSalary");
    
                return { message: "Salary updated successfully" };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to update salary");
            }
        },
    

        async vendoringredients(userData) {
            try {
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("VendorID", sql.Int, userData.VendorID)
                    .execute("GetVendorIngredients");
    
                return { message: "Vendor ingredients retrieved successfully", Ingredients: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to fetch vendor ingredients");
            }
        },
   
        async UpdateLoginAttempts(userData) {
            try {
                const pool = await poolPromise;
                await pool.request()
                    .input("Email", sql.VarChar(255), userData.Email)
                    .input("NewAttempts", sql.Int, userData.NewAttempts)
                    .execute("UpdateLoginAttempts");
    
                return { message: "Login attempts updated successfully" };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to update login attempts");
            }
        },
    
        async GetProductInventory() {
            try {
                const pool = await poolPromise;
                const result = await pool.request().query("SELECT * FROM ProductInventory");
    
                return { message: "Product inventory retrieved successfully", Inventory: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to fetch product inventory");
            }
        },
    
        
        async ingredientInventory() {
            try {
                const pool = await poolPromise;
            const result = await pool.request().execute("GetIngredientInventory");
    
                return { message: "Ingredient inventory retrieved successfully", Inventory: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to fetch ingredient inventory");
            }
        },
    
        async dailyOrderDetails(userData) {
            try {
                if (!userData || !userData.OrderDate) {
                    throw new Error("Invalid input: OrderDate is required");
                }
        
                console.log("Received OrderDate:", userData.OrderDate);  // Debugging log
        
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("OrderDate", sql.Date, userData.OrderDate)  // Use sql.Date
                    .query("SELECT * FROM DailyOrderDetails WHERE OrderDate >= @OrderDate AND OrderDate < DATEADD(DAY, 1, @OrderDate)");
        
                return { message: "Daily order details retrieved successfully", Orders: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to fetch daily order details");
            }
        },
        
        
    
        async topSellingProducts() {
            try {
                const pool = await poolPromise;
                const result = await pool.request().query("SELECT * FROM TopSellingProducts");
    
                return { message: "Top selling products retrieved successfully", Products: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to fetch top-selling products");
            }
        },

        async getMenu() {
            try {
                const pool = await poolPromise;
                const result = await pool.request().query("SELECT * FROM Menu");
    
                return { message: "Menu retrieved successfully", Menu: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to fetch menu");
            }
        },
        
 
    async addemployee(employeeData) {
        try {
            const pool = await poolPromise;
            const result = await pool.request()
                .input("Email", employeeData.Email)
                .input("Password", employeeData.Password)
                .input("FName", employeeData.FName)
                .input("LName", employeeData.LName)
                .input("DOB", employeeData.DOB)
                .input("Gender", employeeData.Gender)
                .input("PhoneNo", employeeData.PhoneNo)
                .input("Address", employeeData.Address)
                .input("CNIC", employeeData.CNIC)
                .input("Salary", employeeData.Salary)
                .input("BankAccount", employeeData.BankAccount)
                .input("ManagerID", employeeData.ManagerID || null)
                .execute("sp_AddEmployee");

            return { message: "Employee added successfully", result };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to add employee");
        }
    },

    async addmenuitem(menuData) {
        try {
            const pool = await poolPromise;
            const result = await pool.request()
                .input("item_name", menuData.item_name)
                .input("Category", menuData.Category)
                .input("SpiceLevel", menuData.SpiceLevel)
                .input("CookingTime", menuData.CookingTime)
                .input("current_price", menuData.current_price)
                .input("AvailablityStatus", menuData.AvailablityStatus)
                .input("item_description", menuData.item_description)
                .input("image", menuData.image)
                .input("quantity", menuData.quantity)
                .execute("sp_AddMenuItem");

            return { message: "Menu item added successfully", result };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to add menu item");
        }
    },


    async removeMenuItem(ProductID) {
        try {
            const pool = await poolPromise;
            await pool.request()
                .input("ProductID", ProductID)
                .execute("sp_RemoveMenuItem");

            return { message: "Menu item removed successfully" };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to remove menu item");
        }
    },


    async addtable(Capacity, IsAvailable = 1) {
        try {
            const pool = await poolPromise;
            await pool.request()
                .input("Capacity", Capacity)
                .input("IsAvailable", IsAvailable)
                .execute("sp_AddTable");

            return { message: "Table added successfully" };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to add table");
        }
    },

    async removeTable(TableID) {
        try {
            const pool = await poolPromise;
            await pool.request()
                .input("TableID", TableID)
                .execute("sp_RemoveTable");

            return { message: "Table removed successfully" };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to remove table");
        }
    },

    async updateTableCapacity(TableID, NewCapacity) {
        try {
            const pool = await poolPromise;
            await pool.request()
                .input("TableID", TableID)
                .input("NewCapacity", NewCapacity)
                .execute("sp_UpdateTableCapacity");

            return { message: "Table capacity updated successfully" };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to update table capacity");
        }
    },



    async deductMoneyToWallet(customer_id, Amount) {
        try {
            console.log("customer_id:", customer_id);
            console.log(typeof customer_id);
            if (!Amount || isNaN(Amount) || Amount <= 0) {
                throw new Error('Amount must be a valid positive number');
            }
    
            const pool = await poolPromise;
            const result = await pool.request()
                .input('CustomerID', sql.Int, customer_id)
                .input('Amount', sql.Decimal(18, 2), parseFloat(Amount))
                .execute('sp_DeductFromWallet');
    
            const operationResult = result.recordset[0];
    
            if (!operationResult.Success) {
                throw new Error(operationResult.Message);
            }
    
            return operationResult;
        } catch (error) {
            console.error('Deduction Error:', error);
            throw error;
        }
    },
    async addMoneyToWallet(customer_id, Amount) {
        try {
            const pool = await poolPromise;
            const request = pool.request();
            
           
            const result = await request
                .input('CustomerID', sql.Int, customer_id)
                .input('Amount', sql.Decimal(18, 2), Amount)
                .execute('sp_AddMoneyToWallet');
            
           
            const returnValue = result.returnValue;
            
            if (returnValue === -1) {
                throw new Error('Customer does not exist');
            }
            
            return { message: 'Money added successfully' };
        } catch (error) {
            console.error('Database Error:', error);
            throw error;
        }
    },
    async checkIfTableAvailable() {
        try {
            const pool = await poolPromise;
            const request = pool.request();
            const result = await request.query(`
                SELECT TOP 1 TableID 
                FROM Tables 
                WHERE IsAvailable = 1
            `);
            if (result.recordset.length > 0) {
                return { available: true, tableID: result.recordset[0].TableID };
            } else {
                return { available: false };
            }
        } catch (error) {
            console.error('Database Error:', error);
            throw error;
        }
    },
    async viewActiveOrders() {
        try {
            const pool = await poolPromise;
            const result = await pool.request().execute("sp_ViewActiveOrders");
    
            return { 
                message: "Active orders retrieved successfully", 
                orders: result.recordset 
            };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to fetch active orders");
        }
    },
    async addingredient(ingredientData) {
        try {
            const pool = await poolPromise;
            const result = await pool.request()
                .input("IngredientName", sql.VarChar(255), ingredientData.IngredientName)
                .input("RemainingStock", sql.Int, ingredientData.RemainingStock)
                .input("Unit", sql.VarChar(255), ingredientData.Unit)
                .input("ExpiryDate", sql.Date, ingredientData.ExpiryDate)
                .input("VendorID", sql.Int, ingredientData.VendorID || null)
                .input("Type", sql.VarChar(10), ingredientData.Type)
                .input("LowStockAlert", sql.Bit, ingredientData.LowStockAlert)
                .execute("AddIngredient");
    
            return { message: "Ingredient added successfully", result: result.recordset };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to add new ingredient");
        }
    },
    
    async getAllEmployees() {
        try {
            const pool = await poolPromise;
            const result = await pool.request().execute('GetAllEmployees');
            return {
                message: 'Employees retrieved successfully',
                employees: result.recordset
            };
        } catch (error) {
            console.error('Modal Error:', error);
            throw new Error('Failed to fetch employees');
        }
    },
    async  removeEmployeeByID(id) {
        const pool = await poolPromise;
        await pool.request()
          .input('EmployeeID', sql.Int, id)
          .execute('RemoveEmployeeByID');
    },
    async getOrdersByDateRange(startDate, endDate) {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('StartDate', sql.DateTime, startDate)
            .input('EndDate', sql.DateTime, endDate)
            .query(`
                SELECT 
                    o.OrderID,
                    o.CustomerID,
                    o.OrderType,
                    o.OrderDate,
                    o.OrderStatus,
                    o.Rating,
                    o.Feedback
                FROM Orders o
                LEFT JOIN Customer c ON o.CustomerID = c.CustomerID
                WHERE o.OrderDate BETWEEN @StartDate AND @EndDate
                ORDER BY o.OrderDate DESC
            `);
        return result.recordset;
    },
    async getSalesReport(startDate, endDate) {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('StartDate', sql.DateTime, startDate)
            .input('EndDate', sql.DateTime, endDate)
            .query(`
                SELECT 
                    o.OrderID,
                    o.OrderDate,
                    o.OrderType,
                    i.InvoiceID,
                    i.TotalAmount,
                    i.Tax,
                    i.DiscountApplied,
                    i.PaymentMethod,
                    i.PaidStatus,
                    (i.TotalAmount - i.DiscountApplied) AS NetAmount,
                    ((i.TotalAmount - i.DiscountApplied) * i.Tax / 100) AS TaxAmount,
                    (i.TotalAmount - i.DiscountApplied + ((i.TotalAmount - i.DiscountApplied) * i.Tax / 100)) AS GrandTotal
                FROM Orders o
                JOIN Invoice i ON o.OrderID = i.OrderID
                LEFT JOIN Customer c ON o.CustomerID = c.CustomerID
                WHERE o.OrderDate BETWEEN @StartDate AND @EndDate
                ORDER BY o.OrderDate DESC
            `);
        
      
        const summary = {
            totalSales: 0,
            totalDiscount: 0,
            totalTax: 0,
            grandTotal: 0,
            paymentMethods: {},
            orderTypes: {}
        };

        result.recordset.forEach(sale => {
            summary.totalSales += sale.TotalAmount;
            summary.totalDiscount += sale.DiscountApplied;
            summary.totalTax += sale.TaxAmount;
            summary.grandTotal += sale.GrandTotal;
            
            summary.paymentMethods[sale.PaymentMethod] = 
                (summary.paymentMethods[sale.PaymentMethod] || 0) + 1;
                
       
            summary.orderTypes[sale.OrderType] = 
                (summary.orderTypes[sale.OrderType] || 0) + 1;
        });

        return {
            sales: result.recordset,
            summary
        };
    },
    async getMonthlyReport(year, month) {
        const pool = await poolPromise;
        const startDate = new Date(year, month - 1, 1);
        const endDate = new Date(year, month, 0);
        
        try {
            // 1. Get ingredient supplies for the month
            const ingredientSupplies = await pool.request()
                .input('StartDate', sql.Date, startDate)
                .input('EndDate', sql.Date, endDate)
                .query(`
                    SELECT 
                        SUM(PurchaseAmount * PurchaseRate) AS TotalIngredientCost,
                        COUNT(IngredientID) AS SupplyTransactions
                    FROM IngredientSupply
                    WHERE PurchaseDate BETWEEN @StartDate AND @EndDate
                `);
            
            // 2. Get total sales from invoices
            const sales = await pool.request()
                .input('StartDate', sql.Date, startDate)
                .input('EndDate', sql.Date, endDate)
                .query(`
                    SELECT 
                        SUM(TotalAmount - DiscountApplied + 
                            ((TotalAmount - DiscountApplied) * Tax / 100)) AS TotalSales,
                        SUM(DiscountApplied) AS TotalDiscounts,
                        COUNT(InvoiceID) AS TotalTransactions
                    FROM Invoice i
                    JOIN Orders o ON i.OrderID = o.OrderID
                    WHERE o.OrderDate BETWEEN @StartDate AND @EndDate
                    AND i.PaidStatus = 'Paid'
                `);
            
            return {
                // Sales Data
                totalSales: sales.recordset[0].TotalSales || 0,
                totalDiscounts: sales.recordset[0].TotalDiscounts || 0,
                salesTransactions: sales.recordset[0].TotalTransactions || 0,
                
                // Expense Data
                ingredientCost: ingredientSupplies.recordset[0].TotalIngredientCost || 0,
                supplyTransactions: ingredientSupplies.recordset[0].SupplyTransactions || 0,
                
          
                reportPeriod: `${year}-${month.toString().padStart(2, '0')}`,
                startDate: startDate.toISOString().split('T')[0],
                endDate: endDate.toISOString().split('T')[0]
            };
            
        } catch (error) {
            console.error('Database error in getMonthlyReport:', error);
            throw error;
        }
    },
     async getAllVendors() {
        const pool = await poolPromise;
        const result = await pool.request().query('SELECT * FROM Vendor ORDER BY VendorID DESC');
        return result.recordset;
    },

     async addVendor(vendorData) {
        const pool = await poolPromise;
        const result = await pool.request()
            .input('FName', sql.VarChar(255), vendorData.FName)
            .input('LName', sql.VarChar(255), vendorData.LName)
            .input('CNIC', sql.VarChar(15), vendorData.CNIC)
            .input('Address', sql.VarChar(255), vendorData.Address)
            .input('PhoneNo', sql.VarChar(11), vendorData.PhoneNo)
            .input('Email', sql.VarChar(255), vendorData.Email)
            .query(`
                INSERT INTO Vendor (FName, LName, CNIC, Address, PhoneNo, Email)
                VALUES (@FName, @LName, @CNIC, @Address, @PhoneNo, @Email);
                SELECT SCOPE_IDENTITY() AS VendorID;
            `);
        return result.recordset[0];
    },

     async removeVendor(vendorId) {
        const pool = await poolPromise;
        await pool.request()
            .input('VendorID', sql.Int, vendorId)
            .query('DELETE FROM Vendor WHERE VendorID = @VendorID');
    }




      

    
};


module.exports = User;
