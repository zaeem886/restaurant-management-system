const User = require("../modals/orders.js");

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
        const { customerId } = req.params;
        const result = await User.getCustomerOrderHistory({ customerId });
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
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
        const result = await User.addproduct(userData);
        res.status(201).json(result);
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

// 18. Get Top Selling Products
const topSellingProducts = async (req, res) => {
    try {
        const result = await User.topSellingProducts();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// 19. Get Menu
const getMenu = async (req, res) => {
    try {
        const result = await User.getMenu();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
// Add Employee
const addemployee = async (req, res) => {
    try {
        const employeeData = req.body;
        const result = await User.addemployee(employeeData);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Add Menu Item
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
module.exports = {
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
    updateEmployeeRole};
