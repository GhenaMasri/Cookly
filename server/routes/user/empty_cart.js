const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.delete("/", async (req, res) => {
  const { items } = req.body;

  if (!Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: "Invalid input" });
  }

  const itemIds = items.map((item) => item.id);

  if (itemIds.length === 0) {
    return res.status(400).json({ error: "No valid IDs found" });
  }

  const placeholders = itemIds.map(() => "?").join(",");
  const query = `DELETE FROM cart_item WHERE id IN (${placeholders})`;

  pool.execute(query, itemIds, (error, results) => {
    if (error) {
      console.error("Error deleting cart items:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.affectedRows === 0) {
      res.status(404).send("Cart items not found");
    } else {
      res.status(200).send("Cart items deleted successfully");
    }
  });
});

module.exports = router;