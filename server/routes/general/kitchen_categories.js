const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
    const kitchenCategoriesQuery = "SELECT * FROM kitchen_category";
    pool.query(kitchenCategoriesQuery, (err, results, fields) => {
        if (err) {
            console.error("Error fetching kitchen categories:", err);
            res.status(500).send("Error fetching kitchen categories");
            return;
        }
        res.status(200).send({message: "Kitchen categories fetched successfully!", categories: results});
    });
});

module.exports = router;
