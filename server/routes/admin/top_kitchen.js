const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const city = req.query.city;
  if (!city) {
    res.status(400).send("City is required");
    return;
  }

  const topKitchenQuery = `
    SELECT id, name, rate / rates_num AS kitchen_rate, logo
    FROM kitchen
    WHERE city = ?
    ORDER BY kitchen_rate DESC
    LIMIT 1
  `;

  pool.query(topKitchenQuery, [city], (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      res.status(500).send('Internal server error');
      return;
    }

    if (results.length === 0) {
      res.status(404).send('No kitchens found in the specified city');
      return;
    }

    res.status(200).send({topKitchen: results[0]});
  });
});

module.exports = router;
