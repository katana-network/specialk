import { WagmiProvider, createConfig, http } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { injected } from "wagmi/connectors";
import { defineChain } from "viem";

const katana = defineChain({
  id: 747474,
  name: 'Katana Testnet',
  nativeCurrency: {
    decimals: 18,
    name: 'ETH',
    symbol: 'ETH',
  },
  rpcUrls: {
    default: { http: ['https://rpc.katana.network'] },
  },
  blockExplorers: {
    default: { name: 'Katana Explorer', url: 'https://katanascan.com' },
  },
});

const config = createConfig({
  chains: [katana],
  transports: {
    [katana.id]: http(),
  },
  connectors: [
    injected()
  ],
});

const queryClient = new QueryClient();

export const Web3Provider = ({ children }: { children: React.ReactNode }) => {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    </WagmiProvider>
  );
};