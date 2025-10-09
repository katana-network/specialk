import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ParaProvider, Environment } from '@getpara/react-sdk'
import '@getpara/react-sdk/styles.css'
import './index.css'
import App from './App.tsx'

const api = import.meta.env.VITE_PARA_API_KEY
const queryClient = new QueryClient();

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <ParaProvider
        paraClientConfig={{
          env: Environment.BETA,
          apiKey: api,
        }}
      >
          <App />
      </ParaProvider>
    </QueryClientProvider>
  </StrictMode >,
)
