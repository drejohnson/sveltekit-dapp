<script lang="ts">
	import { ethers } from 'ethers';
	import Greeter from '$lib/artifacts/contracts/Greeter.sol/Greeter.json';
	import Token from '$lib/artifacts/contracts/Token.sol/Token.json';
	import { onMount } from 'svelte';

	// TODO: Add correct types
	type EthWindow = Window & typeof globalThis & { ethereum: any };

	const greeterAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
	const tokenAddress = '0x5FC8d32690cc91D4c39d9d3abcBD16989F875707';

	let ethereum: any;

	let greeting = '';
	let userAccount: string;
	let amount = 0;

	onMount(() => {
		ethereum = (window as EthWindow).ethereum;
	});

	async function requestAccount() {
		await ethereum.request({ method: 'eth_requestAccounts' });
	}

	async function getBalance() {
		if (typeof ethereum !== undefined) {
			const [account] = await ethereum.request({ method: 'eth_requestAccounts' });
			const provider = new ethers.providers.Web3Provider(ethereum);
			const contract = new ethers.Contract(tokenAddress, Token.abi, provider);
			const balance = await contract.balanceOf(account);
			console.log('Balance:', balance.toString());
		}
	}

	async function sendCoins() {
		if (typeof ethereum !== undefined) {
			await requestAccount();
			const provider = new ethers.providers.Web3Provider(ethereum);
			const signer = provider.getSigner();
			const contract = new ethers.Contract(tokenAddress, Token.abi, signer);
			const transaction = await contract.transfer(userAccount, amount);
			await transaction.wait();
			console.log(`Transaction successful, ${amount} coins send to ${userAccount}`);
		}
	}

	async function fetchGreeting() {
		// check that Metamask is installed in users browser
		if (ethereum !== undefined) {
			const provider = new ethers.providers.Web3Provider(ethereum);
			const contract = new ethers.Contract(greeterAddress, Greeter.abi, provider);
			try {
				const data = await contract.greet();
				console.log('data:', data);
			} catch (error) {
				console.log('error:', error);
			}
		}
	}

	async function setGreeting() {
		if (!greeting) return;
		if (typeof ethereum !== 'undefined') {
			await requestAccount();
			const provider = new ethers.providers.Web3Provider(ethereum);
			console.log({ provider });
			const signer = provider.getSigner();
			const contract = new ethers.Contract(greeterAddress, Greeter.abi, signer);
			const transaction = await contract.setGreeting(greeting);
			await transaction.wait();
			fetchGreeting();
		}
	}
</script>

<h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>

<button on:click={fetchGreeting}>Fetch Greeting</button>
<button on:click={setGreeting}>Set Greeting</button>

<input bind:value={greeting} placeholder="Set Greeting" />

<hr />
<button on:click={getBalance}>Get Balance</button>
<button on:click={sendCoins}>Send Coins</button>

<input bind:value={userAccount} placeholder="Account ID" />
<input bind:value={amount} placeholder="Amount" />
