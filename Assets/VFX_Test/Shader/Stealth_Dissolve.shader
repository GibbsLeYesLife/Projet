// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Stealth_Dissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Dissolve("Dissolve", Range( -20 , 20)) = 6.084421
		_Range("Range", Range( -20 , 20)) = 16.48606
		_Second_Noise_Tile("Second_Noise_Tile", Vector) = (1,1,0,0)
		_Main_Noise_Tile("Main_Noise_Tile", Vector) = (1,1,0,0)
		[HDR]_GlowColor("Glow Color", Color) = (0,1.582753,3.435294,0)
		_OffsetValue("OffsetValue", Float) = 0
		_Main_Noise_Speed("Main_Noise_Speed", Vector) = (1,1,0,0)
		_Second_Noise_Speed("Second_Noise_Speed", Vector) = (1,1,0,0)
		_T_Lu_Noise_02("T_Lu_Noise_02", 2D) = "white" {}
		_T_Lu_Noise_09("T_Lu_Noise_09", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _T_Lu_Noise_02;
		uniform float2 _Main_Noise_Tile;
		uniform float2 _Main_Noise_Speed;
		uniform sampler2D _T_Lu_Noise_09;
		uniform float2 _Second_Noise_Tile;
		uniform float2 _Second_Noise_Speed;
		uniform float _Dissolve;
		uniform float _Range;
		uniform float _OffsetValue;
		uniform float4 _GlowColor;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 panner107 = ( 1.0 * _Time.y * _Main_Noise_Speed + float2( 0,0 ));
			float2 uv_TexCoord109 = v.texcoord.xy * _Main_Noise_Tile + panner107;
			float2 panner114 = ( 1.0 * _Time.y * _Second_Noise_Speed + float2( 0,0 ));
			float2 uv_TexCoord112 = v.texcoord.xy * _Second_Noise_Tile + panner114;
			float4 temp_output_115_0 = ( tex2Dlod( _T_Lu_Noise_02, float4( uv_TexCoord109, 0, 0.0) ) + tex2Dlod( _T_Lu_Noise_09, float4( uv_TexCoord112, 0, 0.0) ) );
			float4 Noise21 = pow( temp_output_115_0 , 7.0 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient23 = saturate( ( ( transform41.y + _Dissolve ) / _Range ) );
			float4 VertexOffset56 = ( Noise21 * float4( ( ( ase_vertex3Pos * Y_Gradient23 ) * _OffsetValue ) , 0.0 ) );
			v.vertex.xyz += VertexOffset56.rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color136 = IsGammaSpace() ? float4(0,0.5759377,1,0) : float4(0,0.2911801,1,0);
			o.Albedo = color136.rgb;
			float2 panner107 = ( 1.0 * _Time.y * _Main_Noise_Speed + float2( 0,0 ));
			float2 uv_TexCoord109 = i.uv_texcoord * _Main_Noise_Tile + panner107;
			float2 panner114 = ( 1.0 * _Time.y * _Second_Noise_Speed + float2( 0,0 ));
			float2 uv_TexCoord112 = i.uv_texcoord * _Second_Noise_Tile + panner114;
			float4 temp_output_115_0 = ( tex2D( _T_Lu_Noise_02, uv_TexCoord109 ) + tex2D( _T_Lu_Noise_09, uv_TexCoord112 ) );
			float4 Noise21 = pow( temp_output_115_0 , 7.0 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient23 = saturate( ( ( transform41.y + _Dissolve ) / _Range ) );
			float4 Emission36 = ( ( Noise21 * Y_Gradient23 ) * _GlowColor );
			o.Emission = Emission36.rgb;
			o.Alpha = 1;
			float temp_output_30_0 = ( Y_Gradient23 * 0.5 );
			float4 temp_cast_3 = (temp_output_30_0).xxxx;
			float4 Opacity_mask26 = ( ( ( Noise21 * ( 1.0 - Y_Gradient23 ) ) - temp_cast_3 ) + ( 1.0 - temp_output_30_0 ) );
			clip( Opacity_mask26.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
85;545;1077;469;932.5965;-265.196;1.954478;True;False
Node;AmplifyShaderEditor.CommentaryNode;94;-3155.034,-184.7027;Float;False;1961.231;676.9128;Y_Gradient;8;23;16;14;12;15;13;41;11;Y_Gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;131;-3087.421,-1884.396;Float;False;Property;_Main_Noise_Speed;Main_Noise_Speed;7;0;Create;True;0;0;False;0;1,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;132;-3148.411,-1412.737;Float;False;Property;_Second_Noise_Speed;Second_Noise_Speed;8;0;Create;True;0;0;False;0;1,1;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PosVertexDataNode;11;-2888.75,-130.6561;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;107;-2850.935,-1938.609;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;114;-2915.687,-1392.579;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;108;-2765.151,-2235.942;Float;False;Property;_Main_Noise_Tile;Main_Noise_Tile;4;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;111;-2830.324,-1689.912;Float;False;Property;_Second_Noise_Tile;Second_Noise_Tile;3;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;13;-2770.682,196.8907;Float;False;Property;_Dissolve;Dissolve;1;0;Create;True;0;0;False;0;6.084421;3.1;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;41;-2562.059,-165.2882;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-2302.487,256.0615;Float;False;Property;_Range;Range;2;0;Create;True;0;0;False;0;16.48606;10;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2250.271,-6.213785;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-2571.582,-1581.399;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;109;-2508.13,-2127.43;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;133;-2005.555,-2024.964;Float;True;Property;_T_Lu_Noise_02;T_Lu_Noise_02;9;0;Create;True;0;0;False;0;0478464d893083343b931277de9268e0;0478464d893083343b931277de9268e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-1966.626,-24.14547;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;135;-2284.874,-1398.088;Float;True;Property;_T_Lu_Noise_09;T_Lu_Noise_09;10;0;Create;True;0;0;False;0;d700dfdaae9f94a459c31181b819588f;d700dfdaae9f94a459c31181b819588f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;93;-3140.319,-1143.17;Float;False;1966.161;816.4471;Noise;3;21;62;129;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-1795.057,-1697.002;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;16;-1717.12,44.94191;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1530.17,157.3521;Float;False;Y_Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;129;-1669.435,-1071.173;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;7;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;96;-2985.535,664.2147;Float;False;1522.56;1057.718;Opacity_mask;10;24;17;29;25;30;18;32;31;33;26;Opacity_Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;97;-1401.404,1141.224;Float;False;1348.884;857.1978;Vertex_Offset;8;54;55;59;58;61;60;56;53;Vertex_Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1430.542,-929.6744;Float;False;Noise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-2928.392,1156.693;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1334.382,1610.643;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-2983.535,1481.512;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;92;-1068.057,-592.3851;Float;False;1421.887;793.5461;Emission;6;36;39;35;38;22;34;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;53;-1351.404,1330.875;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2633.395,727.9883;Float;True;21;Noise;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;17;-2661.542,1115.188;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-949.8107,-340.7686;Float;False;21;Noise;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2490.936,1464.937;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2407.544,929.3551;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1100.834,1740.422;Float;False;Property;_OffsetValue;OffsetValue;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1096.128,1317.568;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-931.9597,-44.49479;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-657.2518,1191.224;Float;False;21;Noise;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-818.1111,1503.194;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;38;-240.9497,-488.4884;Float;False;Property;_GlowColor;Glow Color;5;1;[HDR];Create;True;0;0;False;0;0,1.582753,3.435294,0;3.374888,0.09140877,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-596.0231,-254.2859;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;32;-2181.553,1465.678;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-2162.397,1148.273;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-238.6367,-224.8366;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1894.246,1463.733;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-567.8856,1512.944;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-295.5203,1464.699;Float;False;VertexOffset;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1672.306,1060.052;Float;False;Opacity_mask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;22.70057,-243.3365;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;72.17012,822.6006;Float;False;26;Opacity_mask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;178.4716,1169.207;Float;False;56;VertexOffset;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FractNode;62;-1862.143,-991.0737;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;113;-2284.582,-1895.231;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;136;-94.12518,534.9139;Float;False;Constant;_Color0;Color 0;11;0;Create;True;0;0;False;0;0,0.5759377,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;110;-2197.172,-2202.914;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;55.20156,312.1006;Float;False;36;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;433.2659,416.6943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Stealth_Dissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;107;2;131;0
WireConnection;114;2;132;0
WireConnection;41;0;11;0
WireConnection;12;0;41;2
WireConnection;12;1;13;0
WireConnection;112;0;111;0
WireConnection;112;1;114;0
WireConnection;109;0;108;0
WireConnection;109;1;107;0
WireConnection;133;1;109;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;135;1;112;0
WireConnection;115;0;133;0
WireConnection;115;1;135;0
WireConnection;16;0;14;0
WireConnection;23;0;16;0
WireConnection;129;0;115;0
WireConnection;21;0;129;0
WireConnection;17;0;24;0
WireConnection;30;0;29;0
WireConnection;18;0;25;0
WireConnection;18;1;17;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;58;0;55;0
WireConnection;58;1;59;0
WireConnection;35;0;22;0
WireConnection;35;1;34;0
WireConnection;32;0;30;0
WireConnection;31;0;18;0
WireConnection;31;1;30;0
WireConnection;39;0;35;0
WireConnection;39;1;38;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;60;0;61;0
WireConnection;60;1;58;0
WireConnection;56;0;60;0
WireConnection;26;0;33;0
WireConnection;36;0;39;0
WireConnection;62;0;115;0
WireConnection;113;0;112;0
WireConnection;0;0;136;0
WireConnection;0;2;28;0
WireConnection;0;10;27;0
WireConnection;0;11;57;0
ASEEND*/
//CHKSM=D1BB804D7D24EE4B9C27F3CA7E3521C50FD54284