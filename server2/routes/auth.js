const express = require("express");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const Admin = require("../models/admin");
const Student = require("../models/student");
const Teacher = require("../models/teacher");

dotenv.config();

const router = express.Router();

router.post("/signup/admin", async (req, res) => {
  try {
    const { username, email, password } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const admin = new Admin({
        email: email,
        username: username,
        password: hashedPassword,
    });
    await admin.save();
    res.status(201).json({ message: "Admin created" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

router.post("/signup/student", async (req, res) => {
  try {
    const { email, password, name, dept } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const student = new Student({
        email,
        password: hashedPassword,
        name,
        dept,
    });
    await student.save();
    res.status(201).json({ message: "Student created" });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Server error",
    });
  }
});

router.post("/signup/teacher", async (req, res) => {
  try {
    const { email, password, name, dept } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const teacher = new Teacher({
        email,
        password: hashedPassword,
        name,
        dept,
    });
    await teacher.save();
    res.status(201).json({ message: "Teacher created" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

router.post("/login/admin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await Admin.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: "Invalid credentials" });
    }
    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
    res.status(200).json({ token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
