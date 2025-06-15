const User = require("../modals/orders.js");
const { get } = require("../routes/ordersrouters.js");

const getAllIngredientNames = async (req, res) => {
    try {
        const ingredients = await User.getAllIngredientNames();
        res.status(200).json(ingredients);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const updateIngredients = async (req, res) => {
    try {
        const orderData = req.body;
        console.log("New Order Received from Customer:", orderData.customer_id);
        console.log("Order Details hehe:", orderData.order);
        console.log("Order Details hehe:", orderData.order_type);
        console.log("Order Details hehe:", orderData.PaymentMethod);
        const result = await User.updateIngredients(orderData);
        res.status(201).json(result);
          
    } catch (error) {
        console.error("Controller error:", error);
        res.status(500).json({ error: error.message });
    }
};
const placeorder = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.placeorder(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const feedback = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.feedback(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addorderitem = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.addorderitem(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const UpdateOrderStatus = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.UpdateOrderStatus(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const generateInvoice = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.generateInvoice(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const reserveTable = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.reserveTable(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addWalletTransaction = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.addWalletTransaction(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const getCustomerOrderHistory = async (req, res) => {
    try {
        let { customerId } = req.params;
        console.log("Customer ID (raw):", customerId);

        customerId = parseInt(customerId); // Convert string to int
        console.log("Parsed Customer ID:", customerId);

        if (isNaN(customerId)) {
            return res.status(400).json({ error: "Invalid Customer ID" });
        }

        const result = await User.getCustomerOrderHistory({ customer_id: customerId });

        if (!result.Orders || result.Orders.length === 0) {
            return res.status(404).json({ 
                message: "No orders found for this customer",
                Orders: []
            });
        }

        res.status(200).json(result);
    } catch (error) {
        console.error("Controller Error:", error);
        res.status(500).json({ 
            error: "Internal server error",
            details: error.message 
        });
    }
};

const addIngredientSupply = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.addIngredientSupply(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const DailySalesReport = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.DailySalesReport(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addproduct = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.addproduct(userData); // This returns product ID
        const productID = result.result[0].NewProductID;
         console.log("result is ",result);
         console.log(productID);
        if (!productID) {
            throw new Error("Product ID not returned after insertion");
        }

        const { Recipe } = userData; // Recipe: [{ ingredient_id, quantity }, ...]

        if (!Array.isArray(Recipe) || Recipe.length === 0) {
            throw new Error("Recipe data missing or invalid");
        }

        await User.addRecipeItems(productID, Recipe);

        res.status(201).json({ message: "Product and Recipe added successfully", productID });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const updatesalary = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.updatesalary(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


const vendoringredients = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.vendoringredients(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


const UpdateLoginAttempts = async (req, res) => {
    try {
        const userData = req.body;
        const result = await User.UpdateLoginAttempts(userData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const GetProductInventory = async (req, res) => {
    try {
        const result = await User.GetProductInventory();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


const ingredientInventory = async (req, res) => {
    try {
        const result = await User.ingredientInventory();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


const dailyOrderDetails = async (req, res) => {
    try {
        const result = await User.dailyOrderDetails();
        res.status(200).json(result);
        console.log("Request Body:", req.body);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


const topSellingProducts = async (req, res) => {
    try {
        const result = await User.topSellingProducts();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const getMenu = async (req, res) => {
    try {
        const result = await User.getMenu();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addemployee = async (req, res) => {
    try {
        const employeeData = req.body;
        const result = await User.addemployee(employeeData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


const addmenuitem = async (req, res) => {
    try {
        const menuData = req.body;
        const result = await User.addmenuitem(menuData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const removeMenuItem = async (req, res) => {
    try {
        const { ProductID } = req.params;
        const result = await User.removeMenuItem(ProductID);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


const addtable = async (req, res) => {
    try {
        const { Capacity, IsAvailable } = req.body;
        const result = await User.addtable(Capacity, IsAvailable);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


const removeTable = async (req, res) => {
    try {
        const { TableID } = req.params;
        const result = await User.removeTable(TableID);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const updateTableCapacity = async (req, res) => {
    try {
        const { TableID, NewCapacity } = req.body;
        const result = await User.updateTableCapacity(TableID, NewCapacity);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addMoneyToWallet = async (req, res) => {
    try {
        const { CustomerID, Amount } = req.body;
        const result = await User.addMoneyToWallet(CustomerID, Amount);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const updateEmployeeRole = async (req, res) => {
    try {
        const employeeData = req.body;
        const result = await User.updateEmployeeRole(employeeData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const deductMoneyToWallet = async (req, res) => {
    try {

        const { customerId, amount } = req.body;
 
        const result = await User.deductMoneyToWallet(customerId, amount);

        res.status(201).json(result); 
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const checkIfTableAvailable = async (req, res) => {
    try {
        const result = await User.checkIfTableAvailable();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Server error', details: error.message });
    }
};
const viewActiveOrders = async (req, res) => {
    try {
        const result = await User.viewActiveOrders();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const addingredient = async (req, res) => {
    try {
        const ingredientData = req.body;
        const result = await User.addingredient(ingredientData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const getAllEmployees = async (req, res) => {
    try {
       
        const result = await User.getAllEmployees();
        res.status(200).json(result);
    } catch (error) {
        console.error('Controller Error:', error);
        res.status(500).json({
            error: 'Internal server error',
            details: error.message
        });
    }
};

const removeEmployee= async (req, res) =>{
    const { id } = req.params;
  
    try {
      await  User.removeEmployeeByID(id);
      res.status(200).json({ message: 'Employee removed successfully' });
    } catch (err) {
      console.error('Error removing employee:', err);
      res.status(500).json({ message: 'Failed to remove employee' });
    }
  };

  const getOrdersByDateRange = async (req, res) => {
    try {
        const { startDate, endDate } = req.query;
        
        if (!startDate || !endDate) {
            return res.status(400).json({ 
                error: 'Both startDate and endDate parameters are required' 
            });
        }

        const orders = await User.getOrdersByDateRange(startDate, endDate);
        res.status(200).json(orders);
    } catch (error) {
        console.error('Error fetching orders:', error);
        res.status(500).json({ 
            error: 'Failed to fetch orders',
            details: error.message 
        });
    }
};

const getSalesReport = async (req, res) => {
    try {
        const { startDate, endDate } = req.query;
        
        if (!startDate || !endDate) {
            return res.status(400).json({ 
                error: 'Both startDate and endDate parameters are required' 
            });
        }

        const report = await User.getSalesReport(startDate, endDate);
        res.status(200).json(report);
    } catch (error) {
        console.error('Error fetching sales report:', error);
        res.status(500).json({ 
            error: 'Failed to fetch sales report',
            details: error.message 
        });
    }
};
const generateMonthlyReport = async (req, res) => {
    try {
        const { year, month, electricityBill, maintenanceBill, salariesPaid } = req.body;
        
        if (!year || !month) {
            return res.status(400).json({ 
                error: 'Year and month are required' 
            });
        }

        const reportData = await  User.getMonthlyReport(year, month);
        
     
        const totalExpenses = Number(reportData.ingredientCost) + 
                             Number(salariesPaid || 0) + 
                             Number(electricityBill || 0) + 
                             Number(maintenanceBill || 0);
        
        const netProfit = Number(reportData.totalSales) - totalExpenses;
        
        res.status(200).json({
            ...reportData,
            electricityBill: electricityBill || 0,
            maintenanceBill: maintenanceBill || 0,
            salariesPaid: salariesPaid || 0, 
            totalExpenses: totalExpenses,
            netProfit: netProfit
        });
    } catch (error) {
        console.error('Error generating financial report:', error);
        res.status(500).json({ 
            error: 'Failed to generate financial report',
            details: error.message 
        });
    }
};

const getAllVendors = async (req, res) => {
    try {
        const vendors = await User.getAllVendors();
        res.status(200).json(vendors);
    } catch (error) {
        console.error('Error fetching vendors:', error);
        res.status(500).json({ error: 'Failed to fetch vendors' });
    }
};

const addVendor = async (req, res) => {
    try {
        const vendorData = req.body;
        
        
        if (!vendorData.FName || !vendorData.LName || !vendorData.CNIC || 
            !vendorData.Address || !vendorData.PhoneNo || !vendorData.Email) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        const newVendor = await User.addVendor(vendorData);
        res.status(201).json({ 
            message: 'Vendor added successfully',
            vendor: newVendor 
        });
    } catch (error) {
        console.error('Error adding vendor:', error);
        res.status(500).json({ error: 'Failed to add vendor' });
    }
};

const removeVendor = async (req, res) => {
    try {
        const { vendorId } = req.params;
        
        if (!vendorId) {
            return res.status(400).json({ error: 'Vendor ID is required' });
        }

        await User.removeVendor(vendorId);
        res.status(200).json({ message: 'Vendor removed successfully' });
    } catch (error) {
        console.error('Error removing vendor:', error);
        res.status(500).json({ error: 'Failed to remove vendor' });
    }
};

module.exports = {
    getAllIngredientNames,
    updateIngredients,
    placeorder,
    feedback,
    addorderitem,
    UpdateOrderStatus,
    generateInvoice,
    reserveTable,
    addWalletTransaction,
    getCustomerOrderHistory,
    addIngredientSupply,
    DailySalesReport,
    addproduct,
    updatesalary,
    vendoringredients,
    UpdateLoginAttempts,
    GetProductInventory,
    ingredientInventory,
    dailyOrderDetails,
    topSellingProducts,
    getMenu,
    addemployee,
    addmenuitem,
    removeMenuItem,
    addtable,
    removeTable,
    updateTableCapacity,
    addMoneyToWallet,
    deductMoneyToWallet,
    updateEmployeeRole,
    checkIfTableAvailable,
    viewActiveOrders,
    addingredient,
    getAllEmployees,
    removeEmployee,
    getOrdersByDateRange,
    getSalesReport,
    generateMonthlyReport,
    getAllVendors,
    addVendor,
    removeVendor
};
