The project is intended to familiarize with the principle of data transmission using the Mil-STD-1553 protocol.
A MIL-STD-1553 multiplex data bus system consists of a Bus Controller (BC) controlling multiple Remote Terminals (RT) 
all connected together by a data bus providing a single data path between the Bus Controller and all the associated Remote Terminals. 
There may also be one or more Bus Monitors (BM); however, Bus Monitors are specifically not allowed to take part in data transfers, 
and are only used to capture or record data for analysis, etc. In redundant bus implementations, several data buses are used to provide 
more than one data path, i.e. dual redundant data bus, tri-redundant data bus, etc. All transmissions onto the data bus are accessible 
to the BC and all connected RTs. Messages consist of one or more 16-bit words (command, data, or status). The 16 bits comprising each 
word are transmitted using Manchester code, where each bit is transmitted as a 0.5 μs high and 0.5 μs low for a logical 1 or a low-high 
sequence for a logical 0. Each word is preceded by a 3 μs sync pulse (1.5 μs low plus 1.5 μs high for data words and the opposite for command 
and status words, which cannot occur in the Manchester code) and followed by an odd parity bit. Practically each word could be considered 
as a 20-bit word: 3-bit for sync, 16-bit for payload and 1-bit for odd parity control. The words within a message are transmitted contiguously 
and there has to be a minimum of a 4 μs gap between messages. However, this inter-message gap can be, and often is, much larger than 4 μs, 
even up to 1 ms with some older Bus Controllers. Devices have to start transmitting their response to a valid command within 4–12 μs and 
are considered to not have received a command or message if no response has started within 14 μs.
https://kimdu.com/understanding-mil-std-1553-message-format/

<img width="690" height="346" alt="mil-std-1553-word-formats-img" src="https://github.com/user-attachments/assets/acf9adeb-0e03-4456-b3ce-82513127d4c3" />

Manchester-2 (G.E. Thomas version) coding is a physical coding method in which each bit of binary information (0 or 1) is represented as a signal transition at the boundary of a time interval.
<img width="699" height="290" alt="manchester" src="https://github.com/user-attachments/assets/cab629a3-6c4d-47f4-b9c2-9d5b1edb5f1f" />

The project implements the following actions:

-Input of signal parameters

-Signal generation

-Add noise (dB)

-Signal parsing

-Decoding the received signal

-Output Result

![result1](https://github.com/user-attachments/assets/9a32de4f-f1c7-45c0-9428-4e514f1309da)

<img width="1200" height="600" alt="result2" src="https://github.com/user-attachments/assets/7f9af531-920a-422f-a12c-d863ff06bcf1" />

