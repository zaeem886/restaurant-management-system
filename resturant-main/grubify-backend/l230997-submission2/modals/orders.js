const { sql, poolPromise } = require("../db.js");

const User = {
   
    async  placeorder(userData) {
        try {
            const pool = await poolPromise;
    
            const result = await pool.request()
                .input("CustomerID", sql.Int, userData.CustomerID)
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
  
        // 1. Generate Invoice
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
    
        // 2. Reserve Table
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
    
        // 3. Wallet Transaction
        async addWalletTransaction(userData) {
            try {
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("CustomerID", sql.Int, userData.CustomerID)
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
    
        // 4. Get Customer Order History
        async getCustomerOrderHistory(userData) {
            try {
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("CustomerID", sql.Int, userData.CustomerID)
                    .execute("GetCustomerOrderHistory");
    
                return { message: "Order history retrieved successfully", Orders: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to fetch order history");
            }
        },
    
        // 5. Add Ingredient Supply Record
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
    
        // 6. Get Daily Sales Report
        async DailySalesReport(userData) {
            try {
                const pool = await poolPromise;
                const result = await pool.request()
                    .input("OrderDate", sql.Date, userData.OrderDate)
                    .query("SELECT * FROM DailySalesReport WHERE OrderDate = @OrderDate");
    
                return { message: "Daily sales report retrieved successfully", Report: result.recordset };
            } catch (error) {
                console.error("Database query failed:", error);
                throw new Error("Failed to fetch daily sales report");
            }
        },

        async addproduct(userData) {
            try {
                const pool = await poolPromise;
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
                const result = await pool.request().query("SELECT * FROM IngredientInventory");
    
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
        
         // Add Employee
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

    // Add Menu Item
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

    // Remove Menu Item
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

    // Add Table
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

    // Remove Table
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

    // Update Table Capacity
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

    // Add Money to Wallet
    async addMoneyToWallet(CustomerID, Amount) {
        try {
            const pool = await poolPromise;
            await pool.request()
                .input("CustomerID", CustomerID)
                .input("Amount", Amount)
                .execute("sp_AddMoneyToWallet");

            return { message: "Money added to wallet successfully" };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to add money to wallet");
        }
    },
    async  updateEmployeeRole(employeeData) {
        try {
            const pool = await poolPromise;
            const result = await pool.request()
                .input("EmployeeID", sql.Int, employeeData.EmployeeID)
                .input("NewRole", sql.VarChar, employeeData.NewRole)
                .execute("sp_UpdateEmployeeRole");
    
            return { message: "Employee role updated successfully", result: result.recordset };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("Failed to update employee role");
        }
    }
};


module.exports = User;
