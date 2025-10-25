function [sync, data, parity, type_sync] = parse_mil_std_1553(signal, samples_per_bit)
    % Parser for MIL-STD-1553 signal
    % signal - signal waveform
    % samples_per_bit - number of samples per bit (100)
    
    % Sync signal durations
    sync_half_duration = 1.5 * samples_per_bit; % 150 samples
    sync_duration = 3 * samples_per_bit; % 300 samples
    
    % Sync signal detection
    [sync_start, type_sync] = find_sync(signal, sync_half_duration, sync_duration);
    
    if isempty(sync_start)
        error('Sync signal not found');
    end
    
    % Extract sync signal
    sync_end = sync_start + sync_duration - 1;
    sync = signal(sync_start:sync_end);
   
 
    % Extract data bits and parity
    data_start = sync_end + 1;
    data_end = data_start + 16 * samples_per_bit - 1;
    parity_start = data_end + 1;
    parity_end = parity_start + samples_per_bit - 1;
    
    data_signal=signal(data_start:data_end);
    
    % Data decoding
    data = decode_signal(data_signal, samples_per_bit);
    
    % Parity bit decoding
    parity = decode_signal(signal(parity_start:parity_end), samples_per_bit);
end