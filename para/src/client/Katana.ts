import {
    createPublicClient,
    http,
    parseUnits,
    BaseError, ContractFunctionRevertedError
} from "viem";
import ParaWeb from "@getpara/react-sdk";

import {
    createParaAccount,
    createParaViemClient,
} from "@getpara/viem-v2-integration";
import para from "./Para";
import { getContractAddress } from "../utils/addresses"
import { katana } from "./Chains";

interface ITransaction {
    to: string,
    amount: string
}

const clientId = import.meta.env.VITE_CLIENT

const transport = http(`https://747474.rpc.thirdweb.com/${clientId}`); // https://rpc.katana.network

import AUSD_ABI from '../abis/tokens/IAUSD.json'

export async function initialize(para: ParaWeb) {
    try {
        const paraAccount = createParaAccount(para);

        const paraViemClient = createParaViemClient(para, {
            account: paraAccount,
            chain: katana,
            transport: transport,
        });

        if (!paraViemClient) {
            throw new Error("Failed to initialize paraAccount");
        }

        // const signerAddress = paraAccount.address;

        const publicClient = createPublicClient({
            chain: katana,
            transport: transport,
        });

        const block = await publicClient.getBlockNumber()
        console.log(block, 'last block katana')
    } catch (error) {
        console.error("Error initializing Safe:", error);
    }
}

export const madeTransaction = async ({ to, amount }: ITransaction) => {
    const ausdAddress = getContractAddress('AUSD', katana.id);

    if (!ausdAddress) {
        console.log('no')
        return;
    }
    try {

        const paraAccount = createParaAccount(para);

        const paraViemClient = createParaViemClient(para, {
            account: paraAccount,
            chain: katana,
            transport: transport,
        });

        if (!paraViemClient) {
            throw new Error("Failed to initialize paraAccount");
        }

        const signerAddress = paraAccount.address;

        const publicClient = createPublicClient({
            chain: katana,
            transport: transport,
        });

        const name = await safeContractCall(
            () => publicClient.readContract({
                address: ausdAddress,
                abi: AUSD_ABI,
                functionName: 'name'
            }),
            (error) => console.error('Error reading AUSD name:', error)
        );

        console.log(name)
        try {
            const { request } = await publicClient.simulateContract({
                address: ausdAddress,
                abi: AUSD_ABI,
                functionName: "transfer",
                args: [
                    to as `0x${string}`,
                    parseUnits(amount, 6)
                ],
                account: signerAddress
            });
            const hash = await safeContractCall(
                () => paraViemClient.writeContract(
                    request
                ),
                (error) => console.error('Failed to made the transaction', error)
            )
            console.log('hash', hash)
            return { success: hash }
        } catch (error) {
            if (error instanceof BaseError) {
                const revertError = error.walk(err => err instanceof ContractFunctionRevertedError)
                if (revertError instanceof ContractFunctionRevertedError) {
                    return { error: 'Reverted, add funds. Token AUSD' }
                }
            }
        }

    } catch (error) {
        console.log(error)
    }
}

async function safeContractCall<T>(
    callback: () => Promise<T>,
    errorHandler: (error: unknown) => void
): Promise<T | null> {
    try {
        return await callback();
    } catch (error) {
        errorHandler(error);
        return null;
    }
}
