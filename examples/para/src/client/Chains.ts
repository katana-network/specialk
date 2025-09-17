import { defineChain } from "viem";
import {CHAIN_IDS} from '../../../../utils/mapping'

const clientId = import.meta.env.VITE_CLIENT

export const katana = defineChain({
    id: CHAIN_IDS.KATANA,
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
    id: CHAIN_IDS.TATARA,
    name: "tatara",
    nativeCurrency: { name: "Ether", symbol: "ETH", decimals: 18 },
    rpcUrls: {
        default: { http: ["https://rpc.tatara.katanarpc.com"] },
    },
    blockExplorers: {
        default: { name: "Blockscout", url: "https://explorer.tatara.katana.network" },
    },

})