const http = require('http')
const express = require('express')
const routes = require('./routes/route')
const PORT = process.env.PORT || 4000;
const app = express();
const fs = require('fs')
const cors = require('cors');
const bodyParser = require('body-parser');
//const db = require('./db/connection');

const middlewares = [
    cors(),
    bodyParser.json({limit: '10mb', extended: true}),
    bodyParser.urlencoded({limit: '10mb', extended: true}),
  ]

app.use(middlewares)
app.get('/test', (req, res) => {
  console.log("TETER")
  res.status(200).send({message: 'test'});
})
app.use('/', routes);

app.listen(`${PORT}`, () => console.log(`server running at ${PORT}`))
