
const express = require('express');
const router = express.Router();

const aws = require('./aws');

router.get('/', (req, res) => {
    res.render('index');
  })

const middleware = (req, res, next) => {
    
    next();
}

router.use('/api/aws', middleware, aws);

module.exports = router;