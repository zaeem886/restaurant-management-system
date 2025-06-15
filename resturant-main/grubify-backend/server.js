const express = require("express");
const cors = require("cors");
const sql = require("mssql");
const menuData = require("./menu");
const userRoutes = require("./routes/userRoutes.js"); 
const registerRoutes = require("./routes/registrationRoutes.js"); 
const  ordersRoutes = require("./routes/ordersrouters.js"); 
const { poolPromise } = require("./db"); 
const router = express.Router();
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

app.use("/api/v1/register", registerRoutes);
app.use('/api/v1',userRoutes)
app.use('/api/v2',ordersRoutes)


  app.get("/menu/:category", async (req, res) => {
      try {
          const pool = await poolPromise;
          const category = req.params.category; 
          
          const result = await pool.request()
              .input("category", category) 
              .query("SELECT * FROM Product WHERE Category = @category");
          
          res.json(result.recordset);
      } catch (err) {
          res.status(500).send(err.message);
      }
    });


    app.post("/order", (req, res) => {
      const { customer_id, order } = req.body;
    
      if (!customer_id) {
        return res.status(400).json({ message: "Customer ID is required" });
      }
    
      if (!order || order.length === 0) {
        return res.status(400).json({ message: "Order cannot be empty" });
      }
    
      console.log("New Order Received from Customer:", customer_id);
      console.log("Order Details:", order);
    
      res.status(201).json({
        message: "Order placed successfully",
        customer_id,
        order
      });
    });
    


app.get("/", (req, res) => {
  res.send("Hi mates, welcome to grubify API");
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
