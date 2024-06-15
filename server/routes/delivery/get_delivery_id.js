const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).send("id parameter is required");
  }

  const query = "SELECT id FROM delivery WHERE user_id = ?";
  pool.execute(query, [id], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("There is no delivery information for this id");
    } else {
      const deliveryId = results[0].id;
      res.status(200).send({ delieryId: deliveryId });
    }
  });
});

module.exports = router;
