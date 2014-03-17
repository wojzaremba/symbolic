Cache(1, 1);
assert(Cache.field_inv(1) == 1);

assert(mod(Cache.field_inv(5) * 5, Cache.prime) == 1);