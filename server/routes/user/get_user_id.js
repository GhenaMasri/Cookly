const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { email } = req.query;

  if (!email) {
    return res.status(400).send("Email parameter is required");
  }

  const query = "SELECT id FROM user WHERE email = ?";
  pool.execute(query, [email], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("There is no user with this email");
    } else {
      const userId = results[0].id;
      res.status(200).send({ message: "User id found", userId: userId });
    }
  });
});

module.exports = router;
