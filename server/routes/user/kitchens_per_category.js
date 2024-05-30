const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", (req, res) => {
  const { category_id, city, name } = req.query;

  let query = `
    SELECT 
      k.id, 
      k.name AS kitchen_name, 
      k.logo,
      kc.category AS category_name, 
      k.rates_num,
      k.order_system,
      CASE 
        WHEN k.rates_num = 0 THEN 0 
        ELSE k.rate / k.rates_num 
      END AS rate
    FROM kitchen k
    INNER JOIN kitchen_category kc ON k.category_id = kc.id
    WHERE k.category_id = ?
  `;

  const queryParams = [category_id];

  if (city) {
    query += " AND k.city = ?";
    queryParams.push(city);
  }

  if (name) {
    query += " AND k.name LIKE ?";
    queryParams.push(`%${name}%`);
  }

  pool.execute(query, queryParams, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ kitchens: results });
  });
});

module.exports = router;
