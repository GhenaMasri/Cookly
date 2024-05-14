const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { name, contact } = req.query;

  if (!name || !contact) {
    return res.status(400).send("Name and contact parameters are required");
  }

  const nameQuery = "SELECT * FROM kitchen WHERE name = ?";
  pool.execute(nameQuery, [name], async (error, nameResults, fields) => {
    if (error) {
      console.error("Error executing name query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (nameResults.length > 0) {
      res.status(400).send("Kitchen name already exists");
      return;
    } else {
      const contactQuery = "SELECT * FROM kitchen WHERE contact = ?";
      pool.execute(contactQuery, [contact], async (error, contactResults, fields) => {
        if (error) {
          console.error("Error executing contact query:", error);
          res.status(500).send("Internal server error");
          return;
        }
        if (contactResults.length > 0) {
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
