"use client";

import { WagmiProvider, createConfig, http } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ConnectKitProvider, getDefaultConfig } from "connectkit";

const tataraTestnet = {
  id: 129399,
  name: 'Tatara Testnet',
  nativeCurrency: {
    decimals: 18,
    name: 'ETH',
    symbol: 'ETH',
  },
  rpcUrls: {
    default: { http: ['https://rpc.tatara.katanarpc.com'] },
  },
  blockExplorers: {
    default: { name: 'Tatara Explorer', url: 'https://explorer.tatara.katanarpc.com' },
  },
} as const;

const config = createConfig(
  getDefaultConfig({
    chains: [tataraTestnet],
    transports: {
      [tataraTestnet.id]: http('https://rpc.tatara.katanarpc.com'),
    },

    walletConnectProjectId: process.env.REACT_APP_WALLETCONNECT_PROJECT_ID || '',

    appName: "YvAUSD Vault",

    appDescription: "Yearn AUSD Vault Interface",
    appUrl: "https://localhost:3000",
    appIcon: "https://yearn.fi/favicon.ico",
  })
);

const queryClient = new QueryClient();

export const Web3Provider = ({ children }: { children: React.ReactNode }) => {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <ConnectKitProvider>{children}</ConnectKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
};