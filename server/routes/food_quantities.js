const express = require("express");
const router = express.Router();
const pool = require("../db");

router.get("/", async (req, res) => {
    const foodQuantitiesQuery = "SELECT * FROM food_quantity";
    pool.query(foodQuantitiesQuery, (err, results, fields) => {
        if (err) {
            console.error("Error fetching food quantities:", err);
            res.status(500).send("Error fetching food quantities");
            return;
        }
        res.status(200).send({message: "Food quantities fetched successfully!", quantities: results});
    });
});

module.exports = router;
