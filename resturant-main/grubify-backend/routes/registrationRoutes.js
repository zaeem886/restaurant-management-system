const express = require("express");
const { postregister } = require("../controller/registration.js");

const router = express.Router();

router.route("/").post(postregister);

module.exports = router;
