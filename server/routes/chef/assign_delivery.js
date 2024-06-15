const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.post("/", async (req, res) => {
  const { orderId, deliveryId } = req.body;

  const query = `
    INSERT INTO delivery_orders (order_id, delivery_id) 
    VALUES (?, ?)
  `;

  pool.execute(query, [orderId, deliveryId], (error, results, fields) => {
    if (error) {
      console.error("Error inserting values:", error);
      res.status(500).send("Error inserting values");
      return;
    }
    // update assigned flag in order table
    const updateAssigned = "UPDATE orders SET assigned = 1 WHERE id = ?";
    pool.execute(updateAssigned, [orderId], (error, results, fields) => {
      if (error) {
        console.error("Error updating values:", error);
        res.status(500).send("Error updating values");
        return;
      }
      res.status(200).send("Order assigned to delivery man and assigned flag updated");
    });
  });
});

module.exports = router;
