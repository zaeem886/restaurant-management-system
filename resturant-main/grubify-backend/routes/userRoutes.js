const express = require("express");
const { loginUser,loginAdmin } = require("../controller/user.controller.js"); 

const router = express.Router();

  
router.post("/login", loginUser);  
router.post("/loginadmin", loginAdmin);  

module.exports = router;
