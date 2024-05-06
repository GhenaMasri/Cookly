const express = require("express");
const router = express.Router();
const pool = require("../db");

router.get("/", async (req, res) => {
    const kitchenCategoriesQuery = "SELECT category_name FROM kitchen_category";
    pool.query(kitchenCategoriesQuery, (err, results, fields) => {
        if (err) {
            console.error("Error fetching kitchen categories:", err);
            res.status(500).send("Error fetching kitchen categories");
            return;
        }
        const categories = results.map(row => row.category_name);
        res.status(200).send({message: "Sign up successful", categories: categories});
    });
});

module.exports = router;
