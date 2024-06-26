const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.post("/", async (req, res) => {
  const {
    name,
    logo,
    description,
    city,
    street,
    contact,
    category_id,
    order_system,
    special_orders,
    user_id,
  } = req.body;

  const rates = 0;

  const query = `
  INSERT INTO kitchen (name, logo, description, city, street, contact, category_id, order_system, special_orders, user_id, rate, rates_num) 
  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  pool.execute(
    query,
    [name, logo, description, city, street, contact, category_id, order_system, special_orders, user_id, rates, rates],
    (error, results, fields) => {
      if (error) {
        console.error("Error inserting values:", error);
        res.status(500).send("Error inserting values");
        return;
      }
      res.status(200).send("Chef sign up successful");
    }
  );
});

module.exports = router;
