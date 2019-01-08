
const aws = require('express').Router();
const awsController = require('../controllers/aws');

//const authenticate = require('./authenticate').authenticate;

//user.post('/login', userController.login);
aws.post('/analysis', awsController.analysis);
//aws.post('/addToBucket', awsController.addToBucket);
module.exports = aws;