const express = require("express");
const { 
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
    updateEmployeeRole
} = require("../controller/orders.js"); 

const router = express.Router();

router.post("/placeorder", placeorder);  
router.post("/feedback", feedback);  
router.post("/addorderitem", addorderitem);  
router.post("/updateorderstatus", UpdateOrderStatus);  
router.post("/generateinvoice", generateInvoice);
router.post("/reservetable", reserveTable);
router.post("/addwallettransaction", addWalletTransaction);
router.get("/customerorderhistory/:customerId", getCustomerOrderHistory);
router.post("/addingredientsupply", addIngredientSupply);
router.get("/DailySalesReport", DailySalesReport);
router.post("/addproduct", addproduct);
router.post("/updatesalary", updatesalary);
router.get("/vendoringredients", vendoringredients);
router.post("/updateloginattempts", UpdateLoginAttempts);
router.get("/productinventory", GetProductInventory);
router.get("/ingredientinventory", ingredientInventory);
router.get("/dailyOrderDetails", dailyOrderDetails);
router.get("/topsellingproducts", topSellingProducts);
router.get("/menu", getMenu);
router.post("/addemployee", addemployee);
router.post("/addmenuitem", addmenuitem);
router.delete("/removemenuitem/:ProductID", removeMenuItem);
router.post("/addtable", addtable);
router.delete("/removetable/:TableID", removeTable);
router.put("/updatetablecapacity", updateTableCapacity);
router.post("/addmoneytowallet", addMoneyToWallet);
router.put("/updateemployeerole", updateEmployeeRole);

module.exports = router;
