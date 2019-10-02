// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Dissolve_Second_Try"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_Speed("Speed", Float) = 2
		_Dissolve("Dissolve", Range( -20 , 20)) = 6.084421
		_Range("Range", Range( -20 , 20)) = 16.48606
		[HDR]_GlowColor("Glow Color", Color) = (0,1.582753,3.435294,0)
		_OffsetValue("OffsetValue", Float) = 0
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
		uniform float _Speed;
		uniform float _Dissolve;
		uniform float _Range;
		uniform float _OffsetValue;
		uniform float4 _GlowColor;
		uniform float _Cutoff = 0.5;


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
			float mulTime7 = _Time.y * _Speed;
			float2 panner6 = ( mulTime7 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord2 = v.texcoord.xy * _Tiling + panner6;
			float simplePerlin2D3 = snoise( uv_TexCoord2 );
			float Noise21 = ( simplePerlin2D3 + 1.0 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient23 = saturate( ( ( transform41.y + _Dissolve ) / _Range ) );
			float3 VertexOffset56 = ( Noise21 * ( ( ase_vertex3Pos * Y_Gradient23 ) * _OffsetValue ) );
			v.vertex.xyz += VertexOffset56;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime7 = _Time.y * _Speed;
			float2 panner6 = ( mulTime7 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord2 = i.uv_texcoord * _Tiling + panner6;
			float simplePerlin2D3 = snoise( uv_TexCoord2 );
			float Noise21 = ( simplePerlin2D3 + 1.0 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform41 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient23 = saturate( ( ( transform41.y + _Dissolve ) / _Range ) );
			float4 Emission36 = ( ( Noise21 * Y_Gradient23 ) * _GlowColor );
			o.Emission = Emission36.rgb;
			o.Alpha = 1;
			float temp_output_30_0 = ( Y_Gradient23 * 0.52 );
			float Opacity_mask26 = ( ( ( Noise21 * ( 1.0 - Y_Gradient23 ) ) - temp_output_30_0 ) + ( 1.0 - temp_output_30_0 ) );
			clip( Opacity_mask26 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
100;902;1754;916;2753.862;1449.33;1.634309;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;11;-2825.5,-52.46973;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-2317.216,-592.2988;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2732.262,293.6994;Float;False;Property;_Dissolve;Dissolve;3;0;Create;True;0;0;False;0;6.084421;-17.2;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;41;-2498.809,-87.10179;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;7;-2131.377,-665.6556;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2187.021,71.97256;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;5;-1979.801,-1123.728;Float;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;False;0;1,1;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;6;-1961.841,-799.3274;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2071.634,411.841;Float;False;Property;_Range;Range;4;0;Create;True;0;0;False;0;16.48606;10;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1721.059,-1015.215;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-1903.375,54.04087;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;3;-1438.549,-993.0744;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1673.455,-656.0955;Float;False;Constant;_Booster;Booster;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;-1653.869,123.1283;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1433.52,-696.4755;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1466.919,235.5385;Float;False;Y_Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1164.111,-759.1695;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1563.862,1246.796;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-815.842,170.741;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1226.508,1247.256;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1571.005,1571.615;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-1220.657,804.3195;Float;True;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;53;-832.8642,-109.0265;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1109.505,1553.74;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-406.4628,-499.3878;Float;False;23;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-424.3138,-795.6616;Float;False;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-582.2939,300.5201;Float;False;Property;_OffsetValue;OffsetValue;6;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1025.491,1000.391;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-577.588,-122.3342;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-138.7116,-248.6777;Float;False;21;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-823.8708,1293.849;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;284.5471,-943.3813;Float;False;Property;_GlowColor;Glow Color;5;1;[HDR];Create;True;0;0;False;0;0,1.582753,3.435294,0;0,0.9145671,29.11372,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-70.52596,-709.1789;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-299.571,63.29256;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;32;-817.0226,1555.781;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-49.34518,73.0416;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-569.5867,1559.037;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;286.8601,-679.7297;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;548.1976,-698.2295;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;223.0208,24.79716;Float;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-435.2203,1259.553;Float;False;Opacity_mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;178.4716,1169.207;Float;False;56;VertexOffset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;89.00161,382.3004;Float;False;36;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;98.17014,788.8009;Float;False;26;Opacity_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;433.2659,416.6943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Dissolve_Second_Try;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;11;0
WireConnection;7;0;8;0
WireConnection;12;0;41;2
WireConnection;12;1;13;0
WireConnection;6;1;7;0
WireConnection;2;0;5;0
WireConnection;2;1;6;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;3;0;2;0
WireConnection;16;0;14;0
WireConnection;9;0;3;0
WireConnection;9;1;10;0
WireConnection;23;0;16;0
WireConnection;21;0;9;0
WireConnection;17;0;24;0
WireConnection;30;0;29;0
WireConnection;18;0;25;0
WireConnection;18;1;17;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;31;0;18;0
WireConnection;31;1;30;0
WireConnection;35;0;22;0
WireConnection;35;1;34;0
WireConnection;58;0;55;0
WireConnection;58;1;59;0
WireConnection;32;0;30;0
WireConnection;60;0;61;0
WireConnection;60;1;58;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;39;0;35;0
WireConnection;39;1;38;0
WireConnection;36;0;39;0
WireConnection;56;0;60;0
WireConnection;26;0;33;0
WireConnection;0;2;28;0
WireConnection;0;10;27;0
WireConnection;0;11;57;0
ASEEND*/
//CHKSM=00E80359AB17EDD0A7A0F25697959197ACC091D3