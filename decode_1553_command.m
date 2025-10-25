function binary_str = decode_1553_command(command_word)
    if ischar(command_word)
        if startsWith(command_word, '0x')
            command_word = hex2dec(command_word(3:end));
        elseif startsWith(command_word, '0b')
            command_word = bin2dec(command_word(3:end));
        elseif startsWith(command_word, '0')
            command_word = bin2dec(command_word(1:end));
        else
            command_word = str2double(command_word);
        end
    end
    binary_str = dec2bin(command_word,17);
    fprintf('Mil-std-1553 Word: %s\n', binary_str);
    fprintf('Decimal: %d\n', bin2dec(binary_str));
    fprintf('Hexadecimal: %s\n\n', dec2hex(bin2dec(binary_str), 5));

    % Extract MIL-STD-1553 fields
    remote_terminal_address = binary_str(1:5);
    transmit_receive = binary_str(6);
    subaddress_mode = binary_str(7:11);
    data_word_count_mode = binary_str(12:16);
    parity_bit = binary_str(17);
    
    % Convert to decimal values
    rt_addr_dec = bin2dec(remote_terminal_address);
    tx_rx_dec = bin2dec(transmit_receive);
    subaddr_dec = bin2dec(subaddress_mode);
    word_count_dec = bin2dec(data_word_count_mode);
    parity_dec = bin2dec(parity_bit);
    
    % Output field information
    fprintf('--- Command Word Structure ---\n');
    fprintf('Bits 4-8:   %s - Address (RT): %d\n', ...
            remote_terminal_address, rt_addr_dec);
    
    fprintf('Bit 9:      %s - ', transmit_receive);
    if tx_rx_dec == 0
        fprintf('Receive\n');
        command_type = 'Receive';
    else
        fprintf('Transmit\n');
        command_type = 'Transmit';
    end
    
    fprintf('Bits 10-14: %s - ', subaddress_mode);
    if subaddr_dec == 0
        fprintf('Mode Control\n');
        is_mode_code = true;
    elseif subaddr_dec == 31
        fprintf('Broadcast Mode\n');
        is_mode_code = false;
    else
        fprintf('Subaddress: %d\n', subaddr_dec);
        is_mode_code = false;
    end
    
    fprintf('Bits 15-19: %s - ', data_word_count_mode);
    if is_mode_code
        fprintf('Mode Code: %d\n', word_count_dec);
    else
        fprintf('Data Word Count: %d\n', word_count_dec);
    end
    
    fprintf('Bit 20:     %s     - Parity Bit: %d\n', parity_bit, parity_dec);
    
    % Parity check
    calculated_parity = calculate_parity(binary_str(1:16));
    fprintf('\n--- Parity Check ---\n');
    fprintf('Calculated Parity Bit: %d\n', calculated_parity);
    if calculated_parity == parity_dec
        fprintf('Check Passed\n');
    else
        fprintf('Parity Error\n');
    end
    
end