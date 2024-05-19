const express = require("express");
const router = express.Router();
const mysql = require("mysql2");
const pool = require("../../db");

router.put("/", (req, res) => {
  const kitchenId = req.query.id;
  const updates = req.body;

  if (!kitchenId) {
    return res.status(400).send("Kitchen ID is required");
  }

  const allowedFields = [
    "name",
    "logo",
    "description",
    "city",
    "street",
    "contact",
    "category_id",
    "order_system",
    "special_orders",
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

  if (updates.contact) {
    const phoneExistsQuery = `SELECT id FROM kitchen WHERE contact = ${mysql.escape(updates.contact)} AND id != ${mysql.escape(kitchenId)}`;
    pool.query(phoneExistsQuery, (err, results) => {
      if (err) {
        console.error("Error checking if contact number exists:", err);
        return res.status(500).send("Internal Server Error");
      }

      if (results.length > 0) {
        return res.status(400).send("Contact number already exist!");
      } else {
        updateUserData();
      }
    });
  } else {
    updateKitchenData();
  }

  function updateKitchenData() {
    const updateQuery = `UPDATE kitchen SET ${fieldsToUpdate.join(", ")} WHERE id = ${mysql.escape(kitchenId)}`;
    pool.query(updateQuery, (err, results) => {
        if (err) {
        console.error("Error updating kitchen:", err);
        return res.status(500).send("Internal Server Error");
        }

        if (results.affectedRows === 0) {
        return res.status(404).send("Kitchen not found");
        }

        res.status(200).send("Kitchen updated successfully");
    });
  }
});

module.exports = router;