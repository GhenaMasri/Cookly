const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", async (req, res) => {
  const { id } = req.query;
  const { rate } = req.body;

  if (!id || !rate) {
    return res.status(400).send("All fields are required");
  }

  try {
    const [rows] = await pool.promise().query("SELECT rate, rates_num FROM kitchen WHERE id = ?", [id]);

    if (rows.length === 0) {
      return res.status(404).send("Kitchen not found");
    }

    const currentRate = rows[0].rate;
    const currentRatesNum = rows[0].rates_num;

    const newRate = currentRate + rate;
    const newRatesNum = currentRatesNum + 1;

    const query = "UPDATE kitchen SET rate = ?, rates_num = ? WHERE id = ?";
    const [result] = await pool
      .promise()
      .execute(query, [newRate, newRatesNum, id]);

    if (result.affectedRows === 1) {
      res.status(200).send("Kitchen rated successfully");
    } else {
      res.status(404).send("Rating did not complete, kitchen not found");
    }
  } catch (error) {
    console.error("Error updating kitchen rating:", error);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;
