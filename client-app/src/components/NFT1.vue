<script setup>
import { ref } from 'vue'
import { ethers } from 'ethers'
import { NFT1ContractInfo } from '../contractInfo/NFT1'

defineProps({
  msg: String
})

const addressVal = ref('')
const urlVal = ref('')

const userAddress = ref('')

async function connect() {
  const { ethereum } = window
  if (!ethereum) {
    alert('please install metamask wallet.')
    return
  }
  console.log(ethereum)
  console.log('connect the wallet....')

  // MetaMask requires requesting permission to connect users accounts
  const [account] = await getProvider().send("eth_requestAccounts", []);

  userAddress.value = account
}

function getProvider() {
  // A Web3Provider wraps a standard Web3 provider, which is
  // what MetaMask injects as window.ethereum into each page
  return new ethers.providers.Web3Provider(ethereum)
}

function getNFT1Contract() {
  // The MetaMask plugin also allows signing transactions to
  // send ether and pay to change state within the blockchain.
  // For this, you need the account signer...
  const signer = getProvider().getSigner()
  const contract = new ethers.Contract(NFT1ContractInfo.address, NFT1ContractInfo.abi, signer)
  return contract
}

async function mintNFT1() {
  console.log('mint nft')
  const contract = getNFT1Contract()
  const address = addressVal.value
  const url = urlVal.value

  if (address && url) {
    const tx = await contract.mintItem(address, url)
    const result = await tx.wait()
    console.log(tx)
    console.log(result)
  } else {
    alert('wrong input value for address&url')
  }
}
</script>

<template>
  <h1>{{ msg }}</h1>

  <div v-show="!userAddress" class="card">
    <button type="button" @click="connect">Connect Wallet</button>
  </div>
  <div v-show="userAddress">Account: {{ userAddress }}</div>
  <div v-show="userAddress" class="mint-form">
    <label for="address">Address</label><input id="address" type="text" v-model="addressVal"
      placeholder="input the address" /><br />
    <label for="nfturl">Address</label><input id="nfturl" type="text" v-model="urlVal"
      placeholder="input the image URL" /><br />
    <button type="button" @click="mintNFT1">Mint NFT</button>
  </div>
</template>

<style scoped>

</style>
