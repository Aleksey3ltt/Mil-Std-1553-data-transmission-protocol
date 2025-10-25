function bits_decode = decode_signal(segment, samples_per_bit)
    % MANCHESTER CODE DECODER (G.E. Thomas version)
    % Rules:
    % Logical 0: low to high transition (-1 -> 1)
    % Logical 1: high to low transition (1 -> -1)
    
    num_bits = floor(length(segment) / samples_per_bit);
    bits_decode = zeros(1, num_bits);
    half_point = round(samples_per_bit / 2);
    
    for i = 1:num_bits
        start_idx = (i-1) * samples_per_bit + 1;
        end_idx = i * samples_per_bit;
        
        if end_idx > length(segment)
            break;
        end
        
        bit_segment = segment(start_idx:end_idx);
        
        % Analyze transition in the middle of the bit
        first_half = mean(bit_segment(1:half_point));
        second_half = mean(bit_segment(half_point+1:end));
        
        % Thomas version
        if first_half < -0.5 && second_half > 0.5
            bits_decode(i) = 0; % -1 -> 1 = logical 0
        elseif first_half > 0.5 && second_half < -0.5
            bits_decode(i) = 1; % 1 -> -1 = logical 1
        else
            % Ambiguous transition - use difference
            diff = second_half - first_half;
            if abs(diff) > 0.2
                if diff > 0
                    bits_decode(i) = 0; % Rising edge = logical 0
                    fprintf('Bit %2d: rising edge = 0 (difference: %.3f)\n', i, diff);
                else
                    bits_decode(i) = 1; % Falling edge = logical 1
                    fprintf('Bit %2d: falling edge = 1 (difference: %.3f)\n', i, diff);
                end
            else
                % If difference is insufficient, use majority vote
                ones_count = sum(bit_segment == 1);
                minus_ones_count = sum(bit_segment == -1);
                if ones_count > minus_ones_count
                    bits_decode(i) = 1;
                    fprintf('Bit %2d: majority vote = 1 (%d vs %d)\n', i, ones_count, minus_ones_count);
                else
                    bits_decode(i) = 0;
                    fprintf('Bit %2d: majority vote = 0 (%d vs %d)\n', i, ones_count, minus_ones_count);
                end
            end
        end
    end
end