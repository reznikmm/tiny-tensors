--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Groups;

package Testsuite.Skew_Symmetric_Matrices is

   All_Tests : aliased constant Slim_Test.Groups.Test_Group;

private

   procedure Test_Construction
     (T : in out Slim_Test.Results.Result);

   procedure Test_Arithmetic
     (T : in out Slim_Test.Results.Result);

   procedure Test_Vector_Product
     (T : in out Slim_Test.Results.Result);

   procedure Test_Matrix_Products
     (T : in out Slim_Test.Results.Result);

   procedure Test_Adjugate_And_Gramian
     (T : in out Slim_Test.Results.Result);

   procedure Test_Mixed_Operations
     (T : in out Slim_Test.Results.Result);

   procedure Test_Square
     (T : in out Slim_Test.Results.Result);

   All_Tests : aliased constant Slim_Test.Groups.Test_Group :=
    ["Construction" => Test_Construction'Access,
     "Arithmetic" => Test_Arithmetic'Access,
     "Vector_Product" => Test_Vector_Product'Access,
     "Matrix_Products" => Test_Matrix_Products'Access,
     "Adjugate_And_Gramian" => Test_Adjugate_And_Gramian'Access,
     "Mixed_Operations" => Test_Mixed_Operations'Access,
     "Square" => Test_Square'Access];

end Testsuite.Skew_Symmetric_Matrices;
