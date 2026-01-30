with Tiny_Tensors.Float_Vector_Arrays;

package JCAA.Samples is

   subtype Sample_Vector is
     Tiny_Tensors.Float_Vector_Arrays.Vector_Array (1 .. 12);

   procedure Create (Accl, Mag : out Sample_Vector);
   procedure G_AK (Accl, Mag : out Sample_Vector);
   procedure G_BMM (Accl, Mag : out Sample_Vector);

end JCAA.Samples;
