// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Texture_Pan"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Machine_Rouleau_Normal("Machine_Rouleau_Normal", 2D) = "bump" {}
		_Machine_Rouleau_Roughness("Machine_Rouleau_Roughness", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Machine_Rouleau_Normal;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _Machine_Rouleau_Roughness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 appendResult126 = (float3(0.0 , -0.4 , -0.4));
			float2 uv_TexCoord123 = i.uv_texcoord * float2( 0,1 );
			float2 panner128 = ( 1.0 * _Time.y * appendResult126.xy + ( uv_TexCoord123 * 1.0 ));
			o.Normal = UnpackNormal( tex2D( _Machine_Rouleau_Normal, panner128 ) );
			o.Albedo = tex2D( _TextureSample0, panner128 ).rgb;
			o.Smoothness = tex2D( _Machine_Rouleau_Roughness, panner128 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
7;29;1754;916;1867.444;116.0399;1.397315;True;False
Node;AmplifyShaderEditor.RangedFloatNode;129;-1052.05,483.8898;Float;False;Constant;_SpeedPann;Speed Pann;2;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;123;-864.9761,152.9614;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;124;-846.4871,488.955;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-818.8311,695.3648;Float;False;Constant;_NoiseSize;Noise Size;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-556.5694,247.623;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;126;-625.858,487.2448;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;128;-301.456,384.0065;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;130;-12.50697,435.2011;Float;True;Property;_Machine_Rouleau_Normal;Machine_Rouleau_Normal;2;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;122;-49.22014,165.4858;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;131;-26.48021,661.5657;Float;True;Property;_Machine_Rouleau_Roughness;Machine_Rouleau_Roughness;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;433.2659,416.6943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Texture_Pan;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;124;0;129;0
WireConnection;127;0;123;0
WireConnection;127;1;125;0
WireConnection;126;1;124;0
WireConnection;126;2;124;0
WireConnection;128;0;127;0
WireConnection;128;2;126;0
WireConnection;130;1;128;0
WireConnection;122;1;128;0
WireConnection;131;1;128;0
WireConnection;0;0;122;0
WireConnection;0;1;130;0
WireConnection;0;4;131;0
ASEEND*/
//CHKSM=8F264B5E6F057016B3ACC727CED9AFB038626EE8