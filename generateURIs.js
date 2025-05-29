const fs = require("fs");
const path = require("path");

const SUPPLY = 333;
const OUTPUT_DIR = "./UnrevealedURIs";
const baseImageUrl = "ipfs://bafybeihupd6in77pipx2ozfw5ru6zakxms2a2ydn45bd3ut5alyjkvz3wy";

if (!fs.existsSync(OUTPUT_DIR)) {
  fs.mkdirSync(OUTPUT_DIR);
}

for (let i = 0; i < SUPPLY; i++) {
  const metadata = {
    name: "NFTs",
    description: "Random questions.",
    image: baseImageUrl,
    atributes: [
      {
        trait_type: "Revealed",
        value: "Unrevealed",
      },
    ],
  };

  fs.writeFileSync(path.join(OUTPUT_DIR, `${i}.json`), JSON.stringify(metadata, null, 2));
}

console.log("✅ Metadata generated.");
