const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).send("id parameter is required");
  }

  const points = 0;

  const query = "UPDATE user SET points = ? WHERE id = ?";
  pool.execute(query, [points, id], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("There is no user with this id");
    } else {
      res.status(200).send("Points deleted successfully");
    }
  });
});

module.exports = router;
