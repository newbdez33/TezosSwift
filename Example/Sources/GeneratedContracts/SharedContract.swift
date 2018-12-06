// Generated using TezosGen 

import TezosSwift 

struct ContractMethodInvocation {
    private let send: (_ from: Wallet, _ amount: TezToken, _ completion: @escaping RPCCompletion<String>) -> Void

    init(send: @escaping (_ from: Wallet, _ amount: TezToken, _ completion: @escaping RPCCompletion<String>) -> Void) {
        self.send = send
    }

    func send(from: Wallet, amount: TezToken, completion: @escaping RPCCompletion<String>) {
        self.send(from, amount, completion)
    }
}