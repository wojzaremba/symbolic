clear all
addpath(genpath('.'));
power_split_test();
test_normalization();
test_repmat();
test_multiply_expr();
test_power_expr_simple();
test_power_expr_max();
verif_mult();
verif_complex_mult();
inverse_test();
test_add_expr();
test_many_add_expr();
test_power_expr();
test_additive_hashes();
test_grammar();