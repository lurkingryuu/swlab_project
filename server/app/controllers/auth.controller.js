const config = require("../config/auth.config");
const db = require("../models");
const Student = db.student;
const Role = db.role;
const Admin = db.admin;
const Teacher = db.teacher;

let jwt = require("jsonwebtoken");
let bcrypt = require("bcryptjs");

exports.signup = (req, res) => {
  const student = new Student({
    id: req.body.id, // Roll Number
    username: req.body.username,
    email: req.body.email,
    password: bcrypt.hashSync(req.body.password, 8),
    name: req.body.name,
    phone: req.body.phone,
    dept: req.body.dept,
  });

  student.save((err, student) => {
    if (err) {
      res.status(500).send({ message: err });
      return;
    }

    {
      Role.findOne({ name: "student" }, (err, role) => {
        if (err) {
          res.status(500).send({ message: err });
          return;
        }

        student.roles = [role._id];
        student.save((err) => {
          if (err) {
            res.status(500).send({ message: err });
            return;
          }

          res.send({ message: "Student was registered successfully!" });
        });
      });
    }
  });
};

exports.signin = (req, res) => {
  Student.findOne({
    username: req.body.username,
  })
    .populate("roles", "-__v")
    .exec((err, student) => {
      if (err) {
        res.status(500).send({ message: err });
        return;
      }

      if (!student) {
        return res.status(404).send({ message: "Student Not found." });
      }

      var passwordIsValid = bcrypt.compareSync(
        req.body.password,
        student.password
      );

      if (!passwordIsValid) {
        return res.status(401).send({ message: "Invalid Password!" });
      }

      var token = jwt.sign({ id: user.id }, config.secret, {
        expiresIn: 86400*120, // 24 hours * 120 days
      });

      var authorities = [];

      for (let i = 0; i < user.roles.length; i++) {
        authorities.push("ROLE_" + student.roles[i].name.toUpperCase());
      }

      req.session.token = token;

      res.status(200).send({
        id: student._id,
        username: student.username,
        email: student.email,
        roles: authorities,
      });
    });
};

exports.signout = async (req, res) => {
  try {
    req.session = null;
    return res.status(200).send({ message: "You've been signed out!" });
  } catch (err) {
    this.next(err);
  }
};
