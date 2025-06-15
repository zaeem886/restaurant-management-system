const register = require("../modals/registration.js");

const postregister = async (req, res) => {
    try {
        const userData = req.body; 
        const result = await register.postregister(userData);
        res.status(201).json(result); 
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = { postregister };
