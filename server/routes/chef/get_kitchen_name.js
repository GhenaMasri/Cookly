const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { chefId } = req.query;

  if (!chefId) {
    return res.status(400).send("ChefId parameter is required");
  }

  const query = "SELECT name FROM kitchen WHERE id = ?";
  pool.execute(query, [chefId], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("There is no kitchen with this id");
    } else {
      const kitchenName = results[0].name;
      res.status(200).send({ message: "Kitchen name found", kitchenName: kitchenName });
    }
  });
});

module.exports = router;
