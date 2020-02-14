// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Collectible_Wavu_Wavu"
{
	Properties
	{
		_OffsetValue("OffsetValue", Float) = 0.23
		_Float0("Float 0", Float) = 0.39
		_Rimlight("Rimlight", Range( -5 , 10)) = 0
		_Dissolve("Dissolve", Range( -20 , 20)) = 6.084421
		_Range("Range", Range( -20 , 20)) = 16.48606
		_cc1eedd318b249658199ac29d0845b6d("cc1eedd3-18b2-4965-8199-ac29d0845b6d", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _Dissolve;
		uniform float _Range;
		uniform float _OffsetValue;
		uniform float _Float0;
		uniform sampler2D _cc1eedd318b249658199ac29d0845b6d;
		uniform float4 _cc1eedd318b249658199ac29d0845b6d_ST;
		uniform float _Rimlight;


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
			float Noise37 = ( simplePerlin2D45 + 0.85 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform22 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient27 = saturate( ( ( transform22.y + _Dissolve ) / _Range ) );
			float2 uv_TexCoord55 = v.texcoord.xy + float2( 0,-0.25 );
			v.vertex.xyz += ( ( Noise37 * ( ( ase_vertex3Pos * Y_Gradient27 ) * _OffsetValue ) ) * saturate( -(0.13 + (sin( ( uv_TexCoord55.y * 8.0 ) ) - 0.88) * (1.3 - 0.13) / (2.05 - 0.88)) ) * _Float0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_cc1eedd318b249658199ac29d0845b6d = i.uv_texcoord * _cc1eedd318b249658199ac29d0845b6d_ST.xy + _cc1eedd318b249658199ac29d0845b6d_ST.zw;
			o.Albedo = tex2D( _cc1eedd318b249658199ac29d0845b6d, uv_cc1eedd318b249658199ac29d0845b6d ).rgb;
			float4 color72 = IsGammaSpace() ? float4(0,1.615686,3.513726,1) : float4(0,2.873329,15.87411,1);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV71 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode71 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV71, (10.5 + (_Rimlight - 0.0) * (0.0 - 10.5) / (10.5 - 0.0)) ) );
			o.Emission = ( color72 * fresnelNode71 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1006;91;914;927;2645.747;664.8166;2.621025;False;False
Node;AmplifyShaderEditor.PosVertexDataNode;20;-2167.093,-893.9294;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-3024.139,284.1356;Float;False;Constant;_SpeedPann;Speed Pann;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;22;-1840.402,-928.5615;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-2073.855,-547.7603;Float;False;Property;_Dissolve;Dissolve;4;0;Create;True;0;0;False;0;6.084421;12;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;39;-2818.576,289.2006;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1528.614,-769.4871;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1413.227,-429.6187;Float;False;Property;_Range;Range;5;0;Create;True;0;0;False;0;16.48606;20;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-2597.947,287.4904;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;-1244.968,-787.4188;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-340.3428,606.4285;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,-0.25;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;31;-2393.01,260.5154;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;48;-2598.702,-101.0917;Float;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;5,5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-2308.856,-34.54272;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;26;-995.4612,-718.3314;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;58;11.10184,582.1015;Float;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;45;-1655.201,325.6556;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1890.107,662.6345;Float;False;Constant;_Booster;Booster;2;0;Create;True;0;0;False;0;0.85;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-580.4287,-680.1806;Float;False;Y_Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;199.0051,900.3926;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-874.2919,-112.2681;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;41;-881.9974,115.3262;Float;False;27;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-1650.172,622.2545;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;65;430.0663,918.6383;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-1452.868,-73.67767;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-803.4429,-1030.567;Float;False;Property;_Rimlight;Rimlight;2;0;Create;True;0;0;False;0;0;8;-5;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-481.0999,344.3756;Float;False;Property;_OffsetValue;OffsetValue;0;0;Create;True;0;0;False;0;0.23;0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-590.1812,13.65144;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;59;302.217,578.1755;Float;False;5;0;FLOAT;0;False;1;FLOAT;0.88;False;2;FLOAT;2.05;False;3;FLOAT;0.13;False;4;FLOAT;1.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-301.1425,12.21608;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-410.1041,-278.4788;Float;False;37;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;61;634.1774,545.9681;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;70;-552.1255,-990.8453;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10.5;False;3;FLOAT;10.5;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;31.53924,296.2467;Float;False;Property;_Float0;Float 0;1;0;Create;True;0;0;False;0;0.39;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;71;-185.5112,-1005.159;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;-414.8926,-1248.548;Float;False;Constant;_Color0;Color 0;3;1;[HDR];Create;True;0;0;False;0;0,1.615686,3.513726,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-47.63993,0.02422285;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;67;826.3314,417.7611;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-56.94665,-567.7595;Float;True;Property;_cc1eedd318b249658199ac29d0845b6d;cc1eedd3-18b2-4965-8199-ac29d0845b6d;8;0;Create;True;0;0;False;0;36e0302ff2d85304ea15c96deaf2b893;36e0302ff2d85304ea15c96deaf2b893;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;183.9961,-884.7126;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;155.8685,-1117.736;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-132.0608,-785.3721;Float;False;Property;_Opacity_Strength;Opacity_Strength;3;0;Create;True;0;0;False;0;2.94;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;260.6281,164.4701;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;50;334.4807,-498.3494;Float;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;d89eac6cc2e570643b49a9a0768a90c0;d89eac6cc2e570643b49a9a0768a90c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;36;-1727.404,-15.3739;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2026.443,318.3931;Float;False;Property;_Thickness;Thickness;6;0;Create;True;0;0;False;0;0.17;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;35;-2005.221,-32.73766;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;537.0559,-222.1031;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Collectible_Wavu_Wavu;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;20;0
WireConnection;39;0;38;0
WireConnection;23;0;22;2
WireConnection;23;1;21;0
WireConnection;40;0;39;0
WireConnection;40;1;39;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;31;2;40;0
WireConnection;33;0;48;0
WireConnection;33;1;31;0
WireConnection;26;0;25;0
WireConnection;58;0;55;2
WireConnection;45;0;33;0
WireConnection;27;0;26;0
WireConnection;63;0;58;0
WireConnection;46;0;45;0
WireConnection;46;1;44;0
WireConnection;65;0;63;0
WireConnection;37;0;46;0
WireConnection;5;0;1;0
WireConnection;5;1;41;0
WireConnection;59;0;65;0
WireConnection;42;0;5;0
WireConnection;42;1;4;0
WireConnection;61;0;59;0
WireConnection;70;0;69;0
WireConnection;71;3;70;0
WireConnection;43;0;16;0
WireConnection;43;1;42;0
WireConnection;67;0;61;0
WireConnection;75;0;71;0
WireConnection;75;1;73;0
WireConnection;74;0;72;0
WireConnection;74;1;71;0
WireConnection;53;0;43;0
WireConnection;53;1;67;0
WireConnection;53;2;54;0
WireConnection;36;0;35;0
WireConnection;36;1;34;0
WireConnection;35;0;33;1
WireConnection;0;0;68;0
WireConnection;0;2;74;0
WireConnection;0;11;53;0
ASEEND*/
//CHKSM=CF240FFD4DF703890C4B337FD652E3D2C8F38AED