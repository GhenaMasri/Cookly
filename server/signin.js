const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const pool = require("./db");

router.post("/", async (req, res) => {
  const { email, password } = req.body;

  const query = "SELECT * FROM user WHERE email = ?";
  pool.execute(query, [email], async (error, results, fields) => {
    if (error) {
      console.error('Error executing query:', error);
      res.status(500).send('Internal server error');
      return;
    }
    if (results.length === 0) {
      res.status(401).send("Invalid email or password");
    } else {
      const user = results[0];
      const hashedPassword = user.password;
      const passwordMatch = await bcrypt.compare(password, hashedPassword);
      if (!passwordMatch) {
        return res.status(401).send("Invalid email or password");
      } else {
        res.status(200).send({ message: "Sign in successful", user: user });
      }
    }
  });
});

module.exports = router;
