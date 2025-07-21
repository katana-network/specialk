import { defineChain } from "viem";

const clientId = import.meta.env.VITE_CLIENT

export const katana = defineChain({
    id: 747474,
    name: "katana",
    nativeCurrency: { name: "Ether", symbol: "ETH", decimals: 18 },
    rpcUrls: {
        default: { http: [`https://747474.rpc.thirdweb.com/${clientId}`] },
    },
    blockExplorers: {
        default: { name: "Blockscout", url: "https://explorer.katanarpc.com" },
    },

});

export const tatara = defineChain({
    id: 129399,
    name: "tatara",
    nativeCurrency: { name: "Ether", symbol: "ETH", decimals: 18 },
    rpcUrls: {
        default: { http: ["https://rpc.tatara.katanarpc.com"] },
    },
    blockExplorers: {
        default: { name: "Blockscout", url: "https://explorer.tatara.katana.network" },
    },

})