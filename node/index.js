function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

global.sleep = sleep;

const {requestI2CAccess} = require("node-web-i2c");
const ADS1115 = require("@chirimen/ads1x15");

const ads1115Addr = 0x48;

async function main() {
  const i2cAccess = await requestI2CAccess();
  const port = i2cAccess.ports.get(1);
  const ads1115 = new ADS1115(port, ads1115Addr);
  await ads1115.init(true); 
  let value = ads1115.getVoltage(await ads1115.read(process.argv[2]));
  console.log(`${value}`);
}

main();
