const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).send("Kitchen ID is required");
  }

  try {
    const [rows] = await pool.promise().execute(
      `SELECT subscription_expiry, is_active FROM kitchen WHERE id = ?`,
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).send("Kitchen not found");
    }

    const kitchen = rows[0];
    const currentDate = new Date();
    const expiryDate = new Date(kitchen.subscription_expiry);
    let isActive;

    if (expiryDate < currentDate) {
      // Subscription is expired
      isActive = 0;
      await pool.promise().execute(
        `UPDATE kitchen SET is_active = ? WHERE id = ?`,
        [isActive, id]
      );
      return res.status(200).send({ isActive: false });
    } else {
      // Subscription is active
      return res.status(200).send({ isActive: true });
    }
  } catch (error) {
    console.error("Error checking subscription:", error);
    return res.status(500).send("Internal server error");
  }
});

module.exports = router;
