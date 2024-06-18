const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { kitchenId, status } = req.query;

  if (!kitchenId || !status) {
    return res.status(400).send("kitchenId and status parameters are required");
  }

  const query = `SELECT o.id, 
    o.total_price, 
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    TIME_FORMAT(o.created_at, '%H:%i') AS time,
    o.user_number,
    o.delivery,
    o.payment,
    o.pickup_time,
    o.user_id
    FROM orders as o
    INNER JOIN user u ON u.id = o.user_id
    WHERE o.kitchen_id = ? AND o.status = ?`;
    
  pool.execute(query, [kitchenId, status], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ orders: results });
  });
});

module.exports = router;