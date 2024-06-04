const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).send("userId parameter is required");
  }

  const query = `SELECT o.id, 
    o.total_price, 
    o.status, 
    o.kitchen_id, 
    TIME_FORMAT(o.created_at, '%H:%i') AS time,
    k.name
    FROM orders as o
    INNER JOIN kitchen k ON k.id = o.kitchen_id
    WHERE o.user_id = ?`;
    
  pool.execute(query, [userId], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("There is no orders");
    } else {
      res.status(200).send({ orders: results });
    }
  });
});

module.exports = router;
