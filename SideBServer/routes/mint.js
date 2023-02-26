var express = require('express');
var router = express.Router();
const { exec } = require('shelljs');

/* POST mint listing. */
router.post('/', function(req, res, next) {
  try {
    const { address, artist, title, description, date, imageHash } = req.body;     
    const script = `flow transactions send /Users/polluterofminds/Development/Flow/sideb/transactions/mint_nft.cdc "${address}" "SideB NFTs" "${title}" "${artist}" "Description" "${date}" "${imageHash}" --network testnet --signer testnet_polluterofminds`
    exec(script, function(code, stdout, stderr) {    
      if(!stderr) {
        console.log("Code", code);
        return res.send(stdout)
      }
  
      console.log("Error: ", stderr)
      return res.status(500).send(stderr);
    });   
  } catch (error) {
    console.log(error);
    res.status(500).send("Error");
  }  
});

module.exports = router;
