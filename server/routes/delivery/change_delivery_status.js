const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", async (req, res) => {
    const { id } = req.query;
    const { status } = req.body;
  
    if (!id) {
      return res.status(400).send("id field is required");
    }
    
    try {
      const query = "UPDATE delivery SET status = ? WHERE id = ?";
      const [result] = await pool.promise().execute(query, [status, id]);
      if (result.affectedRows === 1) {
        res.status(200).send("delivery status updated successfully");
      } else {
        res.status(404).send("delivery not found");
      }
    } catch (error) {
      console.error("Error updating notification:", error);
      res.status(500).send("Internal server error");
    }
  });
  
  module.exports = router;