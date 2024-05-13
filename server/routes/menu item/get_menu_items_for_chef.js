const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.post("/", async (req, res) => {
  const { kitchenId } = req.body;

  const query = "SELECT * FROM menu_item WHERE kitchen_id = ?";
  pool.execute(query, [kitchenId], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("Invalid kitchen id");
    } else {
      res.status(200).send({ items: results });
    }
  });
});

module.exports = router;
