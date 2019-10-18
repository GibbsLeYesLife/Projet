// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Splash"
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
		_Scale_Fresnel("Scale_Fresnel", Float) = 0
		_Power_Fresnel("Power_Fresnel", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
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

		uniform float2 _Tiling_Noise_1;
		uniform float2 _Speed_Noise_1;
		uniform float2 _Tiling_Noise_2;
		uniform float2 _Speed_Noise_2;
		uniform float _OffsetValue;
		uniform float _Emission;
		uniform float4 _GlowColor;
		uniform float _Scale_Fresnel;
		uniform float _Power_Fresnel;
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
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV120 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode120 = ( 0.0 + _Scale_Fresnel * pow( 1.0 - fresnelNdotV120, _Power_Fresnel ) );
			float4 Emission36 = ( ( Nois106 * _Emission ) * _GlowColor * fresnelNode120 );
			float4 temp_output_28_0 = Emission36;
			o.Emission = temp_output_28_0.rgb;
			o.Alpha = 1;
			clip( temp_output_28_0.r - _Cutoff );
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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
411;523;1077;469;517.7954;-258.3055;1.3;True;False
Node;AmplifyShaderEditor.Vector2Node;91;-2585.736,-1479.97;Float;False;Property;_Speed_Noise_2;Speed_Noise_2;6;0;Create;True;0;0;False;0;2,0;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;92;-2524.746,-1951.629;Float;False;Property;_Speed_Noise_1;Speed_Noise_1;3;0;Create;True;0;0;False;0;3,1;5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;95;-2308.304,-1749.654;Float;False;Property;_Tiling_Noise_2;Tiling_Noise_2;0;0;Create;True;0;0;False;0;1,0;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;94;-2353.012,-1459.812;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;93;-2288.26,-2005.842;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;96;-2204.198,-2303.175;Float;False;Property;_Tiling_Noise_1;Tiling_Noise_1;2;0;Create;True;0;0;False;0;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;98;-1945.455,-2194.663;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;97;-2008.907,-1648.632;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;99;-1644.734,-2218.961;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;100;-1670.708,-1712.491;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;-1340.804,-1890.727;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;102;-2577.645,-1210.403;Float;False;1966.161;816.4471;Noise;3;106;105;104;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;103;-1099.364,-1707.499;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;105;-1106.76,-1138.406;Float;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-867.8674,-996.9074;Float;False;Nois;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;80.14377,-194.379;Float;False;Property;_Power_Fresnel;Power_Fresnel;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-638.6398,253.071;Float;False;Property;_OffsetValue;OffsetValue;5;0;Create;True;0;0;False;0;0.5;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;110;-829.0594,111.7251;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;121;18.12288,-478.8197;Float;False;Property;_Scale_Fresnel;Scale_Fresnel;9;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-424.3138,-795.6616;Float;False;106;Nois;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-319.4435,-550.5659;Float;False;Property;_Emission;Emission;7;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-138.7116,-248.6777;Float;False;106;Nois;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-577.588,-122.3342;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;120;264.9391,-402.2558;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-70.52596,-709.1789;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;284.5471,-943.3813;Float;False;Property;_GlowColor;Glow Color;4;1;[HDR];Create;True;0;0;False;0;0.6564829,0,1.717647,0;2.270603,0.558467,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;286.8601,-679.7297;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-49.34518,73.0416;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;695.0704,-687.7028;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;544.2236,47.7402;Float;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;53;-832.8642,-109.0265;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-442.3296,135.1015;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-541.0869,568.9861;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;119;-84.64457,559.2698;Float;False;Property;_Albedo;Albedo;11;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;-792.028,653.1725;Float;False;Property;_Animation_Offset;Animation_Offset;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;38.85735,762.5047;Float;False;56;VertexOffset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;86.03627,346.7163;Float;False;36;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;112;-840.3247,446.674;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;104;-1373.961,-1148.08;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;117;433.2659,416.6943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Splash;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;94;2;91;0
WireConnection;93;2;92;0
WireConnection;98;0;96;0
WireConnection;98;1;93;0
WireConnection;97;0;95;0
WireConnection;97;1;94;0
WireConnection;99;0;98;0
WireConnection;100;0;97;0
WireConnection;101;0;99;0
WireConnection;101;1;100;0
WireConnection;103;0;101;0
WireConnection;105;0;103;0
WireConnection;106;0;105;0
WireConnection;55;0;110;0
WireConnection;55;1;59;0
WireConnection;120;2;121;0
WireConnection;120;3;122;0
WireConnection;35;0;22;0
WireConnection;35;1;108;0
WireConnection;39;0;35;0
WireConnection;39;1;38;0
WireConnection;39;2;120;0
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
//CHKSM=7B48FC3E7D36F5B442C1231D6FA0BD79CB4C3817