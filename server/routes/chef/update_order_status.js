const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", (req, res) => {
  const { orderId } = req.query;
  const { status } = req.body;

  if (!orderId) {
    return res.status(400).send("orderId is required");
  }

  const updateQuery = "UPDATE orders SET status = ? WHERE id = ?";

  pool.query(updateQuery, [status, orderId], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).send("Internal server error");
    }
    if (result.affectedRows === 0) {
      return res.status(404).send("Order does not exist");
    }
    res.status(200).send("Order updated successfully");
  });
});

module.exports = router;
