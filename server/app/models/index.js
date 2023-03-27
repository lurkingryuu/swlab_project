const mongoose = require('mongoose');
mongoose.Promise = global.Promise;

const db = {};

db.mongoose = mongoose;

db.student = require("./student.model");
db.teacher = require("./teacher.model");
db.role = require("./role.model");
db.admin = require("./admin.model");
db.course = require("./course.model");

db.ROLES = ["student", "admin", "teacher"];

module.exports = db;
