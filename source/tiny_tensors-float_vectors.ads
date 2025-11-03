--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

pragma Ada_2022;

with Tiny_Tensors.Float_Sqrt;

package Tiny_Tensors.Float_Vectors is
   pragma Pure;

   type Vector is array (1 .. 3) of Float;

   function Length (V : Vector) return Float;
   --  Return |V|

   function Length_2 (V : Vector) return Float;
   --  Return |V|²

   function "abs" (V : Vector) return Float renames Length;
   --  Return |V|

   function "+" (Left, Right : Vector) return Vector;
   function "-" (Left : Vector) return Vector;
   function "-" (Left, Right : Vector) return Vector;

   function "*" (Left : Float; Right : Vector) return Vector;
   --  Return scalar multiplication

   function "*" (Left, Right : Vector) return Float;
   --
   --  Return dot product. x·y = |x||y| cos(θ)

   function "*" (Left, Right : Vector) return Vector;
   --
   --  Return cross product. |xy| = Area of parallelogram bounded by x, y

   function Triple_Product (A, B, C : Vector) return Vector;
   --
   --  Return vector triple product: A × (B × C).
   --  |Triple_Product (x,y,z)| = Volume of parallelepiped formed by x,y,z

   function Triple_Product (A, B, C : Vector) return Float;
   --
   --  Return scalar triple product: A · (B × C).
   --  |Triple_Product (x,y,z)| = Volume of parallelepiped formed by x,y,z

private
   function Length_2 (V : Vector) return Float is
     (V (1)**2 + V (2)**2 + V (3)**2);

   function Length (V : Vector) return Float is
     (Tiny_Tensors.Float_Sqrt (Length_2 (V)));

   function "+" (Left, Right : Vector) return Vector is
     [for J in 1 .. 3 => Left (J) + Right (J)];

   function "-" (Left, Right : Vector) return Vector is
     [for J in 1 .. 3 => Left (J) - Right (J)];

   function "-" (Left : Vector) return Vector is
     [for J in 1 .. 3 => -Left (J)];

   function "*" (Left : Float; Right : Vector) return Vector is
     [for J in 1 .. 3 => Left * Right (J)];

   function "*" (Left, Right : Vector) return Float is
     (Left (1) * Right (1) + Left (2) * Right (2) + Left (3) * Right (3));

   function "*" (Left, Right : Vector) return Vector is
     [Left (2) * Right (3) - Left (3) * Right (2),
      Left (3) * Right (1) - Left (1) * Right (3),
      Left (1) * Right (2) - Left (2) * Right (1)];

   function Triple_Product (A, B, C : Vector) return Vector is
     (Float'(A * C) * B - Float'(A * B) * C);

   function Triple_Product (A, B, C : Vector) return Float is
     (Vector'(A * B) * C);

end Tiny_Tensors.Float_Vectors;
