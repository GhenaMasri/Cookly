const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.delete("/", async (req, res) => {
  const { cartItemId } = req.query;

  if (!cartItemId) {
    return res.status(400).send("cartIitem id parameter is required");
  }

  const query = "DELETE FROM cart_item WHERE id = ?";
  pool.execute(query, [cartItemId], async (error, results, fields) => {
    if (error) {
      console.error("Error deleting cart item:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.affectedRows === 0) {
      res.status(404).send("Cart item not found");
    } else {
      res.status(200).send("Cart item deleted successfully");
    } 
  });
});

module.exports = router;
