const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const totalKitchensQuery = "SELECT COUNT(*) AS total FROM kitchen";
  const kitchensInCityQuery = "SELECT city, COUNT(*) AS count FROM kitchen GROUP BY city";

  pool.execute(totalKitchensQuery, async (err, totalResults) => {
    if (err) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    const totalKitchens = totalResults[0].total;
    pool.execute(kitchensInCityQuery, async (err, cityResults) => {
      if (err) {
        console.error("Error executing query:", error);
        res.status(500).send("Internal server error");
        return;
      }
      const cityPercentages = cityResults.map((city) => {
        const percentage = (city.count / totalKitchens) * 100;
        return {
          city: city.city,
          percentage: percentage.toFixed(2), 
        };
      });
      res.status(200).send({percentages: cityPercentages});
    });
  });
});

module.exports = router;
