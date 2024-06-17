const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", async (req, res) => {
    const { kitchenId } = req.query;
    const { status } = req.body;
  
    if (!kitchenId) {
      return res.status(400).send("kitchenId field is required");
    }
    
    try {
      const query = "UPDATE kitchen SET status = ? WHERE id = ?";
      const [result] = await pool.promise().execute(query, [status, kitchenId]);
      if (result.affectedRows === 1) {
        res.status(200).send("kitchen updated successfully");
      } else {
        res.status(404).send("kitchen not found");
      }
    } catch (error) {
      console.error("Error updating status:", error);
      res.status(500).send("Internal server error");
    }
  });
  
  module.exports = router;