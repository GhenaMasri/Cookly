const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { quantityId } = req.query;

  if (!quantityId) {
    return res.status(400).send("quantity id is required");
  }

  const subFoodQuantitiesQuery = "SELECT id, sub_quantity, discount, quantity FROM sub_food_quantity WHERE quantity_id = ?";

  pool.query(subFoodQuantitiesQuery, [quantityId], (err, results, fields) => {
    if (err) {
      console.error("Error fetching sub food quantities:", err);
      res.status(500).send("Error fetching sub food quantities");
      return;
    }
    res.status(200).send({message: "Sub food quantities fetched successfully!", sub_quantities: results});
  });
});

module.exports = router;
