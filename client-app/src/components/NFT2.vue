<script setup>
import { ref, reactive } from 'vue'
import { ethers } from 'ethers'
import { NFT2ContractInfo } from '../contractInfo/NFT2'

defineProps({
  msg: String
})

const addressVal = ref('')
const urlVal = ref('')

const userAddress = ref('')

const mintResult = reactive({
  id: '',
  url: ''
})

async function connect() {
  const { ethereum } = window
  if (!ethereum) {
    alert('please install metamask wallet.')
    return
  }
  console.log('Connect the wallet....')

  // MetaMask requires requesting permission to connect users accounts
  const [account] = await getProvider().send("eth_requestAccounts", []);

  userAddress.value = account
}

function getProvider() {
  // A Web3Provider wraps a standard Web3 provider, which is
  // what MetaMask injects as window.ethereum into each page
  return new ethers.providers.Web3Provider(ethereum)
}

function getNFTContract() {
  // The MetaMask plugin also allows signing transactions to
  // send ether and pay to change state within the blockchain.
  // For this, you need the account signer...
  const signer = getProvider().getSigner()
  const contract = new ethers.Contract(NFT2ContractInfo.address, NFT2ContractInfo.abi, signer)
  return contract
}

async function mintNFT() {
  console.log('Mint nft')
  const contract = getNFTContract()
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

getNFTContract().on('MintSuccessEvent', (id, owner, tokenURI) => {
  console.log('MintSuccessEvent', id.toNumber(), owner, tokenURI)
  mintResult.id = id.toNumber()
  mintResult.url = tokenURI
})
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
    <button type="button" @click="mintNFT">Mint NFT</button>
  </div>
  <div class="mint-result">
    <h3>ID: #{{mintResult.id}}</h3>
    <div><img :src="mintResult.url"/></div>
  </div>
</template>

<style scoped>

</style>
