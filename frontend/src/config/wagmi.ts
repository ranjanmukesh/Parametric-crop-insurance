import { createConfig, http } from '@wagmi/core'
import { sepolia } from '@wagmi/core/chains'
import { injected, walletConnect } from '@wagmi/connectors'

const projectId = ''

export const config = createConfig({
	chains: [sepolia],
	transports: {
		[sepolia.id]: 'https://rpc.sepolia.org'),
	connectors: [
		injected(),
		wallectConnect({ projectId }),
	],
})
