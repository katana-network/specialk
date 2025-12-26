import ParaWeb, { Environment } from "@getpara/react-sdk";

const CapsuleParasApi = import.meta.env.VITE_PARA_API_KEY;

if(!CapsuleParasApi){
    throw new Error("Please set Para API for use capsule");
}

const para = new ParaWeb(Environment.BETA, CapsuleParasApi);
 
if (!para) {
  throw new Error("Failed to initialize paraViemClient");
}
export default para;