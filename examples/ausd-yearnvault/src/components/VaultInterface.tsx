import React, { useState, useEffect } from 'react';
import { useAccount, useReadContract, useWriteContract, useWaitForTransactionReceipt } from 'wagmi';
import { parseUnits, formatUnits } from 'viem';
import { 
  AUSD_TOKEN_ADDRESS, 
  YVAUSD_VAULT_ADDRESS, 
  ERC20_ABI, 
  YEARN_VAULT_ABI 
} from '../contracts';

export const VaultInterface: React.FC = () => {
  const { address, isConnected } = useAccount();
  const [depositAmount, setDepositAmount] = useState('1');
  const [withdrawAmount, setWithdrawAmount] = useState('1');
  const [approveAmount, setApproveAmount] = useState('1');
  const [currentStep, setCurrentStep] = useState<'approve' | 'deposit'>('approve');

  const { writeContract, data: writeData, isPending: isWritePending } = useWriteContract();

  const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
    hash: writeData,
  });

  // Read contract data
  const { data: ausdBalance } = useReadContract({
    address: AUSD_TOKEN_ADDRESS,
    abi: ERC20_ABI,
    functionName: 'balanceOf',
    args: address ? [address] : undefined,
  });

  const { data: yvausdBalance } = useReadContract({
    address: YVAUSD_VAULT_ADDRESS,
    abi: YEARN_VAULT_ABI,
    functionName: 'balanceOf',
    args: address ? [address] : undefined,
  });

  const { data: allowance } = useReadContract({
    address: AUSD_TOKEN_ADDRESS,
    abi: ERC20_ABI,
    functionName: 'allowance',
    args: address ? [address, YVAUSD_VAULT_ADDRESS] : undefined,
  });

  const { data: totalAssets } = useReadContract({
    address: YVAUSD_VAULT_ADDRESS,
    abi: YEARN_VAULT_ABI,
    functionName: 'totalAssets',
  });

  const { data: previewDeposit } = useReadContract({
    address: YVAUSD_VAULT_ADDRESS,
    abi: YEARN_VAULT_ABI,
    functionName: 'previewDeposit',
    args: depositAmount && !isNaN(Number(depositAmount)) && Number(depositAmount) > 0 
      ? [parseUnits(depositAmount, 6)] 
      : undefined,
  });

  const { data: previewWithdraw } = useReadContract({
    address: YVAUSD_VAULT_ADDRESS,
    abi: YEARN_VAULT_ABI,
    functionName: 'previewRedeem',
    args: withdrawAmount && !isNaN(Number(withdrawAmount)) && Number(withdrawAmount) > 0 
      ? [parseUnits(withdrawAmount, 6)] 
      : undefined,
  });

  const isValidAmount = (amount: string) => {
    return amount && !isNaN(Number(amount)) && Number(amount) > 0;
  };

  const hasAllowance = allowance && depositAmount && isValidAmount(depositAmount) 
    ? Number(formatUnits(allowance, 6)) >= Number(depositAmount)
    : false;

  // Auto-switch to deposit step when approval is sufficient
  useEffect(() => {
    if (hasAllowance && currentStep === 'approve') {
      setCurrentStep('deposit');
    } else if (!hasAllowance && currentStep === 'deposit') {
      setCurrentStep('approve');
    }
  }, [hasAllowance, currentStep]);

  const handleApprove = async () => {
    if (!isValidAmount(approveAmount)) return;
    try {
      writeContract({
        address: AUSD_TOKEN_ADDRESS,
        abi: ERC20_ABI,
        functionName: 'approve',
        args: [YVAUSD_VAULT_ADDRESS, parseUnits(approveAmount, 6)],
      });
    } catch (error) {
      console.error('Approval failed:', error);
    }
  };

  const handleDeposit = async () => {
    if (!isValidAmount(depositAmount) || !address) return;
    try {
      writeContract({
        address: YVAUSD_VAULT_ADDRESS,
        abi: YEARN_VAULT_ABI,
        functionName: 'deposit',
        args: [parseUnits(depositAmount, 6), address],
      });
    } catch (error) {
      console.error('Deposit failed:', error);
    }
  };

  const handleWithdraw = async () => {
    if (!isValidAmount(withdrawAmount) || !address) return;
    try {
      writeContract({
        address: YVAUSD_VAULT_ADDRESS,
        abi: YEARN_VAULT_ABI,
        functionName: 'redeem',
        args: [parseUnits(withdrawAmount, 6), address, address],
      });
    } catch (error) {
      console.error('Withdrawal failed:', error);
    }
  };

  const getExplorerLink = (hash: string) => {
    return `https://explorer.tatara.katana.network/tx/${hash}`;
  };

  const getButtonText = () => {
    if (currentStep === 'approve') {
      if (isWritePending) return 'Approving...';
      if (hasAllowance) return 'Approved';
      return 'Approve';
    } else {
      if (isWritePending) return 'Depositing...';
      return 'Deposit';
    }
  };

  const isButtonDisabled = () => {
    if (currentStep === 'approve') {
      return !isValidAmount(approveAmount) || isWritePending || isConfirming;
    } else {
      return !isValidAmount(depositAmount) || isWritePending || isConfirming;
    }
  };

  const handleButtonClick = () => {
    if (currentStep === 'approve') {
      handleApprove();
    } else {
      handleDeposit();
    }
  };

  return (
    <div className="vault-interface">
      {!isConnected ? (
        <div className="center-card">
          <h2>YvAUSD Vault</h2>
          <p>Connect your wallet to interact with the vault</p>
        </div>
      ) : (
        <>
          {/* How It Works */}
          <div className="info-card">
            <h3>How Yield Farming Works</h3>
            <div className="process-steps">
              <div className="process-step">
                <span className="process-number">1</span>
                <div>
                  <strong>Approve</strong>
                  <p>Allow the vault to spend your AUSD tokens</p>
                </div>
              </div>
              <div className="process-step">
                <span className="process-number">2</span>
                <div>
                  <strong>Deposit</strong>
                  <p>Deposit AUSD and receive YvAUSD vault shares</p>
                </div>
              </div>
              <div className="process-step">
                <span className="process-number">3</span>
                <div>
                  <strong>Earn Yield</strong>
                  <p>Your YvAUSD grows in value as the vault generates returns</p>
                </div>
              </div>
              <div className="process-step">
                <span className="process-number">4</span>
                <div>
                  <strong>Redeem</strong>
                  <p>Withdraw your YvAUSD for AUSD plus earned yields</p>
                </div>
              </div>
            </div>
          </div>

          {/* Vault Stats */}
          <div className="stats-grid">
            <div className="stat-card">
              <h3>Your AUSD Balance</h3>
              <p className="stat-value">
                {ausdBalance ? formatUnits(ausdBalance, 6) : '0'} AUSD
              </p>
            </div>
            <div className="stat-card">
              <h3>Your YvAUSD Balance</h3>
              <p className="stat-value">
                {yvausdBalance ? formatUnits(yvausdBalance, 6) : '0'} YvAUSD
              </p>
            </div>
            <div className="stat-card">
              <h3>Vault Total Assets</h3>
              <p className="stat-value">
                {totalAssets ? formatUnits(totalAssets, 6) : '0'} AUSD
              </p>
            </div>
            <div className="stat-card">
              <h3>Current Allowance</h3>
              <p className="stat-value">
                {allowance ? formatUnits(allowance, 6) : '0'} AUSD
              </p>
            </div>
          </div>

          {/* Transaction Status */}
          {writeData && (
            <div className="transaction-status">
              {isConfirming && (
                <p className="status-pending">Transaction confirming...</p>
              )}
              {isConfirmed && (
                <div className="status-success">
                  <p>Transaction confirmed!</p>
                  <a 
                    href={getExplorerLink(writeData)} 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="explorer-link"
                  >
                    View on Explorer
                  </a>
                </div>
              )}
            </div>
          )}

          {/* Actions */}
          <div className="actions-container">
            
            {/* Approve & Deposit Combined */}
            <div className="combined-card">
              <h3>
                {currentStep === 'approve' ? 'Step 1: Approve AUSD' : 'Step 2: Deposit AUSD'}
              </h3>
              <p>
                {currentStep === 'approve' 
                  ? 'First, approve the vault to spend your AUSD tokens'
                  : 'Now deposit your AUSD to start earning yield'
                }
              </p>
              
              <div className="input-group">
                <input
                  type="number"
                  placeholder="Amount to deposit"
                  value={depositAmount}
                  onChange={(e) => {
                    setDepositAmount(e.target.value);
                    setApproveAmount(e.target.value);
                  }}
                  className="amount-input"
                  min="0"
                  step="0.000001"
                />
              </div>

              {depositAmount && previewDeposit?.toString() && isValidAmount(depositAmount) && (
                <div className="preview">
                  You'll receive: {formatUnits(previewDeposit, 6)} YvAUSD
                </div>
              )}

              <div className="single-step">
                <button 
                  onClick={handleButtonClick}
                  disabled={isButtonDisabled()}
                  className={`action-button ${hasAllowance ? 'primary' : 'primary'}`}
                >
                  {getButtonText()}
                </button>
              </div>
            </div>

            {/* Withdraw */}
            <div className="card">
              <h3>Withdraw</h3>
              <p>Redeem your YvAUSD tokens back to AUSD plus yields</p>
              
              <div className="input-group">
                <input
                  type="number"
                  placeholder="YvAUSD amount to redeem"
                  value={withdrawAmount}
                  onChange={(e) => setWithdrawAmount(e.target.value)}
                  className="amount-input"
                  min="0"
                  step="0.000001"
                />
                
                <button 
                  onClick={handleWithdraw}
                  disabled={!isValidAmount(withdrawAmount) || isWritePending || isConfirming}
                  className="action-button primary"
                >
                  {isWritePending && isValidAmount(withdrawAmount) ? 'Withdrawing...' : 'Withdraw'}
                </button>
              </div>

              {withdrawAmount && previewWithdraw?.toString() && isValidAmount(withdrawAmount) && (
                <div className="preview">
                  You'll receive: {formatUnits(previewWithdraw, 6)} AUSD
                </div>
              )}
            </div>
          </div>
        </>
      )}
    </div>
  );
};