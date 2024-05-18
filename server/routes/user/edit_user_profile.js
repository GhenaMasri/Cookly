const express = require("express");
const router = express.Router();
const mysql = require("mysql2");
const pool = require("../../db");

router.put("/", async (req, res) => {
  const { id } = req.query;
  const updates = req.body;

  if (!id) {
    return res.status(400).send("Id is required");
  }

  const allowedFields = ["first_name", "last_name", "phone"];
  const fieldsToUpdate = [];

  for (const key in updates) {
    if (allowedFields.includes(key)) {
      fieldsToUpdate.push(`${key} = ${mysql.escape(updates[key])}`);
    }
  }

  if (fieldsToUpdate.length === 0) {
    return res.status(400).send("No valid fields to update");
  }

  if (updates.phone) {
    const phoneExistsQuery = `SELECT id FROM user WHERE phone = ${mysql.escape(updates.phone)} AND id != ${mysql.escape(id)}`;
    pool.query(phoneExistsQuery, (err, results) => {
      if (err) {
        console.error("Error checking if phone exists:", err);
        return res.status(500).send("Internal Server Error");
      }

      if (results.length > 0) {
        return res.status(400).send("Phone number already exist!");
      } else {
        updateUserData();
      }
    });
  } else {
    updateUserData();
  }

  function updateUserData() {
    const updateQuery = `UPDATE user SET ${fieldsToUpdate.join(", ")} WHERE id = ${mysql.escape(id)}`;
    pool.query(updateQuery, (err, results) => {
      if (err) {
        console.error("Error updating user data:", err);
        return res.status(500).send("Internal Server Error");
      }

      if (results.affectedRows === 0) {
        return res.status(404).send("User not found");
      }

      res.status(200).send("User data updated successfully");
    });
  }
});

module.exports = router;
