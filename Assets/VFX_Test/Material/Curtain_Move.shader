// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Curtain_Move"
{
	Properties
	{
		_OffsetValue("OffsetValue", Float) = 0.23
		_Dissolve("Dissolve", Range( -20 , 20)) = 6.084421
		_Range("Range", Range( -20 , 20)) = 16.48606
		_rideau_normal("rideau_normal", 2D) = "bump" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Rideau_Roughness("Rideau_Roughness", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Dissolve;
		uniform float _Range;
		uniform float _OffsetValue;
		uniform sampler2D _rideau_normal;
		uniform float4 _rideau_normal_ST;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _Rideau_Roughness;
		uniform float4 _Rideau_Roughness_ST;


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
			float3 appendResult40 = (float3(-1.0 , -1.0 , 0.0));
			float2 panner31 = ( 1.0 * _Time.y * appendResult40.xy + float2( 0,0 ));
			float2 uv_TexCoord33 = v.texcoord.xy * float2( 5,5 ) + panner31;
			float simplePerlin2D45 = snoise( uv_TexCoord33 );
			float Noise37 = ( simplePerlin2D45 + -0.05 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform22 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient27 = saturate( ( ( transform22.y + _Dissolve ) / _Range ) );
			float2 uv_TexCoord55 = v.texcoord.xy + float2( 0,-0.14 );
			float temp_output_58_0 = uv_TexCoord55.y;
			v.vertex.xyz += ( ( Noise37 * ( ( ase_vertex3Pos * Y_Gradient27 ) * _OffsetValue ) ) * saturate( -(0.22 + (temp_output_58_0 - 0.88) * (0.52 - 0.22) / (1.25 - 0.88)) ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_rideau_normal = i.uv_texcoord * _rideau_normal_ST.xy + _rideau_normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _rideau_normal, uv_rideau_normal ) );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Albedo = tex2D( _TextureSample0, uv_TextureSample0 ).rgb;
			float2 uv_Rideau_Roughness = i.uv_texcoord * _Rideau_Roughness_ST.xy + _Rideau_Roughness_ST.zw;
			o.Smoothness = tex2D( _Rideau_Roughness, uv_Rideau_Roughness ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1099;91;821;927;945.4752;628.2292;2.017276;False;False
Node;AmplifyShaderEditor.RangedFloatNode;38;-3024.139,284.1356;Float;False;Constant;_SpeedPann;Speed Pann;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;20;-2167.093,-893.9294;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;39;-2818.576,289.2006;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;22;-1840.402,-928.5615;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-2073.855,-547.7603;Float;False;Property;_Dissolve;Dissolve;2;0;Create;True;0;0;False;0;6.084421;6.084421;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-2597.947,287.4904;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1528.614,-769.4871;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1413.227,-429.6187;Float;False;Property;_Range;Range;3;0;Create;True;0;0;False;0;16.48606;16.48606;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;31;-2393.01,260.5154;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;48;-2598.702,-101.0917;Float;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;5,5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;-1244.968,-787.4188;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-2308.856,-34.54272;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;26;-995.4612,-718.3314;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1890.107,662.6345;Float;False;Constant;_Booster;Booster;2;0;Create;True;0;0;False;0;-0.05;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;45;-1764.092,327.5013;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-340.3428,606.4285;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,-0.14;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-580.4287,-680.1806;Float;False;Y_Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;58;11.10184,582.1015;Float;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-1650.172,622.2545;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-874.2919,-112.2681;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;41;-881.9974,115.3262;Float;False;27;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-481.0999,344.3756;Float;False;Property;_OffsetValue;OffsetValue;0;0;Create;True;0;0;False;0;0.23;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;59;302.217,578.1755;Float;False;5;0;FLOAT;0;False;1;FLOAT;0.88;False;2;FLOAT;1.25;False;3;FLOAT;0.22;False;4;FLOAT;0.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-1452.868,-73.67767;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-590.1812,13.65144;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-410.1041,-278.4788;Float;False;37;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-301.1425,12.21608;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;61;634.1774,545.9681;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-47.63993,0.02422285;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;67;826.3314,417.7611;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;36;-1758.779,-11.68263;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;35;-2005.221,-32.73766;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1511.323,241.8984;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2026.443,318.3931;Float;False;Property;_Thickness;Thickness;4;0;Create;True;0;0;False;0;0.17;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-65.85394,-483.1891;Float;True;Property;_rideau_normal;rideau_normal;5;0;Create;True;0;0;False;0;3fba3465ab116a5419ffdb21c2d4e505;3fba3465ab116a5419ffdb21c2d4e505;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;260.6281,164.4701;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;199.0051,900.3926;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;334.4807,-498.3494;Float;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;d89eac6cc2e570643b49a9a0768a90c0;d89eac6cc2e570643b49a9a0768a90c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;52;90.69173,-211.2237;Float;True;Property;_Rideau_Roughness;Rideau_Roughness;7;0;Create;True;0;0;False;0;122593ce057e9684188233e7a25e4f30;122593ce057e9684188233e7a25e4f30;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;31.53924,296.2467;Float;False;Property;_Float0;Float 0;1;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;65;430.0663,918.6383;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;537.0559,-222.1031;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Curtain_Move;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;0;38;0
WireConnection;22;0;20;0
WireConnection;40;0;39;0
WireConnection;40;1;39;0
WireConnection;23;0;22;2
WireConnection;23;1;21;0
WireConnection;31;2;40;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;33;0;48;0
WireConnection;33;1;31;0
WireConnection;26;0;25;0
WireConnection;45;0;33;0
WireConnection;27;0;26;0
WireConnection;58;0;55;2
WireConnection;46;0;45;0
WireConnection;46;1;44;0
WireConnection;59;0;58;0
WireConnection;37;0;46;0
WireConnection;5;0;1;0
WireConnection;5;1;41;0
WireConnection;42;0;5;0
WireConnection;42;1;4;0
WireConnection;61;0;59;0
WireConnection;43;0;16;0
WireConnection;43;1;42;0
WireConnection;67;0;61;0
WireConnection;36;0;35;0
WireConnection;36;1;34;0
WireConnection;35;0;33;1
WireConnection;68;0;36;0
WireConnection;68;1;45;0
WireConnection;53;0;43;0
WireConnection;53;1;67;0
WireConnection;63;0;58;0
WireConnection;65;0;63;0
WireConnection;0;0;50;0
WireConnection;0;1;51;0
WireConnection;0;4;52;0
WireConnection;0;11;53;0
ASEEND*/
//CHKSM=D445728B17677109767D14DED7985DA1EA56BCB7