const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { kitchenId, name } = req.query;

  if (!kitchenId) {
    return res.status(400).send("KitchenId parameter is required");
  }

  let query = `
    SELECT mi.*, fc.category as category_name
    FROM menu_item mi
    JOIN food_category fc ON mi.category_id = fc.id
    WHERE mi.kitchen_id = ?
  `;

  const queryParams = [kitchenId];

  if (name) {
    query += " AND mi.name LIKE ?";
    queryParams.push(`%${name}%`);
  }

  pool.execute(query, queryParams, async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("No menu items found for the provided kitchen id");
    } else {
      res.status(200).send({ items: results });
    }
  });
});

module.exports = router;
