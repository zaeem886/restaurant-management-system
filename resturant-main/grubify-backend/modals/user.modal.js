const { sql, poolPromise } = require("../db.js");
const crypto = require("crypto");
const User = {
   
  
    async  loginAdmin(adminData) {
        try {
            const pool = await poolPromise;
    
          console.log("User Data:", adminData);
            const passwordBuffer = Buffer.from(adminData.PasswordHash, "utf8");
    
            const result = await pool.request()
    .input("Email", sql.VarChar, adminData.Email)
    .input("PasswordHash", sql.VarBinary, passwordBuffer) 
    .output("LoginSuccess", sql.Int) // <== change here!
    .execute("sp_AuthenticateAdmin");

    
               
            const isAuthenticated = result.output.LoginSuccess;
            console.log("admin authenticated successfully:", isAuthenticated);
            if (isAuthenticated>0) {
                console.log("admin authenticated successfully:", isAuthenticated);
                return { message:isAuthenticated  };// isAuthenticated is customer id 
            } else {
                return { message: "Invalid Email or Password" };
            }
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("admin login failed");
        }
    },
    async  loginUser(userData) {
        try {
            const pool = await poolPromise;
    
          console.log("User Data:", userData);
            const passwordBuffer = Buffer.from(userData.PasswordHash, "utf8");
    
            const result = await pool.request()
    .input("Email", sql.VarChar, userData.Email)
    .input("PasswordHash", sql.VarBinary, passwordBuffer) 
    .output("LoginSuccess", sql.Int) // <== change here!
    .execute("sp_AuthenticateUser");

    
               
            const isAuthenticated = result.output.LoginSuccess;
            console.log("User authenticated successfully:", isAuthenticated);
            if (isAuthenticated>0) {
                console.log("User authenticated successfully:", isAuthenticated);
                return { message:isAuthenticated  };// isAuthenticated is customer id 
            } else {
                return { message: "Invalid Email or Password" };
            }
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("User login failed");
        }
    }
};

module.exports = User;
