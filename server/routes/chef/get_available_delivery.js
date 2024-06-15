const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).send("id parameter is required");
  }

  const cityQuery = `SELECT 
    city
    FROM kitchen
    WHERE id = ?`;

  pool.execute(cityQuery, [id], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("There is no kitchen with this id");
    } else {
      const city = results[0].city;
      const query = `SELECT 
      d.id,
      CONCAT(u.first_name, ' ', u.last_name) AS full_name,
      u.phone 
      FROM delivery d
      INNER JOIN user u ON u.id = d.user_id
      WHERE d.city = ? AND d.status = ?`;

      const status = "available";

      pool.execute(query, [city, status], async (error, results, fields) => {
        if (error) {
          console.error("Error executing query:", error);
          res.status(500).send("Internal server error");
          return;
        }
        if (results.length === 0) {
          res.status(401).send("There is no delivery men in this city");
        } else {
          res.status(200).send({ deliveryMen: results });
        }
      });
    }
  });
});

module.exports = router;
