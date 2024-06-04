const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", async (req, res) => {
    const { orderId, totalPrice, status, userNumber, kitchenNumber, city, address, notes, pickupTime, payment, delivery} = req.body;

    console.log(orderId," ", totalPrice," ", status," ", userNumber," ", kitchenNumber," ", city," ");
    console.log(address," ", notes," ", pickupTime," ", payment," ", delivery)

    if (!orderId || !totalPrice || !status || !userNumber || !kitchenNumber || !city || !payment) {
      return res.status(400).send("All fields are required");
    }
  
    const updateOrderQuery = `
      UPDATE orders
      SET 
        total_price = ?,
        status = ?,
        user_number = ?,
        kitchen_number = ?,
        city = ?,
        address = ?,
        notes = ?,
        pickup_time = ?,
        payment = ?,
        delivery = ?
      WHERE id = ?;
    `;
  
    try {
      await pool.promise().execute(updateOrderQuery, [totalPrice, status, userNumber, kitchenNumber, city, address, notes, pickupTime, payment, delivery, orderId]);
      res.status(200).send("Order data inserted/updated successfully");
    } catch (error) {
      console.error("Error inserting/updating order data:", error);
      res.status(500).send("Internal server error");
    }
});

module.exports = router;
