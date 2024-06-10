const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).send("kitchenId parameter is required");
  }

  const query = `SELECT subscription_type,
    DATE_FORMAT(subscription_expiry, '%Y-%m-%d') AS expiry_date,
    is_active
    FROM kitchen 
    WHERE id = ?`;

  pool.execute(query, [id], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("There is no kitchen with this id");
    } else {
      const sub = results[0];
      res.status(200).send({ subscription: sub });
    }
  });
});

module.exports = router;
