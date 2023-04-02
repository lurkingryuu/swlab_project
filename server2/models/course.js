const mongoose = require("mongoose");

const Course = mongoose.model(
  "Course",
  new mongoose.Schema({
    courseid: String,
    coursename: String,
    teachers: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: "Teacher",
    }],
    students: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Student",
      },
    ],
    attendance: [
      {
        date: {
          type: Date,
          default: Date.now,
        },
        present: [
          {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Student",
          },
        ],
        absent: [
          {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Student",
          },
        ],
      },
    ],
  })
);

module.exports = Course;
