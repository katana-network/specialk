
import { useAccount } from "@getpara/react-sdk";
import Navigation from './components/Navigation'
import Hero from './components/Hero'
import Transactions from './components/transaction/Transaction';
import { ToastContainer } from 'react-toastify';
import './App.css'


function App() {
  const { data: account } = useAccount();

  const isLogged = account ? account.isConnected : false;

  return (
    <div>
      <Navigation />
      <div className='flex flex-col w-full'>
        {
          isLogged ? (
            <div className="flex flex-col space-y-3">
              <h2>Send AUSD - Katana Network</h2>
              <Transactions />
            </div>
            
          ) : (
            <Hero />
          )
        }

      </div>
       <ToastContainer position="top-center" />
    </div>
  )
}

export default App
