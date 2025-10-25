function signal = construct_signal(pause_dur, sync_type, data_bits, bit_rate, samples_per_bit)
    bit_duration = 1 / bit_rate; % Duration of one bit in seconds
    
    %Pause formation
    pause_bits = pause_dur * bit_rate; % Pause duration in bits
    pause_samples = round(pause_bits * samples_per_bit);
    pause_signal = zeros(1, pause_samples);
    
    %Sync signal formation
    sync_bits = 3; % Sync signal duration in bits
    sync_samples = sync_bits * samples_per_bit;
    half_sync = sync_samples / 2;
    
    if strcmp(sync_type, 'syncC')
        sync_signal = [ones(1, half_sync), -ones(1, half_sync)];
    elseif strcmp(sync_type, 'syncD')
        sync_signal = [-ones(1, half_sync), ones(1, half_sync)];
    else
        error('Invalid sync signal type. Use syncC or syncD.');
    end
    
    %Data formation with parity bit
    %Convert bit string to numerical array
    data_vector = double(data_bits) - '0';
    
    % Check data length and add parity bit
    if length(data_vector) ~= 17
        error('Must be 16 data bits + 1 parity bit (total 17 bits)');
    end
    
    % Manchester data encoding
    manchester_signal = [];
    for bit = data_vector
        if bit == 1
            % Bit '1': +1 in first half, -1 in second half
            manchester_signal = [manchester_signal, ones(1, samples_per_bit/2), -ones(1, samples_per_bit/2)];
        else
            % Bit '0': -1 in first half, +1 in second half
            manchester_signal = [manchester_signal, -ones(1, samples_per_bit/2), ones(1, samples_per_bit/2)];
        end
    end
    
    % Combine all signal parts
    signal = [pause_signal, sync_signal, manchester_signal];
end