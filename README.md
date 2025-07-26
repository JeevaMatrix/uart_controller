# 🛰️ UART Protocol in Verilog – From Bits to Brilliance

This project is a complete UART Transmitter and Receiver system designed **from scratch in Verilog**, including:
- A baud rate generator
- FSM-based TX and RX logic
- A testbench that validates TX-to-RX loopback
- A memorable engineering journey

---

## 🔧 What is UART?

**UART (Universal Asynchronous Receiver Transmitter)** is a fundamental serial communication protocol. Unlike synchronous communication, UART uses no external clock — only:
- A fixed baud rate (e.g., 9600 bps)
- Start/stop bits for synchronization
- LSB-first data bits
- Optional parity

---

## 🚀 Why I Built This

> “I didn’t want to just simulate UART —  
> I wanted to **understand it, break it, and fix it**.  
> I wanted to **see the bits fly** — and make them land perfectly.”  

This wasn’t just a Verilog project. It was a **debugging quest**:
- Wrong data (`0xE9` instead of `0xA5`)
- Missed timing
- Delayed bit reads
- FSM misalignments

And finally... the clean waveform and **that sweet match**.

## ⚙️ Baud Generator

To send/receive at 9600 bps from a 50MHz clock:

```

Baud\_Tick = clk\_freq / baud = 50\_000\_000 / 9600 ≈ 5208

````

```verilog
parameter COUNT = 5208;
...
tick <= (count == COUNT - 1);
````

Every `tick` corresponds to 1 full bit-time. All FSM logic (TX/RX) aligns with this.

---

## 📤 UART Transmitter (`tx.v`)

**Finite State Machine (FSM)** that transmits:

1. **Start Bit (0)**
2. **8 Data Bits (LSB First)**
3. **Stop Bit (1)**

```verilog
tx <= shift_reg[bit_index];
if (bit_index == 7) state <= STOP;
```

The TX line idles HIGH and transmits bits on `tick` edges.

---

## 📥 UART Receiver (`rx.v`)

FSM that listens to the `rx` line and reconstructs bytes.
Key features:

* Immediate transition from IDLE → DATA on falling edge
* Samples 8 bits on tick edges
* Verifies stop bit
* Asserts `rx_done` when done

### ✅ Critical Fix:

Earlier versions had a `START` state that delayed sampling by 1 tick — resulting in **bit0 being missed**.
By **removing that extra state**, the receiver now samples correctly from `tick1 → bit0`.

---

## 🔬 Waveform (Captured in GTKWave)

📸 Here's a snapshot of the UART TX and RX waveforms:

![UART Waveform](/uart_waveform.png)

> The above image shows clean 1-to-1 alignment between transmitted bits and received bits — from start to stop!

You can view your own by running:

```bash
gtkwave waveform/uart_tb.vcd
```

---

## 🧪 Testbench: UART Loopback Verification

```verilog
Sending byte: 0xa5
TX Done
RX Done. Received byte: 0xa5
✅ SUCCESS: TX and RX data matched.
```

Includes:

* Manual TX triggering
* TX/RX connection via `tx_line`
* Assertions for data match

---

## 🧠 What I Learned

* Timing is everything in UART
* FSMs must align with **real-world signal flow**, not just logic
* Sometimes **deleting a state** fixes the bug, not adding more
* Waveforms are more honest than code comments 😅

---

## 🛠 Tools Used

| Tool           | Purpose                |
| -------------- | ---------------------- |
| Icarus Verilog | Simulation             |
| GTKWave        | Waveform visualization |
| VS Code        | Editor                 |
| Git & GitHub   | Source control         |

---

## 🛣️ Future Upgrades

* [ ] TX/RX FIFO Buffers
* [ ] Baud rate configurability
* [ ] Parity + framing error detection
* [ ] Oversampling-based RX (x8 or x16)
* [ ] AXI4-Lite UART IP for integration with SoC
* [ ] Real UART-to-PC Serial communication via USB/TTL

---

## 🙌 Final Words

> UART may seem small, but it **teaches everything**:
>
> * State machines
> * Signal synchronization
> * Timing alignment
> * Bit order
> * Patience

If you’re building UART — don’t just simulate it. **Debug it.**
Feel the satisfaction when it finally says:

```
✅ SUCCESS: TX and RX data matched.
```
