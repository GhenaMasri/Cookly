const express = require("express");
const router = express.Router();
const pool = require("../db");

router.post("/", async (req, res) => {
  const { chefId } = req.body;

  const query = "SELECT name FROM kitchen WHERE id = ?";
  pool.execute(query, [chefId], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("Invalid chef id");
    } else {
      const kitchenName = results[0].name;
      res.status(200).send({ message: "kitchen name found", kitchenName: kitchenName });
    }
  });
});

module.exports = router;
