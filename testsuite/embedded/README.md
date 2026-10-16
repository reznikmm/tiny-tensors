# Embedded tests and benchmarks

Run the tiny-tensors tests on an STM32F407 and measure selected operations in
CPU clock cycles. This project shares the test sources in `../src` with the
host testsuite.

## Build

Requirements:

- Alire and the `gnat_arm_elf` toolchain declared in `alire.toml`.
- The `light-tasking-stm32f4` Ada runtime.
- An STM32F407 board and an ST-Link probe for loading and debugging.

From the repository root, run:

```sh
alr -C testsuite/embedded build
```

The build produces `bin/embedded` (the ELF executable with debug information)
and `bin/embedded.bin` (the raw binary), relative to this directory. The
post-build action uses `arm-eabi-objcopy` to generate the binary.

The default development profile compiles the test driver with `-O1` and
contracts enabled. The `tiny_tensors` dependency uses the release profile.

## Run

Load `bin/embedded` onto the board using your debugger. The project configures
`st-util` as the GDB server at `localhost:4242`. For a manual debug session,
start `st-util`, open the ELF executable in an ARM-compatible GDB, and run:

```gdb
target remote localhost:4242
load
continue
```

Test output uses `Ada.Text_IO`; configure your debug environment to capture
the output provided by the runtime.

The program runs the benchmark group four times, then prints the execution
times and any failures or skipped tests for each run. It next runs the general
correctness tests and prints a summary. After reporting the results, it stays
in a loop with a two-second delay.

## Timing

The replacement `Slim_Test.Execution_Time` package in `src/fix` reads the
board runtime clock through `System.BB.Board_Support.Time.Read_Clock`.
`SLIM_TEST_FIX` selects this implementation. Elapsed counts use unsigned
32-bit subtraction.

The table below records the supplied STM32F407 measurements in CPU cycles.
These are elapsed times for the benchmark procedures, including their call
and result-sink overhead; no overhead subtraction is performed here. The
program prints four measurements per benchmark; the table records one supplied
value for each benchmark, without assuming an average or minimum.

| Benchmark | CPU cycles |
| :---      |      ---: |
| M x v          | 92 |
| M₁ x M₂        | 155 |
| Determinant    | 76 |
| Inverse 1      | 146 |
| Inverse 2      | 118 |
| Q x A x Qᵀ     | 224 |
| Eigen System 1 | 5267 |
| Eigen_System 2 | 1050 |
| SVD            | 6579 |
| Adjugate (M)   | 134 |
| Adjugate (M) 2 | 107 |
| Adjugate (Symmetric) | 75 |
| Determinant (Symmetric) | 79 |
| Test overhead (excluded)| 85 |

To convert cycles to seconds, divide by the CPU clock frequency in Hz.
When comparing measurements, keep the compiler, build profiles, board clock,
and memory configuration consistent.
