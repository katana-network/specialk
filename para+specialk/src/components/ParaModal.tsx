/* import { OAuthMethod, ParaModal, AuthLayout, useModal } from "@getpara/react-sdk";

interface IParaModal {
    isModalOpen: boolean;
    setIsModalOpen: (value: boolean) => void;
}

const APP_NAME = "ParaSpecialK"

export default function ParaModalCapsule({
    isModalOpen,
    setIsModalOpen,
}: IParaModal) {
    const { openModal } = useModal();
    return (
        <ParaModal
            isOpen={isModalOpen}
            onClose={() => setIsModalOpen(!isModalOpen)}
            theme={{}}
            externalWallets={
            {wallet}
            }
            oAuthMethods={
                [
                    OAuthMethod.GOOGLE,
                    OAuthMethod.FARCASTER
                ]
            }
            authLayout={[AuthLayout.AUTH_CONDENSED, AuthLayout.EXTERNAL_FULL]}
            recoverySecretStepEnabled={true}
            onRampTestMode={true}
        />
    );
} */