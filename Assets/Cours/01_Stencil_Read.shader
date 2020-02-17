Shader "Custom/01_Stencil_Read"
{
    Properties
    {
        [IntRange]_StencilRef("Stencil Reference", Range(0,255)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Zwrite Off
	    Colormask 0

		Stencil{
		Ref [_StencilRef]
		comp Always
		Pass Replace
}

		Pass{}


    }
    FallBack "Diffuse"
}
