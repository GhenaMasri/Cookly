const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.post("/", async (req, res) => {
  var { name, contact } = req.body;
  
  const nameQuery = "SELECT * FROM kitchen WHERE name = ?";
  pool.execute(nameQuery, [name], async (error, results, fields) => {
    if (results.length > 0) {
      res.status(400).send("Kitchen name already exists");
      return;
    } else {
      const contactQuery = "SELECT * FROM kitchen WHERE contact = ?";
      pool.execute(contactQuery, [contact], async (error, results, fields) => {
        if (results.length > 0) {
          res.status(400).send("Contact number already exists");
          return;
        } else {
          res.status(200).send("Chef verified successfully");
        }
      });
    }
  });
});

module.exports = router;
