--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Test_Groups;

package Testsuite.Diagonal_Matrices is

   All_Tests : constant Slim_Test.Test_Groups.Test_Group;

private

   procedure Test_Diagonal_Matrix_Operations
     (T : in out Slim_Test.Results.Result);

   procedure Test_Inverse (T : in out Slim_Test.Results.Result);

   All_Tests : constant Slim_Test.Test_Groups.Test_Group :=
    ["Test_Diagonal_Matrix_Operations" =>
       Test_Diagonal_Matrix_Operations'Access,
     "Test_Inverse" => Test_Inverse'Access];

end Testsuite.Diagonal_Matrices;
