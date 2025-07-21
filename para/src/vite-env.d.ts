/// <reference types="vite/client" />

import { Environment } from "@getpara/web-sdk";

interface ParasEnv {
  readonly VITE_CAPSULE_ENV: Environment.BETA;
  readonly VITE_PARA_API_KEY: string;
  readonly VITE_CLIENT: string;
}

interface ImportMeta {
  readonly env: ParasEnv;
}