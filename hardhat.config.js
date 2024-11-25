// curl 'https://eth-mainnet.g.alchemy.com/v2/tCDyCjVzPQt5eyDkBbg1FIQjLmgCmWxj/getNFTs/?owner=vitalik.eth'

require('@nomiclabs/hardhat-waffle');

module.exports = {
  solidity: '0.8.27',
  networks: {
    sapolia: {
      url: 'https://eth-mainnet.g.alchemy.com/v2/tCDyCjVzPQt5eyDkBbg1FIQjLmgCmWxj/getNFTs/?owner=vitalik.eth',
      accounts: ['6088aa17d047bb106b33b00f26a5e4019d0af93c5919d5981f41571d3a698b46']
    }
  }
}