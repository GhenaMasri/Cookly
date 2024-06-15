const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { id, status } = req.query;

  if (!id || !status) {
    return res.status(400).send("id and status parameters are required");
  }

  const query = `SELECT 
    o.id,
    k.name AS kitchen_name,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    o.user_number,
    o.kitchen_number,
    o.address,
    o.total_price,
    o.payment,
    o.status
    FROM delivery_orders do
    INNER JOIN orders o ON do.order_id = o.id
    INNER JOIN user u ON u.id = o.user_id
    INNER JOIN kitchen k ON k.id = o.kitchen_id
    WHERE do.delivery_id = ? AND do.status = ?
  `;

  pool.execute(query, [id, status], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("There is no orders for this id");
    } else {
      res.status(200).send({ orders: results });
    }
  });
});

module.exports = router;
