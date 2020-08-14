const express = require("express");
const aws = require("aws-sdk");
const bodyParser = require("body-parser");
const multer = require("multer");
const multerS3 = require("multer-s3");
const cfg = require("./variables");

const s3 = new aws.S3({
  accessKeyId: cfg.id,
  secretAccessKey: cfg.secret,
  endpoint: cfg.endpoint,
  s3ForcePathStyle: true,
  signatureVersion: "v4",
});

const app = express();
app.use(express.static("/home/node/app/"));
app.use(bodyParser.json());

const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: cfg.bucketName,
    key: function (bucketName, file, cb) {
      console.info("file", file);
      cb(null, file.originalname); // use Date.now() for unique file keys
    },
  }),
});

app.use(express.static("public"));

app.post("/upload", upload.array("upl", 1), function (req, res) {
  res.send("File uploaded to S3 Storage!");
});

app.listen(3000, function () {
  console.info("application is listening on TCP port - 3000");
  console.info("configuration", cfg);
});
