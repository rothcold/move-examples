module counter::count {
    use std::signer;
    use aptos_framework::event;

    //:!:>resource
    struct CounterHolder has key {
        counter: u64,
    }
    //<:!:resource

    #[event]
    struct CounterChange has drop, store {
        account: address,
        before: u64,
        after: u64,
    }

    #[view]
    public fun get_count(addr: address): u64 acquires CounterHolder {
        if (exists<CounterHolder>(addr)) {
            borrow_global<CounterHolder>(addr).counter
        }else{
            0u64
        }
    }

    public entry fun incr(account: signer) acquires CounterHolder {
        let account_addr = signer::address_of(&account);
        if (!exists<CounterHolder>(account_addr)) {
            let old_num = 0;
            let new_num = old_num + 1;
            move_to(&account, CounterHolder{
                counter: new_num
            });
            event::emit(CounterChange {
                account: account_addr,
                before: old_num,
                after: new_num
            });
        } else {
            let old_counter= borrow_global_mut<CounterHolder>(account_addr);
            let old_num = old_counter.counter;
            let new_num = old_num + 1;
            event::emit(CounterChange {
                account: account_addr,
                before: old_num,
                after: new_num
            });
            old_counter.counter = new_num;
        }
    }

    public entry fun decr(account: signer) acquires CounterHolder {
        let account_addr = signer::address_of(&account);
        if (!exists<CounterHolder>(account_addr)) {
            abort 42
        } else {
            let old_counter= borrow_global_mut<CounterHolder>(account_addr);
            let old_num = old_counter.counter;
            if (old_num > 0) {
                let new_num = old_num - 1;
                event::emit(CounterChange {
                    account: account_addr,
                    before: old_num,
                    after: new_num
                });
                old_counter.counter = new_num;
            } else {
                abort 42
            }
        }
    }

    public entry fun decr(account: signer, addr: address) acquires CounterHolder {
        if (!exists<CounterHolder>(addr)) {
            abort 42
        } else {
            let old_counter= borrow_global_mut<CounterHolder>(addr);
            let old_num = old_counter.counter;
            if (old_num > 0) {
                let new_num = old_num - 1;
                event::emit(CounterChange {
                    account: addr,
                    before: old_num,
                    after: new_num
                });
                old_counter.counter = new_num;
            } else {
                abort 42
            }
        }
    }
}
