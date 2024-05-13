const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.post("/", async (req, res) => {
  const {
    name,
    image,
    notes,
    kitchen_id,
    category_id,
    quantity_id,
    price,
    time
  } = req.body;

  const query = `
  INSERT INTO menu_item (name, image, notes, kitchen_id, category_id, quantity_id, price, time) 
  VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;

  pool.execute(
    query,
    [name, image, notes, kitchen_id, category_id, quantity_id, price, time],
    (error, results, fields) => {
      if (error) {
        console.error("Error inserting values:", error);
        res.status(500).send("Error inserting values");
        return;
      }
      res.status(200).send("A new menu item inserted successfully!");
    }
  );
});

module.exports = router;
