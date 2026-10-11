--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Test_Groups;

package Testsuite.Skew_Symmetric_Matrices is

   All_Tests : constant Slim_Test.Test_Groups.Test_Group;

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

   All_Tests : constant Slim_Test.Test_Groups.Test_Group :=
    ["Test_Construction" => Test_Construction'Access,
     "Test_Arithmetic" => Test_Arithmetic'Access,
     "Test_Vector_Product" => Test_Vector_Product'Access,
     "Test_Matrix_Products" => Test_Matrix_Products'Access,
     "Test_Adjugate_And_Gramian" => Test_Adjugate_And_Gramian'Access,
     "Test_Mixed_Operations" => Test_Mixed_Operations'Access,
     "Test_Square" => Test_Square'Access];

end Testsuite.Skew_Symmetric_Matrices;
