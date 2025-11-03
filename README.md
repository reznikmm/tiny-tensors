# tiny-tensors (**WORK IN PROGRESS**)

> A Small Library for Vectors, Matrices and Linear Algebra

A lightweight, efficient library for basic linear algebra operations in Ada.
This library provides essential vector and matrix operations for 3D geometry
and linear algebra computations while prioritizing simplicity and performance.

## Features

- Simple and efficient linear algebra operations for:
  - 3D Vectors with dot and cross products
  - 3x3 Matrices with multiplication and transpose
  - Specialized matrix types (Diagonal, Orthonormal, Symmetric)
  - Vector length calculations and normalization
  - Triple products (scalar and vector)
- Pure Ada implementation with no external dependencies
- Optimized for 3D graphics and geometric computations
- Support for common mathematical operations and transformations

## Design Philosophy

This library focuses on providing essential linear algebra operations for
3D vectors and matrices in a lightweight, efficient manner. The implementation
prioritizes:

- Simplicity and ease of use for common 3D operations
- Performance through compile-time optimizations
- Pure Ada implementation without external dependencies
- Type safety with specialized matrix representations
- Clear mathematical notation and naming conventions

## Installation

Add this library to your project using Alire:

```shell
alr with tiny_tensors --use=https://github.com/reznikmm/tiny-tensors
```

## Usage

### Vectors

The library provides a 3-component vector type with common operations:

```ada
with Tiny_Tensors.Float_Vectors;

procedure Vector_Example is
   use Tiny_Tensors.Float_Vectors;
   
   V1 : constant Vector := (1.0, 0.0, 0.0);
   V2 : constant Vector := (0.0, 1.0, 0.0);
   V3 : Vector;
begin
   -- Vector arithmetic
   V3 := V1 + V2;               -- Vector addition
   V3 := V1 - V2;               -- Vector subtraction
   V3 := 2.0 * V1;              -- Scalar multiplication
   
   -- Vector products
   declare
      Dot_Product   : constant Float := V1 * V2;    -- Dot product
      Cross_Product : constant Vector := V1 * V2;   -- Cross product
      Length        : constant Float := abs V1;     -- Vector length
      Length_Sq     : constant Float := Length_2 (V1); -- Length squared
   begin
      null;
   end;
end Vector_Example;
```

### Matrices

Work with 3x3 matrices for transformations and linear algebra:

```ada
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vectors;

procedure Matrix_Example is
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Vectors;
   
   M1 : constant Matrix := 
     ((1.0, 0.0, 0.0),
      (0.0, 1.0, 0.0),
      (0.0, 0.0, 1.0));  -- Identity matrix
   
   V  : constant Vector := (1.0, 2.0, 3.0);
   Result_Vector : Vector;
   Result_Matrix : Matrix;
begin
   -- Matrix operations
   Result_Matrix := Transpose (M1);        -- Matrix transpose
   Result_Matrix := M1 + M1;               -- Matrix addition
   Result_Matrix := M1 - M1;               -- Matrix subtraction
   Result_Matrix := 2.0 * M1;              -- Scalar multiplication
   
   -- Matrix-vector multiplication
   Result_Vector := M1 * V;
end Matrix_Example;
```

### Specialized Matrix Types

The library includes specialized matrix types for specific use cases:

```ada
with Tiny_Tensors.Float_Matrices;

procedure Specialized_Matrices is
   use Tiny_Tensors.Float_Matrices;
   
   -- Diagonal matrix (represented as 3-element array)
   Diag : constant Diagonal_Matrix := (2.0, 3.0, 4.0);
   
   -- Orthonormal matrix (elements constrained to [-1, 1])
   Ortho : constant Orthonormal_Matrix := 
     ((1.0, 0.0, 0.0),
      (0.0, 1.0, 0.0),
      (0.0, 0.0, 1.0));
   
   -- Symmetric matrix (compact representation)
   Sym : constant Symmetric_Matrix := 
     (M_11 => 1.0, M_12 => 2.0, M_13 => 3.0,
      M_22 => 4.0, M_23 => 5.0,
      M_33 => 6.0);
begin
   null;
end Specialized_Matrices;
```

### Triple Products

Calculate scalar and vector triple products for volume and geometric computations:

```ada
with Tiny_Tensors.Float_Vectors;

procedure Triple_Product_Example is
   use Tiny_Tensors.Float_Vectors;
   
   A : constant Vector := (1.0, 0.0, 0.0);
   B : constant Vector := (0.0, 1.0, 0.0);
   C : constant Vector := (0.0, 0.0, 1.0);
   
   -- Scalar triple product: A · (B × C)
   Volume : constant Float := Triple_Product (A, B, C);
   
   -- Vector triple product: A × (B × C)
   Result : constant Vector := Triple_Product (A, B, C);
begin
   null;
end Triple_Product_Example;
```

## Mathematical Operations

The library supports standard mathematical operations:

- **Vector Operations**: Addition, subtraction, scalar multiplication, dot product, cross product
- **Matrix Operations**: Addition, subtraction, scalar multiplication, transpose, matrix-vector multiplication
- **Length Calculations**: Vector magnitude and squared magnitude
- **Triple Products**: Both scalar (A·(B×C)) and vector (A×(B×C)) forms
- **Specialized Types**: Diagonal, orthonormal, and symmetric matrix representations

## Performance Notes

- All operations are designed for compile-time optimization
- Pure Ada implementation ensures portability
- Specialized matrix types reduce memory usage for specific cases
- Length_2 function avoids expensive square root calculation when possible

## Maintainer

[@MaximReznik](https://github.com/reznikmm)

## Contribute

Contributions are welcome! Feel free to submit a pull request.

## License

This project is licensed under the Apache 2.0 License with LLVM Exceptions.
See the [LICENSES](LICENSES) files for details.