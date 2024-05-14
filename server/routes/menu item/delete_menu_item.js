const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.delete("/", async (req, res) => {
  const { menuItemId } = req.query;

  if (!menuItemId) {
    return res.status(400).send("Menu item ID parameter is required");
  }

  const query = "DELETE FROM menu_item WHERE id = ?";
  pool.execute(query, [menuItemId], async (error, results, fields) => {
    if (error) {
      console.error("Error deleting menu item:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.affectedRows === 0) {
      res.status(404).send("Menu item not found");
    } else {
      res.status(200).send("Menu item deleted successfully");
    }
  });
});

module.exports = router;
