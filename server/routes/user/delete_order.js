const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.delete("/", async (req, res) => {
  const { orderId } = req.query;

  if (!orderId) {
    return res.status(400).send("orderId parameter is required");
  }

  const deleteOrderItemQuery = `
    DELETE FROM order_item WHERE order_id = ?
    `;
  pool.execute(deleteOrderItemQuery, [orderId], (err, deleteOrderItemsResult) => {
    if (err) {
        console.error("Error executing query:", err.stack);
        return res.status(500).send("Error executing query");
    }
    const query = "DELETE FROM orders WHERE id = ?";
    pool.execute(query, [orderId], async (error, results, fields) => {
        if (error) {
          console.error("Error deleting order:", error);
          res.status(500).send("Internal server error");
          return;
        }
        if (results.affectedRows === 0) {
          res.status(404).send("Order not found");
        } else {
          res.status(200).send("Order deleted successfully");
        }
      });
    }
  );
});

module.exports = router;
