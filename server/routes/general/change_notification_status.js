const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", async (req, res) => {
    const { notificationId } = req.query;
  
    if (!notificationId) {
      return res.status(400).send("notificationId field is required");
    }

    try {
      const query = "UPDATE \`notification\` SET is_read = 1 WHERE id = ?";
      const [result] = await pool.promise().execute(query, [notificationId]);
      if (result.affectedRows === 1) {
        res.status(200).send("Notification updated successfully");
      } else {
        res.status(404).send("Notification not found");
      }
    } catch (error) {
      console.error("Error updating notification:", error);
      res.status(500).send("Internal server error");
    }
  });
  
  module.exports = router;