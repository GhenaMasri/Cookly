const express = require("express");
const router = express.Router();
const mysql = require("mysql2");
const pool = require("../../db");

router.put("/", (req, res) => {
  const itemId = req.query.id;
  const updates = req.body;

  if (!itemId) {
    return res.status(400).send("Item ID is required");
  }

  const allowedFields = [
    "name",
    "image",
    "notes",
    "kitchen_id",
    "category_id",
    "quantity_id",
    "price",
    "time",
  ];
  const fieldsToUpdate = [];

  for (const key in updates) {
    if (allowedFields.includes(key)) {
      fieldsToUpdate.push(`${key} = ${mysql.escape(updates[key])}`);
    }
  }

  if (fieldsToUpdate.length === 0) {
    return res.status(400).send("No valid fields to update");
  }

  const updateQuery = `UPDATE menu_item SET ${fieldsToUpdate.join(", ")} WHERE id = ${mysql.escape(itemId)}`;

  pool.query(updateQuery, (err, results) => {
    if (err) {
      console.error("Error updating menu item:", err);
      return res.status(500).send("Internal Server Error");
    }

    if (results.affectedRows === 0) {
      return res.status(404).send("Menu item not found");
    }

    res.status(200).send("Menu item updated successfully");
  });
});

module.exports = router;