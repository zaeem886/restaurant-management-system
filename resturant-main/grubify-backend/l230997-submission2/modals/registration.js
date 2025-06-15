const { sql, poolPromise } = require("../db.js");

const register = {
    async postregister(userData) {
        try {
            
            const pool = await poolPromise;

            const result = await pool.request()
                .input("Email", sql.VarChar, userData.Email)
                .input("PasswordHash", sql.VarChar, userData.PasswordHash)
                .input("Role", sql.VarChar, userData.Role)
                .input("FName", sql.VarChar, userData.FName)
                .input("LName", sql.VarChar, userData.LName)
                .input("DOB", sql.Date, userData.DOB)
                .input("Gender", sql.VarChar, userData.Gender)
                .input("PhoneNo", sql.Char(11), userData.PhoneNo)
                .input("Address", sql.VarChar, userData.Address)
                .execute("sp_RegisterUser"); 
            
            return { message: "User registered successfully", result: result.recordset };
        } catch (error) {
            console.error("Database query failed:", error);
            throw new Error("User registration failed");
        }
    }
};

module.exports = register;
