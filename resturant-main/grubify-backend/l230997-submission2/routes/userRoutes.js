const express = require("express");
const { loginUser } = require("../controller/user.controller.js"); 

const router = express.Router();

  
router.post("/", loginUser);  


module.exports = router;
