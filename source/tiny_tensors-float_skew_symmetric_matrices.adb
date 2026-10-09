--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------

with Tiny_Tensors.Float_Symmetric_Matrices;

package body Tiny_Tensors.Float_Skew_Symmetric_Matrices is

   function "**"
     (Left   : Skew_Symmetric_Matrix;
      Ignore : Just_Two) return SM.Symmetric_Matrix is
        (SM.Square (Left));

end Tiny_Tensors.Float_Skew_Symmetric_Matrices;
