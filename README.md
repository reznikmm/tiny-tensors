# tiny-tensors (**WORK IN PROGRESS**)

> A Small Library for Vectors, Matrices and Linear Algebra

A lightweight, efficient library for basic linear algebra operations in Ada.
This library provides essential vector and matrix operations for 3D geometry
and linear algebra computations while prioritizing simplicity and performance.

## Features

- Simple and efficient linear algebra operations for:
  - 3D Vectors with dot and cross products
  - 3x3 Matrices with multiplication and transpose
  - Specialized matrix types (Diagonal, Orthonormal, Symmetric, Skew-symmetric)
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

| Package | Type | Representation |
| --- | --- | --- |
| `Tiny_Tensors.Float_Matrices` | `Matrix` | 3x3 array |
| `Tiny_Tensors.Float_Diagonal_Matrices` | `Diagonal_Matrix` | Three diagonal elements |
| `Tiny_Tensors.Float_Symmetric_Matrices` | `Symmetric_Matrix` | Six independent elements |
| `Tiny_Tensors.Float_Orthonormal_Matrices` | `Orthonormal_Matrix` | 3x3 array with elements in [-1, 1] |
| `Tiny_Tensors.Float_Skew_Symmetric_Matrices` | `Skew_Symmetric_Matrix` | Three upper-triangle elements; zero diagonal and negated lower triangle |

Conversions and mixed matrix operations returning `Matrix` are in
`Float_Matrices`. Operations returning a specialized matrix are in that
type's package; for example, `Gramian`, `LT_x_L`, and `Q_A_QT` are in
`Float_Symmetric_Matrices`. Matrix-vector products are in the matrix type's
package. Package specifications use `limited with` for cross-package type
references, while bodies import the full views needed for calculations.

When migrating from the combined package, add `with` and `use` clauses for
the specialized packages you use, and update qualified type and function
names accordingly. `Symmetric_Matrix_Index`, `To_Index`, and `&` are now in
`Float_Symmetric_Matrices`; `Unit_Interval` is in `Float_Orthonormal_Matrices`.

```ada
with Tiny_Tensors.Float_Diagonal_Matrices;
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Orthonormal_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;

procedure Specialized_Matrices is
   use Tiny_Tensors.Float_Diagonal_Matrices;
   use Tiny_Tensors.Float_Matrices;
   use Tiny_Tensors.Float_Orthonormal_Matrices;
   use Tiny_Tensors.Float_Symmetric_Matrices;
   
   -- Diagonal matrix (represented as 3-element array)
   Diag : constant Diagonal_Matrix := (2.0, 3.0, 4.0);
   
   -- Orthonormal matrix (elements constrained to [-1, 1])
   Ortho : constant Orthonormal_Matrix := 
     ((1.0, 0.0, 0.0),
      (0.0, 1.0, 0.0),
      (0.0, 0.0, 1.0));
   
   -- Symmetric matrix (compact representation)
   Sym : constant Symmetric_Matrix := 
     (a_11 => 1.0, a_12 => 2.0, a_13 => 3.0,
      a_22 => 4.0, a_23 => 5.0,
      a_33 => 6.0);

   Full_Diag : constant Matrix := From_Diagonal (Diag);
   Full_Sym  : constant Matrix := From_Symmetric (Sym);
   Rotated   : constant Matrix := Ortho * Diag;
   Gram      : constant Symmetric_Matrix := Gramian (Full_Sym);
begin
   null;
end Specialized_Matrices;
```

Skew-symmetric matrices store `a_12`, `a_13`, and `a_23`. Their transpose
equals their negation, and their determinant is always zero. `Skew` builds
the matrix of a vector's cross product; `To_Vector` recovers that vector.
Use a qualified name to distinguish it from `Float_Matrices.Skew`:

```ada
with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Skew_Symmetric_Matrices;
with Tiny_Tensors.Float_Symmetric_Matrices;
with Tiny_Tensors.Float_Vectors;

procedure Skew_Example is
   package KM renames Tiny_Tensors.Float_Skew_Symmetric_Matrices;
   package SM renames Tiny_Tensors.Float_Symmetric_Matrices;
   use Tiny_Tensors.Float_Matrices;
   use type KM.Skew_Symmetric_Matrix;

   V : constant Tiny_Tensors.Float_Vectors.Vector := (1.0, 2.0, 3.0);
   K : constant KM.Skew_Symmetric_Matrix := KM.Skew (V);
   Full : constant Matrix := From_Skew_Symmetric (K);
   Product : constant Matrix := K * K;
   Adj : constant SM.Symmetric_Matrix := SM.Adjugate (K);
   Gram : constant SM.Symmetric_Matrix := SM.Gramian (K);
   Squared : constant SM.Symmetric_Matrix := SM.Square (K);
begin
   null;
end Skew_Example;
```

Skew-matrix products and mixed arithmetic with the other matrix types return
`Matrix` through `Float_Matrices`. `Adjugate`, `Gramian`, and `Square` return
`Symmetric_Matrix` through `Float_Symmetric_Matrices`. Skew-symmetric
matrices have no inverse in three dimensions.

`Square (K)` computes `K * K` directly in compact form and equals
`-Gramian (K)`. For a unit axis with `K = Skew (axis)`, Rodrigues' formula is
`Identity + sin (angle) * K + (1.0 - cos (angle)) * Square (K)`.

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
- **Specialized Types**: Diagonal, orthonormal, symmetric, and skew-symmetric matrix representations

## Performance Notes

- All operations are designed for compile-time optimization
- Pure Ada implementation ensures portability
- Specialized matrix types reduce memory usage for specific cases
- Length_2 function avoids expensive square root calculation when possible

## Maintainer

[@MaximReznik](https://github.com/reznikmm)

## Tests

Build and run the testsuite with Alire (using an Ada 2022 compiler):

```shell
alr -C testsuite run
```

The suite covers vectors, general and specialized matrix operations,
cross-package conversions and arithmetic, eigen systems, and SVD.

## Contribute

Contributions are welcome! Feel free to submit a pull request.

## License

This project is licensed under the Apache 2.0 License with LLVM Exceptions.
See the [LICENSES](LICENSES) files for details.
