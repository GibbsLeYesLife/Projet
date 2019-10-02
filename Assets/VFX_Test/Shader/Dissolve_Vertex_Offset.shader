// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Dissolve_Vertex_Offset"
{
	Properties
	{
		_Tiling_Noise_2("Tiling_Noise_2", Vector) = (1,0,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Tiling_Noise_1("Tiling_Noise_1", Vector) = (5,5,0,0)
		_Speed_Noise_1("Speed_Noise_1", Vector) = (3,1,0,0)
		[HDR]_GlowColor("Glow Color", Color) = (0.6564829,0,1.717647,0)
		_OffsetValue("OffsetValue", Float) = 0.5
		_Speed_Noise_2("Speed_Noise_2", Vector) = (2,0,0,0)
		_Emission("Emission", Float) = 0
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

		uniform float2 _Tiling_Noise_1;
		uniform float2 _Speed_Noise_1;
		uniform float2 _Tiling_Noise_2;
		uniform float2 _Speed_Noise_2;
		uniform float _OffsetValue;
		uniform float _Emission;
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
			float2 panner93 = ( 1.0 * _Time.y * _Speed_Noise_1 + float2( 0,0 ));
			float2 uv_TexCoord98 = v.texcoord.xy * _Tiling_Noise_1 + panner93;
			float simplePerlin2D99 = snoise( uv_TexCoord98 );
			float2 panner94 = ( 1.0 * _Time.y * _Speed_Noise_2 + float2( 0,0 ));
			float2 uv_TexCoord97 = v.texcoord.xy * _Tiling_Noise_2 + panner94;
			float simplePerlin2D100 = snoise( uv_TexCoord97 );
			float clampResult103 = clamp( ( simplePerlin2D99 + simplePerlin2D100 ) , 0.0 , 1.0 );
			float Nois106 = pow( clampResult103 , 5.0 );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_55_0 = ( ase_vertexNormal * _OffsetValue );
			float3 VertexOffset56 = ( Nois106 * temp_output_55_0 );
			v.vertex.xyz += VertexOffset56;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner93 = ( 1.0 * _Time.y * _Speed_Noise_1 + float2( 0,0 ));
			float2 uv_TexCoord98 = i.uv_texcoord * _Tiling_Noise_1 + panner93;
			float simplePerlin2D99 = snoise( uv_TexCoord98 );
			float2 panner94 = ( 1.0 * _Time.y * _Speed_Noise_2 + float2( 0,0 ));
			float2 uv_TexCoord97 = i.uv_texcoord * _Tiling_Noise_2 + panner94;
			float simplePerlin2D100 = snoise( uv_TexCoord97 );
			float clampResult103 = clamp( ( simplePerlin2D99 + simplePerlin2D100 ) , 0.0 , 1.0 );
			float Nois106 = pow( clampResult103 , 5.0 );
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
118;206;1077;523;2258.194;1629.187;1.791026;True;False
Node;AmplifyShaderEditor.Vector2Node;91;-2585.736,-1479.97;Float;False;Property;_Speed_Noise_2;Speed_Noise_2;6;0;Create;True;0;0;False;0;2,0;-5,-5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;92;-2524.746,-1951.629;Float;False;Property;_Speed_Noise_1;Speed_Noise_1;3;0;Create;True;0;0;False;0;3,1;-10,-20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;96;-2204.198,-2303.175;Float;False;Property;_Tiling_Noise_1;Tiling_Noise_1;2;0;Create;True;0;0;False;0;5,5;20,20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;95;-2301.378,-1748.269;Float;False;Property;_Tiling_Noise_2;Tiling_Noise_2;0;0;Create;True;0;0;False;0;1,0;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;94;-2353.012,-1459.812;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;93;-2288.26,-2005.842;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;97;-2008.907,-1648.632;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;98;-1945.455,-2194.663;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;99;-1644.734,-2218.961;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;100;-1670.708,-1712.491;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;-1340.804,-1890.727;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;103;-1099.364,-1707.499;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;102;-2577.645,-1210.403;Float;False;1966.161;816.4471;Noise;3;106;105;104;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;105;-1106.76,-1138.406;Float;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-867.8674,-996.9074;Float;False;Nois;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;110;-829.0594,111.7251;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;108;-319.4435,-550.5659;Float;False;Property;_Emission;Emission;9;0;Create;True;0;0;False;0;0;9.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-638.6398,253.071;Float;False;Property;_OffsetValue;OffsetValue;5;0;Create;True;0;0;False;0;0.5;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-424.3138,-795.6616;Float;False;106;Nois;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-138.7116,-248.6777;Float;False;106;Nois;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-577.588,-122.3342;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-70.52596,-709.1789;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;284.5471,-943.3813;Float;False;Property;_GlowColor;Glow Color;4;1;[HDR];Create;True;0;0;False;0;0.6564829,0,1.717647,0;2.996078,0.9509314,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;286.8601,-679.7297;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-49.34518,73.0416;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;548.1976,-698.2295;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;544.2236,47.7402;Float;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;87;-6.118254,594.9934;Float;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;None;b7d44fea6f0ad224899c65e825ee61e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;53;-832.8642,-109.0265;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;112;-840.3247,446.674;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;-792.028,653.1725;Float;False;Property;_Animation_Offset;Animation_Offset;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-442.3296,135.1015;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;89.00161,382.3004;Float;False;36;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;178.4716,1169.207;Float;False;56;VertexOffset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-541.0869,568.9861;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;104;-1299.468,-1058.307;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;-321.3576,436.0757;Float;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;False;0;None;2399ef6219970db409ce10620fbc0daa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;117;433.2659,416.6943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Dissolve_Vertex_Offset;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;94;2;91;0
WireConnection;93;2;92;0
WireConnection;97;0;95;0
WireConnection;97;1;94;0
WireConnection;98;0;96;0
WireConnection;98;1;93;0
WireConnection;99;0;98;0
WireConnection;100;0;97;0
WireConnection;101;0;99;0
WireConnection;101;1;100;0
WireConnection;103;0;101;0
WireConnection;105;0;103;0
WireConnection;106;0;105;0
WireConnection;55;0;110;0
WireConnection;55;1;59;0
WireConnection;35;0;22;0
WireConnection;35;1;108;0
WireConnection;39;0;35;0
WireConnection;39;1;38;0
WireConnection;60;0;61;0
WireConnection;60;1;55;0
WireConnection;36;0;39;0
WireConnection;56;0;60;0
WireConnection;115;0;55;0
WireConnection;115;1;114;0
WireConnection;114;0;112;1
WireConnection;114;1;113;0
WireConnection;104;0;103;0
WireConnection;117;2;28;0
WireConnection;117;10;28;0
WireConnection;117;11;57;0
ASEEND*/
//CHKSM=D196B9D58B3E3F6D13B116BA4CCF1C8114FF24B1