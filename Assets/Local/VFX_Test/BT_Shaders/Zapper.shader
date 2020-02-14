// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Zapper"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0
		_Dissolve("Dissolve", Range( -20 , 20)) = 6.084421
		_Float3("Float 3", Range( -20 , 20)) = 6.084421
		_Range("Range", Range( -20 , 20)) = 16.48606
		_Float4("Float 4", Range( -20 , 20)) = 16.48606
		_Vector0("Vector 0", Vector) = (1,1,0,0)
		_Tiling("Tiling", Vector) = (1,1,0,0)
		[HDR]_GlowColor("Glow Color", Color) = (0,1.582753,3.435294,0)
		_OffsetValue("OffsetValue", Float) = 0
		_Speed_Panner_1("Speed_Panner_1", Vector) = (0,0,0,0)
		_Speed_Panner_2("Speed_Panner_2", Vector) = (0,0,0,0)
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

		uniform float2 _Tiling;
		uniform float2 _Speed_Panner_1;
		uniform float2 _Vector0;
		uniform float2 _Speed_Panner_2;
		uniform float _Dissolve;
		uniform float _Range;
		uniform float _OffsetValue;
		uniform float4 _GlowColor;
		uniform float _Float3;
		uniform float _Float4;
		uniform float _Cutoff = 0;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 panner107 = ( 1.0 * _Time.y * _Speed_Panner_1 + float2( 0,0 ));
			float2 uv_TexCoord109 = v.texcoord.xy * _Tiling + panner107;
			float simplePerlin2D110 = snoise( uv_TexCoord109 );
			float2 panner114 = ( 1.0 * _Time.y * _Speed_Panner_2 + float2( 0,0 ));
			float2 uv_TexCoord112 = v.texcoord.xy * _Vector0 + panner114;
			float simplePerlin2D113 = snoise( uv_TexCoord112 );
			float clampResult116 = clamp( ( simplePerlin2D110 + simplePerlin2D113 ) , 0.0 , 1.0 );
			float temp_output_62_0 = frac( clampResult116 );
			float Noise21 = pow( temp_output_62_0 , 5.0 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient23 = saturate( ( ( transform41.y + _Dissolve ) / _Range ) );
			float3 VertexOffset56 = ( Noise21 * ( ( ase_vertex3Pos * Y_Gradient23 ) * _OffsetValue ) );
			v.vertex.xyz += VertexOffset56;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner107 = ( 1.0 * _Time.y * _Speed_Panner_1 + float2( 0,0 ));
			float2 uv_TexCoord109 = i.uv_texcoord * _Tiling + panner107;
			float simplePerlin2D110 = snoise( uv_TexCoord109 );
			float2 panner114 = ( 1.0 * _Time.y * _Speed_Panner_2 + float2( 0,0 ));
			float2 uv_TexCoord112 = i.uv_texcoord * _Vector0 + panner114;
			float simplePerlin2D113 = snoise( uv_TexCoord112 );
			float clampResult116 = clamp( ( simplePerlin2D110 + simplePerlin2D113 ) , 0.0 , 1.0 );
			float temp_output_62_0 = frac( clampResult116 );
			float Noise21 = pow( temp_output_62_0 , 5.0 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient23 = saturate( ( ( transform41.y + _Dissolve ) / _Range ) );
			float4 Emission36 = ( ( Noise21 * Y_Gradient23 ) * _GlowColor );
			o.Emission = Emission36.rgb;
			o.Alpha = 1;
			float4 transform122 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float temp_output_30_0 = ( Y_Gradient23 * 1.0 );
			float Opacity_mask26 = ( ( ( Noise21 * ( 1.0 - saturate( ( ( transform122.y + _Float3 ) / _Float4 ) ) ) ) - temp_output_30_0 ) + ( 1.0 - temp_output_30_0 ) );
			clip( Opacity_mask26 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1016;99;896;911;1187.052;928.9507;2.87823;False;True
Node;AmplifyShaderEditor.Vector2Node;131;-3087.421,-1884.396;Float;False;Property;_Speed_Panner_1;Speed_Panner_1;12;0;Create;True;0;0;False;0;0,0;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;132;-3148.411,-1412.737;Float;False;Property;_Speed_Panner_2;Speed_Panner_2;13;0;Create;True;0;0;False;0;0,0;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;111;-2830.324,-1689.912;Float;False;Property;_Vector0;Vector 0;5;0;Create;True;0;0;False;0;1,1;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;114;-2915.687,-1392.579;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;108;-2766.873,-2235.942;Float;False;Property;_Tiling;Tiling;6;0;Create;True;0;0;False;0;1,1;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;107;-2850.935,-1938.609;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;94;-3155.034,-184.7027;Float;False;1961.231;676.9128;Y_Gradient;8;23;16;14;12;15;13;41;11;Y_Gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-2571.582,-1581.399;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;109;-2508.13,-2127.43;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;11;-2888.75,-130.6561;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;110;-2207.409,-2151.728;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;113;-2233.383,-1645.258;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;41;-2562.059,-165.2882;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-2770.682,196.8907;Float;False;Property;_Dissolve;Dissolve;1;0;Create;True;0;0;False;0;6.084421;9.36;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;121;-4599.063,844.283;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;133;-1907.226,-1907.275;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2302.487,256.0615;Float;False;Property;_Range;Range;3;0;Create;True;0;0;False;0;16.48606;20;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2250.271,-6.213785;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;93;-3140.319,-1143.17;Float;False;1966.161;816.4471;Noise;14;21;64;65;62;2;69;63;68;66;67;98;103;104;129;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;116;-1662.039,-1640.266;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;122;-4272.373,809.6509;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;123;-4480.996,1171.83;Float;False;Property;_Float3;Float 3;2;0;Create;True;0;0;False;0;6.084421;0.69;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-1966.626,-24.14547;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;62;-1862.143,-991.0737;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-3960.585,968.7253;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-4012.801,1231;Float;False;Property;_Float4;Float 4;4;0;Create;True;0;0;False;0;16.48606;16.48606;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;129;-1669.435,-1071.173;Float;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;126;-3676.94,950.7936;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;-1717.12,44.94191;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;127;-3427.434,1019.881;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-1401.404,1141.224;Float;False;1348.884;857.1978;Vertex_Offset;8;54;55;59;58;61;60;56;53;Vertex_Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1430.542,-929.6744;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1530.17,157.3521;Float;False;Y_Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;-2985.535,664.2147;Float;False;1522.56;1057.718;Opacity_mask;10;24;17;29;25;30;18;32;31;33;26;Opacity_Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1334.382,1610.643;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;53;-1351.404,1330.875;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;92;-1068.057,-592.3851;Float;False;1421.887;793.5461;Emission;6;36;39;35;38;22;34;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-2935.535,1481.512;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2633.395,727.9883;Float;True;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-2661.542,1115.188;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2407.544,929.3551;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2474.035,1463.637;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1100.834,1740.422;Float;False;Property;_OffsetValue;OffsetValue;8;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1096.128,1317.568;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-949.8107,-340.7686;Float;False;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-931.9597,-44.49479;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-2162.397,1148.273;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-818.1111,1503.194;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;38;-240.9497,-488.4884;Float;False;Property;_GlowColor;Glow Color;7;1;[HDR];Create;True;0;0;False;0;0,1.582753,3.435294,0;0,12.66203,27.48235,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;61;-657.2518,1191.224;Float;False;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-596.0231,-254.2859;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-2181.553,1465.678;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-238.6367,-224.8366;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-567.8856,1512.944;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1894.246,1463.733;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;22.70057,-243.3365;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-295.5203,1464.699;Float;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1672.306,1060.052;Float;False;Opacity_mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;66;-2850.401,-951.3301;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2686.411,-683.1583;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-1519.123,-699.1002;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-2928.392,1156.693;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2589.949,-945.543;Float;False;Property;_Noise_Scale;Noise_Scale;10;0;Create;True;0;0;False;0;5;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;98;-2174.58,-824.1861;Float;True;Property;_Cloud;Cloud;11;0;Create;True;0;0;False;0;1c45bf93b4b304b4389de51ca9301cfe;1c45bf93b4b304b4389de51ca9301cfe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;27;72.17012,822.6006;Float;False;26;Opacity_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;69;-2431.748,-661.9359;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;55.20156,312.1006;Float;False;36;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-2908.279,-567.4005;Float;False;Constant;_Speed;Speed;7;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;64;-1663.591,-938.6659;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;103;-1849.119,-649.6888;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;5;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2347.593,-956.9941;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;57;178.4716,1169.207;Float;False;56;VertexOffset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2065.182,-604.058;Float;False;Property;_Thickness;Thickness;9;0;Create;True;0;0;False;0;0.5;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-1713.023,-437.4691;Float;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;433.2659,416.6943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Zapper;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;114;2;132;0
WireConnection;107;2;131;0
WireConnection;112;0;111;0
WireConnection;112;1;114;0
WireConnection;109;0;108;0
WireConnection;109;1;107;0
WireConnection;110;0;109;0
WireConnection;113;0;112;0
WireConnection;41;0;11;0
WireConnection;133;0;110;0
WireConnection;133;1;113;0
WireConnection;12;0;41;2
WireConnection;12;1;13;0
WireConnection;116;0;133;0
WireConnection;122;0;121;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;62;0;116;0
WireConnection;125;0;122;2
WireConnection;125;1;123;0
WireConnection;129;0;62;0
WireConnection;126;0;125;0
WireConnection;126;1;124;0
WireConnection;16;0;14;0
WireConnection;127;0;126;0
WireConnection;21;0;129;0
WireConnection;23;0;16;0
WireConnection;17;0;127;0
WireConnection;18;0;25;0
WireConnection;18;1;17;0
WireConnection;30;0;29;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;31;0;18;0
WireConnection;31;1;30;0
WireConnection;58;0;55;0
WireConnection;58;1;59;0
WireConnection;35;0;22;0
WireConnection;35;1;34;0
WireConnection;32;0;30;0
WireConnection;39;0;35;0
WireConnection;39;1;38;0
WireConnection;60;0;61;0
WireConnection;60;1;58;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;36;0;39;0
WireConnection;56;0;60;0
WireConnection;26;0;33;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;104;0;103;0
WireConnection;104;1;105;0
WireConnection;98;1;2;0
WireConnection;69;1;68;0
WireConnection;64;0;62;0
WireConnection;64;1;65;0
WireConnection;103;0;98;0
WireConnection;2;0;63;0
WireConnection;2;1;69;0
WireConnection;0;2;28;0
WireConnection;0;10;27;0
WireConnection;0;11;57;0
ASEEND*/
//CHKSM=B8220E45C99B21D30BB651F59D2A8E7840610810