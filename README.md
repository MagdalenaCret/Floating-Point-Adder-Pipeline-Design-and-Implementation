# IEEE 754 Single Precision Floating-Point Pipeline Adder

## 📝 Project Overview

This project implements a floating-point adder using a pipeline architecture in VHDL, based on the IEEE 754 single precision standard. The adder supports efficient addition of two 32-bit floating-point numbers, ensuring high throughput and fixed latency. This solution is designed for applications requiring fast and precise floating-point arithmetic.

The adder performs operations on numbers represented in the IEEE 754 single precision format, which consists of:
- **1 sign bit**
- **8 exponent bits**
- **23 mantissa bits**

The pipeline stages work in parallel to reduce execution time, with a fixed latency of 4 clock cycles. The design is optimized for high throughput and scalability, making it suitable for various floating-point operations in hardware.

## IEEE 754 Single Precision Format

The IEEE 754 single precision floating-point format consists of 32 bits, structured as follows:
- **Sign bit (1 bit)**: The most significant bit (MSB).
- **Exponent (8 bits)**: The exponent is represented in biased form, with a bias of 127.
- **Mantissa (23 bits)**: The mantissa is normalized and has an implicit leading `1` (hidden bit). This gives an effective precision of 24 bits.

The format is broken down as:

| Field     | Size (bits) | Description                        |
|-----------|-------------|------------------------------------|
| **Sign**  | 1           | The sign bit (0 for positive, 1 for negative) |
| **Exponent** | 8         | The exponent with a bias of 127     |
| **Mantissa** | 23        | The fraction (with an implicit leading 1) |

### Pipeline Objectives:
- **Reduced Execution Time**: Achieved by processing stages in parallel.
- **Fixed Latency**: The adder operates with a fixed latency of 4 clock cycles.
- **Optimized Operating Frequency**: High throughput due to efficient stage operations.
- **Precision**: Full IEEE 754 single precision, ensuring correctness in floating-point operations.
- **Balanced Pipeline Stages**: Each stage of the pipeline performs a specific task to ensure optimal performance and scalability.

## Pipeline Stages

### Stage 1: Comparison (Sign, Exponent, Mantissa Extraction)
- **Latency**: 1 clock cycle
### Stage 2: Alignment (Exponent Comparison and Mantissa Shift)
- **Latency**: 1 clock cycle
### Stage 3: Mantissa Addition/Subtraction
- **Latency**: 1 clock cycle
### Stage 4: Normalization
- **Latency**: 1 clock cycle

## Resources
- VHDL Development Tools: A standard VHDL simulator such as ModelSim or Vivado can be used for simulation and testing.
- Testbench: A testbench should be created to verify the functionality of the floating-point adder by applying various input combinations and checking the output.

## 📥 Installation
Clone this repository
  ```
 git clone https://github.com/MagdalenaCret/Floating-Point-Adder-Pipeline-Design-and-Implementation
 
  ```

## 👩‍💻 Authors
👩‍🎓 Maria-Magdalena Creț

## 🙏 Acknowledgments
🏫 Technical University of Cluj-Napoca
🎓 Faculty of Automation and Computer Science

## 📄 License
This project is provided for educational purposes.  
