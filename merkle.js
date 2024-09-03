import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";
import csv from "csv-parser";

const values = [];
fs.createReadStream('data.csv')
  .pipe(csv())
  .on('data', (row) => {
    // Convert the amount to a string if necessary
    values.push([row.address, row.amount]);
  })
  .on('end', () => {
    // Once CSV parsing is complete, create the Merkle Tree
    const tree = StandardMerkleTree.of(values, ["address", "uint256"]);
    console.log('Merkle Root:', tree.root);
    fs.writeFileSync("tree.json", JSON.stringify(tree.dump()));
  });

  const tree = StandardMerkleTree.load(JSON.parse(fs.readFileSync("tree.json", "utf8")));

// (2)
for (const [i, v] of tree.entries()) {
  if (v[0] === '0x5B38Da6a701c568545dCfcB03FcB875f56beddC4') {
    // (3)
    const proof = tree.getProof(i);
    console.log('Value:', v);
    console.log('Proof:', proof);
  }
}