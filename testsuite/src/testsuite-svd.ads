--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Groups;

package Testsuite.SVD is

   All_Tests : aliased constant Slim_Test.Groups.Test_Group;

   --  Time tests
   procedure Simple_Matrix_SVD_1 (T : in out Slim_Test.Results.Result);

private

   procedure Identity_Matrix_SVD (T : in out Slim_Test.Results.Result);
   procedure Diagonal_Matrix_SVD (T : in out Slim_Test.Results.Result);
   procedure SVD_Reconstruction (T : in out Slim_Test.Results.Result);
   procedure Deficient_Matrix_SVD (T : in out Slim_Test.Results.Result);

   All_Tests : aliased constant Slim_Test.Groups.Test_Group :=
    ["Identity_Matrix" => Identity_Matrix_SVD'Access,
     "Diagonal_Matrix" => Diagonal_Matrix_SVD'Access,
     "SVD_Reconstruction" => SVD_Reconstruction'Access,
     "Deficient_Matrix" => Deficient_Matrix_SVD'Access];

end Testsuite.SVD;
