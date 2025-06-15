const { sql, poolPromise } = require("../db.js");

const User = {
   
  
    async  loginUser(userData) {
        try {
            const pool = await poolPromise;
    
            // Convert password string to VARBINARY format
            const passwordBuffer = Buffer.from(userData.PasswordHash, "utf8");
    
            const result = await pool.request()
                .input("Email", sql.VarChar, userData.Email)
                .input("PasswordHash", sql.VarBinary, passwordBuffer) 
                .output("LoginSuccess", sql.Bit)
                .execute("sp_AuthenticateUser");
    
      
            const isAuthenticated = result.output.LoginSuccess;
    
            if (isAuthenticated) {
                return { message: "User login successfully" };
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
