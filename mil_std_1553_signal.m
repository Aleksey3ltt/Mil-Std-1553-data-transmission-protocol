% Signal parameters
bit_rate = 1e6; % Bit rate (1 Mbps)
samples_per_bit = 100; % Samples per bit
bit_duration = 1 / bit_rate; % Duration of one bit in seconds
pause=4e-6;
type_sync='syncC';  % Sync signal type: 'syncC' or 'syncD'
bit4_8='00011';     % Address
bit9='1';           % Transmission 1, reception 0
bit10_14='01001';   % Subaddress
bit15_19='10001';   % Data word count
bit20='1';          % Parity bit
%command = '00011101001100011'; 
word_mil_std=[bit4_8,bit9,bit10_14,bit15_19,bit20];

% Signal generation
signal = construct_signal(pause, type_sync, word_mil_std, bit_rate,samples_per_bit);
% Add noise (dB)
signal = awgn(signal, 36);

total_bits = length(signal);
total_time = total_bits * bit_duration/samples_per_bit;
t_total = linspace(0, total_time,  total_bits);

% Signal parsing
[sync, data, parity, parse_type_sync] = parse_mil_std_1553(signal, samples_per_bit);

% Decoding the received signal
bits_binary = decode_1553_command(num2str([data, parity]));

% Plotting the signal
figure('Position', [100, 100, 1200, 600]);
plot(t_total*1e6, signal, 'b-', 'LineWidth', 3);
title('MIL-STD-1553 Word Oscillogram', 'FontSize', 14);
xlabel('Time, μs', 'FontSize', 12);
ylabel('Signal Level', 'FontSize', 12);
grid on;
ylim([-1.25 1.25]);
xlim([0, total_time*1e6]);
hold on;
text(pause*1e6+3*bit_duration*0.5e6, 1.19, 'Sync Signal', 'HorizontalAlignment', 'center', 'FontSize', 8);
text(pause*1e6+3*bit_duration*0.5e6, 1.11, parse_type_sync, 'HorizontalAlignment', 'center', 'FontSize', 8);
text(pause*0.5e6, 1.19, 'Pause', 'HorizontalAlignment', 'center', 'FontSize', 8);

for i = 1:total_bits+4
    x_pos = (i-1)*bit_duration*1e6;
    plot([x_pos, x_pos], [-1.5, 1.5], 'r--', 'LineWidth', 0.5);
end

text_positions = pause*1e6+3+(0:total_bits-1)*bit_duration*1e6 + bit_duration*1e6/2;
bits = str2num(bits_binary(:));
for i = 1:length(bits)
    text_pos = text_positions(i);
    text(text_pos, 1.16, sprintf('B%d\n(%d)', i+3, bits(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 8);

end
