import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import { nodePolyfills } from "vite-plugin-node-polyfills";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss(), nodePolyfills()],
  server: {
    allowedHosts: [
      '5173-manyrios-specialk-mpp53hm78zz.ws-us121.gitpod.io'
    ],
    host: true,
  }
})
