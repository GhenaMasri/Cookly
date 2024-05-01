const express = require("express");
const router = express.Router();
const pool = require("./db");

router.post("/", (req, res) => {
  const { email, password } = req.body;

  const query = "SELECT * FROM user WHERE email = ? AND password = ?";
  pool.execute(query, [email, password], (error, results, fields) => {
    if (error) {
      console.error('Error executing query:', error);
      res.status(500).send('Internal server error');
      return;
    }
    if (results.length === 0) {
      res.status(401).send("Invalid email or password");
    } else {
      res.status(200).send("Sign in successful");
    }
  });
});

module.exports = router;
