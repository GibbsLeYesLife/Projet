// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lychor_Dissolve_Stealth"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Dissolve("Dissolve", Range( -10 , 10)) = 0
		_Edge_Size_1("Edge_Size_1", Float) = 0.26
		[HDR]_Emissive_Color("Emissive_Color", Color) = (2.45283,0.242969,0.242969,0)
		_Main_Noise_Tile("Main_Noise_Tile", Vector) = (1,1,0,0)
		_Tile_Second("Tile_Second", Vector) = (1,1,0,0)
		_Color_1_Power("Color_1_Power", Float) = 0
		_Main_Noise_Speed("Main_Noise_Speed", Vector) = (0,0,0,0)
		_Speed_Second("Speed_Second", Vector) = (0,0,0,0)
		_T_Lu_Noise_02("T_Lu_Noise_02", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Color_1_Power;
		uniform float4 _Emissive_Color;
		uniform sampler2D _T_Lu_Noise_02;
		uniform float2 _Main_Noise_Tile;
		uniform float2 _Main_Noise_Speed;
		uniform sampler2D _TextureSample0;
		uniform float2 _Tile_Second;
		uniform float2 _Speed_Second;
		uniform float _Dissolve;
		uniform float _Edge_Size_1;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner39 = ( 1.0 * _Time.y * _Main_Noise_Speed + float2( 0,0 ));
			float2 uv_TexCoord44 = i.uv_texcoord * _Main_Noise_Tile + panner39;
			float2 panner59 = ( 1.0 * _Time.y * _Speed_Second + float2( 0,0 ));
			float2 uv_TexCoord60 = i.uv_texcoord * _Tile_Second + panner59;
			float Noise50 = ( tex2D( _T_Lu_Noise_02, uv_TexCoord44 ).b + tex2D( _TextureSample0, uv_TexCoord60 ).b );
			float temp_output_6_0 = ( Noise50 + _Dissolve );
			float temp_output_33_0 = step( temp_output_6_0 , _Edge_Size_1 );
			float4 temp_output_14_0 = ( ( _Color_1_Power + _Emissive_Color ) * temp_output_33_0 );
			o.Emission = temp_output_14_0.rgb;
			o.Alpha = 1;
			clip( temp_output_6_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
380;638;1077;463;3059.277;335.5818;2.119029;True;False
Node;AmplifyShaderEditor.Vector2Node;37;-3809.936,-637.7574;Float;False;Property;_Main_Noise_Speed;Main_Noise_Speed;9;0;Create;True;0;0;False;0;0,0;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;57;-3954.782,-77.82302;Float;False;Property;_Speed_Second;Speed_Second;10;0;Create;True;0;0;False;0;0,0;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;58;-3632.512,-397.9544;Float;False;Property;_Tile_Second;Tile_Second;5;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;59;-3718.296,-132.0362;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;39;-3573.45,-691.9705;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;41;-3487.666,-989.3033;Float;False;Property;_Main_Noise_Tile;Main_Noise_Tile;4;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-3375.491,-320.8571;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-3230.645,-880.7914;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;-2728.07,-778.3254;Float;True;Property;_T_Lu_Noise_02;T_Lu_Noise_02;12;0;Create;True;0;0;False;0;0478464d893083343b931277de9268e0;0478464d893083343b931277de9268e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;61;-2872.916,-218.3911;Float;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;False;0;0478464d893083343b931277de9268e0;0478464d893083343b931277de9268e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-2372.413,-427.2446;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2108.13,-307.5215;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1851.16,-49.74842;Float;False;Property;_Dissolve;Dissolve;1;0;Create;True;0;0;False;0;0;0.88;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1847.296,-365.4596;Float;False;50;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1343.506,-631.0676;Float;False;Property;_Edge_Size_1;Edge_Size_1;2;0;Create;True;0;0;False;0;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-1412.802,-865.5378;Float;False;Property;_Emissive_Color;Emissive_Color;3;1;[HDR];Create;True;0;0;False;0;2.45283,0.242969,0.242969,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-1485.27,-218.8832;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1203.375,-1092.161;Float;False;Property;_Color_1_Power;Color_1_Power;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-677.6823,-945.1095;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;33;-981.4707,-633.8126;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-163.7904,135.1338;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;35;-655.2781,-292.3626;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;-419.4136,-284.6051;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-416.7243,-663.564;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-203.8025,-251.7789;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;78.58927,-226.0071;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-931.0252,-270.9848;Float;False;Property;_Edge_Size_2;Edge_Size_2;7;0;Create;True;0;0;False;0;0.33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-526.8599,23.00941;Float;False;Property;_Color_2_Power;Color_2_Power;11;0;Create;True;0;0;False;0;0.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-486.8196,247.258;Float;False;Property;_Emissive_Color_2;Emissive_Color_2;8;1;[HDR];Create;True;0;0;False;0;0.4139205,1.738,2.196078,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;503.4628,-217.7339;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Lychor_Dissolve_Stealth;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;2;57;0
WireConnection;39;2;37;0
WireConnection;60;0;58;0
WireConnection;60;1;59;0
WireConnection;44;0;41;0
WireConnection;44;1;39;0
WireConnection;46;1;44;0
WireConnection;61;1;60;0
WireConnection;62;0;46;3
WireConnection;62;1;61;3
WireConnection;50;0;62;0
WireConnection;6;0;54;0
WireConnection;6;1;3;0
WireConnection;17;0;16;0
WireConnection;17;1;12;0
WireConnection;33;0;6;0
WireConnection;33;1;9;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;35;0;33;0
WireConnection;35;1;21;0
WireConnection;36;0;35;0
WireConnection;14;0;17;0
WireConnection;14;1;33;0
WireConnection;26;0;36;0
WireConnection;26;1;30;0
WireConnection;31;0;14;0
WireConnection;31;1;26;0
WireConnection;0;2;14;0
WireConnection;0;10;6;0
ASEEND*/
//CHKSM=1101F1F5C493B266FDC7F16041E5AE57D87E5283