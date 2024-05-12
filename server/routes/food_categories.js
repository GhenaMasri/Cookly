const express = require("express");
const router = express.Router();
const pool = require("../db");

router.get("/", async (req, res) => {
    const foodCategoriesQuery = "SELECT * FROM food_category";
    pool.query(foodCategoriesQuery, (err, results, fields) => {
        if (err) {
            console.error("Error fetching food categories:", err);
            res.status(500).send("Error fetching food categories");
            return;
        }
        res.status(200).send({message: "Food categories fetched successfully!", categories: results});
    });
});

module.exports = router;
