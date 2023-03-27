const mongoose = require("mongoose");

const Teacher = mongoose.model(
  "Teacher",
  new mongoose.Schema({
    id: {
      type: String,
      required: true,
      unique: true,
    },
    username: String,
    name: String,
    email: String,
    password: String,
    phone: String,
    dept: String,
    roles: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Role",
      },
    ],
    courses: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Course",
      },
    ],
  })
);

module.exports = Teacher;
