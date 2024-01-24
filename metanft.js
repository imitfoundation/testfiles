const express = require('express')
const db = require('./src/metanft.json')

const PORT = process.env.PORT || 5000

const app = express().set('port', PORT)

app.get('/', function(req, res) {
  res.send({
    "name": "Imit",
    "description": "NFTs collection for Early Investors in the Imit Project",
    "image": "https://bronze1.jpg",
    "seller_fee_basis_points": 100,
    "fee_recipient": "0x7d59D307956d24b53385c4390c6A3965B9928b37"
  });
})

app.get('/api/token/:token_id', function(req, res) {
  const tokenId = parseInt(req.params.token_id);
  const imit = db[tokenId];
  res.send({
    description: imit.description,
    image: 'https://' + imit.image,
    name: imit.name,
    attributes: imit.attributes,
  })
})

app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
})
