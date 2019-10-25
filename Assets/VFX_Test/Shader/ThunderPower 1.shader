// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shield_Cover"
{
	Properties
	{
		_Tiling_Noise_Secondary("Tiling_Noise_Secondary", Vector) = (0,0,0,0)
		_Tiling_Noise_1("Tiling_Noise_1", Vector) = (1,1,0,0)
		_Speed_Noise_1("Speed_Noise_1", Vector) = (3,1,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HDR]_GlowColor("Glow Color", Color) = (0.6564829,0,1.717647,0)
		_OffsetValue("OffsetValue", Float) = 0.5
		_Speed_Noise_Secondary("Speed_Noise_Secondary", Vector) = (0,0,0,0)
		_Emission("Emission", Float) = 3
		_T_Lu_Noise_01("T_Lu_Noise_01", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _T_Lu_Noise_01;
		uniform float2 _Tiling_Noise_1;
		uniform float2 _Speed_Noise_1;
		uniform sampler2D _TextureSample0;
		uniform float2 _Tiling_Noise_Secondary;
		uniform float2 _Speed_Noise_Secondary;
		uniform float _OffsetValue;
		uniform float _Emission;
		uniform float4 _GlowColor;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 panner93 = ( 1.0 * _Time.y * _Speed_Noise_1 + float2( 0,0 ));
			float2 uv_TexCoord98 = v.texcoord.xy * _Tiling_Noise_1 + panner93;
			float2 panner94 = ( 1.0 * _Time.y * _Speed_Noise_Secondary + float2( 0,0 ));
			float2 uv_TexCoord97 = v.texcoord.xy * _Tiling_Noise_Secondary + panner94;
			float4 temp_output_126_0 = ( tex2Dlod( _T_Lu_Noise_01, float4( uv_TexCoord98, 0, 0.0) ) + tex2Dlod( _TextureSample0, float4( uv_TexCoord97, 0, 0.0) ) );
			float4 Nois106 = pow( frac( temp_output_126_0 ) , 5.0 );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_55_0 = ( ase_vertexNormal * _OffsetValue );
			float4 VertexOffset56 = ( Nois106 * float4( temp_output_55_0 , 0.0 ) );
			v.vertex.xyz += VertexOffset56.rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner93 = ( 1.0 * _Time.y * _Speed_Noise_1 + float2( 0,0 ));
			float2 uv_TexCoord98 = i.uv_texcoord * _Tiling_Noise_1 + panner93;
			float2 panner94 = ( 1.0 * _Time.y * _Speed_Noise_Secondary + float2( 0,0 ));
			float2 uv_TexCoord97 = i.uv_texcoord * _Tiling_Noise_Secondary + panner94;
			float4 temp_output_126_0 = ( tex2D( _T_Lu_Noise_01, uv_TexCoord98 ) + tex2D( _TextureSample0, uv_TexCoord97 ) );
			float4 Nois106 = pow( frac( temp_output_126_0 ) , 5.0 );
			float4 Emission36 = ( ( Nois106 * _Emission ) * _GlowColor );
			float4 temp_output_28_0 = Emission36;
			o.Emission = temp_output_28_0.rgb;
			o.Alpha = 1;
			clip( temp_output_28_0.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
768;476;878;833;1807.992;1913.977;2.200895;True;False
Node;AmplifyShaderEditor.Vector2Node;92;-2524.746,-1951.629;Float;False;Property;_Speed_Noise_1;Speed_Noise_1;2;0;Create;True;0;0;False;0;3,1;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;91;-2585.736,-1479.97;Float;False;Property;_Speed_Noise_Secondary;Speed_Noise_Secondary;6;0;Create;True;0;0;False;0;0,0;0.5,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;95;-2308.304,-1749.654;Float;False;Property;_Tiling_Noise_Secondary;Tiling_Noise_Secondary;0;0;Create;True;0;0;False;0;0,0;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;94;-2353.012,-1459.812;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;96;-2204.198,-2303.175;Float;False;Property;_Tiling_Noise_1;Tiling_Noise_1;1;0;Create;True;0;0;False;0;1,1;2,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;93;-2288.26,-2005.842;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;98;-1945.455,-2194.663;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;97;-2008.907,-1648.632;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;118;-1338.23,-2388.351;Float;True;Property;_T_Lu_Noise_01;T_Lu_Noise_01;9;0;Create;True;0;0;False;0;6ca5b2e608f86e14d88db87d75ba2f41;b70a8b1b9f818e24e95c0e0faa732f49;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;132;-1739.836,-1625.855;Float;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;False;0;6ca5b2e608f86e14d88db87d75ba2f41;6ca5b2e608f86e14d88db87d75ba2f41;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;126;-1008.126,-1716.927;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FractNode;125;-787.2612,-1452.345;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;102;-2577.645,-1210.403;Float;False;1966.161;816.4471;Noise;1;124;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;124;-1320.62,-1344.636;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;5;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-413.3993,-1163.769;Float;False;Nois;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-424.3138,-795.6616;Float;False;106;Nois;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;110;-829.0594,111.7251;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;108;-319.4435,-550.5659;Float;False;Property;_Emission;Emission;7;0;Create;True;0;0;False;0;3;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-638.6398,253.071;Float;False;Property;_OffsetValue;OffsetValue;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-138.7116,-248.6777;Float;False;106;Nois;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-577.588,-122.3342;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;38;284.5471,-943.3813;Float;False;Property;_GlowColor;Glow Color;4;1;[HDR];Create;True;0;0;False;0;0.6564829,0,1.717647,0;0.8647334,0.5719718,2.055221,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-70.52596,-709.1789;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-49.34518,73.0416;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;286.8601,-679.7297;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;544.2236,47.7402;Float;False;VertexOffset;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;558.1966,-691.9801;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;137;-215.6826,-2138.488;Float;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;False;0;6ca5b2e608f86e14d88db87d75ba2f41;a0cffd20234a1d84fbd45008fa35ce7b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;28;-31.30257,346.2092;Float;False;36;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;38.85735,762.5047;Float;False;56;VertexOffset;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-442.3296,135.1015;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-792.028,653.1725;Float;False;Property;_Animation_Offset;Animation_Offset;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-531.1866,-1908.809;Float;False;Property;_Lerp_Value_B;Lerp_Value_B;14;0;Create;True;0;0;False;0;0;0.3085472;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;138;-425.0955,-2302.378;Float;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;False;0;6ca5b2e608f86e14d88db87d75ba2f41;0478464d893083343b931277de9268e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;140;145.4806,-2156.7;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;133;40.50443,-1866.435;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;112;-840.3247,446.674;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;53;-832.8642,-109.0265;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-541.0869,568.9861;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-792.3284,-2080.822;Float;False;Property;_Lerp_Value_A;Lerp_Value_A;13;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;117;433.2659,416.6943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Shield_Cover;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;94;2;91;0
WireConnection;93;2;92;0
WireConnection;98;0;96;0
WireConnection;98;1;93;0
WireConnection;97;0;95;0
WireConnection;97;1;94;0
WireConnection;118;1;98;0
WireConnection;132;1;97;0
WireConnection;126;0;118;0
WireConnection;126;1;132;0
WireConnection;125;0;126;0
WireConnection;124;0;125;0
WireConnection;106;0;124;0
WireConnection;55;0;110;0
WireConnection;55;1;59;0
WireConnection;35;0;22;0
WireConnection;35;1;108;0
WireConnection;60;0;61;0
WireConnection;60;1;55;0
WireConnection;39;0;35;0
WireConnection;39;1;38;0
WireConnection;56;0;60;0
WireConnection;36;0;39;0
WireConnection;115;0;55;0
WireConnection;115;1;114;0
WireConnection;140;0;138;0
WireConnection;140;1;137;0
WireConnection;133;0;136;0
WireConnection;133;1;139;0
WireConnection;133;2;126;0
WireConnection;114;0;112;1
WireConnection;114;1;113;0
WireConnection;117;2;28;0
WireConnection;117;10;28;0
WireConnection;117;11;57;0
ASEEND*/
//CHKSM=006795E69C2AB04BEED119F1DFA6458C3752BF62