#[test_only]
module counter::count_tests {
    use std::signer;
    use std::unit_test;
    use std::vector;
    use counter::count;

    fun get_account(): signer {
        vector::pop_back(&mut unit_test::create_signers_for_testing(1))
    }

    #[test]
    public entry fun sender_can_incr() {
        let account1 = get_account();
        let addr1 = signer::address_of(&account1);
        aptos_framework::account::create_account_for_test(addr1);

        count::incr(account1);
        assert!(
            count::get_count(addr1) == 1u64, 0
        );

        let account2 = get_account();
        let addr2 = signer::address_of(&account2);
        aptos_framework::account::create_account_for_test(addr2);
        count::incr(account2);
        assert!(
            count::get_count(addr2) == 2u64, 0
        );

        let account3 = get_account();
        let addr3 = signer::address_of(&account3);
        aptos_framework::account::create_account_for_test(addr3);
        count::decr(account3);
        assert!(
            count::get_count(addr3) == 1u64, 0
        );


    }
}