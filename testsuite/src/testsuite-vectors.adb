--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Tiny_Tensors.Float_Matrices;
with Tiny_Tensors.Float_Vectors;

package body Testsuite.Vectors is
   use Slim_Test.Results;
   use Tiny_Tensors.Float_Vectors;

   -----------------------------
   -- Basic_Vector_Operations --
   -----------------------------

   procedure Basic_Vector_Operations (T : in out Slim_Test.Results.Result) is
      V1 : constant Vector := [1.0, 2.0, 3.0];
      V2 : constant Vector := [4.0, 5.0, 6.0];
      V3 : Vector;
      Dot_Result : Float;
   begin
      --  Test addition
      V3 := V1 + V2;
      Assert (T, V3 = [5.0, 7.0, 9.0]);

      --  Test subtraction
      V3 := V2 - V1;
      Assert (T, V3 = [3.0, 3.0, 3.0]);

      --  Test scalar multiplication
      V3 := 2.0 * V1;
      Assert (T, V3 = [2.0, 4.0, 6.0]);

      --  Test dot product
      Dot_Result := V1 * V2;
      Assert (T, Dot_Result = 32.0);

      --  Test cross product
      V3 := V1 * V2;
      Assert (T, V3 = [-3.0, 6.0, -3.0]);

      --  Test cross product using Skew symmetric matrix
      declare
         use Tiny_Tensors.Float_Matrices;
      begin
         V3 := Skew (V1) * V2;
         Assert (T, V3 = [-3.0, 6.0, -3.0]);
      end;

      --  Test magnitude
      Assert (T, Length (V1) rem 3.74166);

      --  Test Normalize
      Assert (T, Length (Normalize (V1)) rem 1.0);

      --  Test element access
      Assert (T, V1 (1) = 1.0);
      Assert (T, V1 (2) = 2.0);
      Assert (T, V1 (3) = 3.0);
   end Basic_Vector_Operations;

   -------------------------
   -- Test_Triple_Product --
   -------------------------

   procedure Test_Triple_Product (T : in out Slim_Test.Results.Result) is
      V1 : constant Vector := [1.0, 0.0, 0.0];
      V2 : constant Vector := [0.0, 1.0, 0.0];
      V3 : constant Vector := [0.0, 0.0, 1.0];
      Triple_Result : Float;
   begin
      --  Test scalar triple product: V1 · (V2 × V3)
      Triple_Result := V1 * (V2 * V3);
      Assert (T, Triple_Result = 1.0);

      --  Test with different vectors
      declare
         A : constant Vector := [2.0, 1.0, 3.0];
         B : constant Vector := [1.0, 4.0, 2.0];
         C : constant Vector := [3.0, 2.0, 1.0];
      begin
         Triple_Result := A * (B * C);  -- Should be -25.0
         Assert (T, Triple_Result rem (-25.0));
      end;

      --  Test with coplanar vectors
      declare
         A : constant Vector := [2.0, 1.0, 3.0];
         B : constant Vector := [1.0, 4.0, 2.0];
         C : constant Vector := [5.0, 6.0, 8.0];  -- 2*A + B
      begin
         Triple_Result := A * (B * C);
         Assert (T, Triple_Result rem 0.0);
         --  Should be 0 for coplanar vectors
      end;
   end Test_Triple_Product;

end Testsuite.Vectors;
