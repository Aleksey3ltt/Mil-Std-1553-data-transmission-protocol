function parity = calculate_parity(data_bits)
    ones_count = sum(data_bits == '1');
    parity = mod(ones_count, 2);
end