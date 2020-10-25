// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Black_Ode_Au_Courage"
{
	Properties
	{
		_Tiling_Noise_Secondary("Tiling_Noise_Secondary", Vector) = (1,1,0,0)
		_Tiling_Noise_1("Tiling_Noise_1", Vector) = (1,1,0,0)
		_Speed_Noise_1("Speed_Noise_1", Vector) = (0,-1,0,0)
		_Speed_Noise_Secondary("Speed_Noise_Secondary", Vector) = (0,-1,0,0)
		_Noise_First("Noise_First", 2D) = "white" {}
		_Noise_Second("Noise_Second", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (1.679245,0.3938755,0.2138661,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Power("Power", Float) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform float _Power;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform sampler2D _Noise_First;
		uniform float2 _Tiling_Noise_1;
		uniform float2 _Speed_Noise_1;
		uniform sampler2D _Noise_Second;
		uniform float2 _Tiling_Noise_Secondary;
		uniform float2 _Speed_Noise_Secondary;
		uniform float _Opacity;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float4 tex2DNode19 = tex2D( _TextureSample2, uv_TextureSample2 );
			float2 panner12 = ( 1.0 * _Time.y * _Speed_Noise_1 + float2( 0,0 ));
			float2 uv_TexCoord3 = i.uv_texcoord * _Tiling_Noise_1 + panner12;
			float2 panner10 = ( 1.0 * _Time.y * _Speed_Noise_Secondary + float2( 0,0 ));
			float2 uv_TexCoord4 = i.uv_texcoord * _Tiling_Noise_Secondary + panner10;
			float smoothstepResult16 = smoothstep( (0.1 + (( 1.0 - tex2DNode19.r ) - 0.82) * (0.81 - 0.1) / (2.53 - 0.82)) , 2.0 , ( tex2D( _Noise_First, uv_TexCoord3 ).r + tex2D( _Noise_Second, uv_TexCoord4 ).r ));
			float Noise8 = ( _Power * smoothstepResult16 );
			float3 temp_cast_0 = (( _Color.r * Noise8 )).xxx;
			o.Emission = temp_cast_0;
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			o.Alpha = ( Noise8 * ( _Opacity * ( tex2D( _TextureSample1, uv_TextureSample1 ).r * tex2DNode19.r ) ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
218;545;1188;427;736.8502;124.6445;1.3;True;False
Node;AmplifyShaderEditor.Vector2Node;9;-2055.873,-125.9878;Float;False;Property;_Speed_Noise_1;Speed_Noise_1;2;0;Create;True;0;0;False;0;0,-1;0.5,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;11;-2116.864,345.6713;Float;False;Property;_Speed_Noise_Secondary;Speed_Noise_Secondary;3;0;Create;True;0;0;False;0;0,-1;-0.5,-3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;1;-1735.324,-477.5338;Float;False;Property;_Tiling_Noise_1;Tiling_Noise_1;1;0;Create;True;0;0;False;0;1,1;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;2;-1839.43,75.98721;Float;False;Property;_Tiling_Noise_Secondary;Tiling_Noise_Secondary;0;0;Create;True;0;0;False;0;1,1;1,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;10;-1884.139,365.8292;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;12;-1819.386,-180.2008;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1476.581,-369.0218;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1540.033,177.0092;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-1307.715,787.187;Inherit;True;Property;_TextureSample2;Texture Sample 2;8;0;Create;True;0;0;False;0;-1;None;9bc6a67813fa9944d88a826c25a31cb3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1233.752,242.3112;Inherit;True;Property;_Noise_Second;Noise_Second;5;0;Create;True;0;0;False;0;-1;6ca5b2e608f86e14d88db87d75ba2f41;556f7a78cac96ac4681f5f8e368d17a0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-869.3561,-562.7098;Inherit;True;Property;_Noise_First;Noise_First;4;0;Create;True;0;0;False;0;-1;6ca5b2e608f86e14d88db87d75ba2f41;52c23aad27620924c8000f07732e3f62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;21;-995.3774,876.718;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-843.2934,34.43677;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-756.0803,776.1066;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.82;False;2;FLOAT;2.53;False;3;FLOAT;0.1;False;4;FLOAT;0.81;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-726.0304,-223.6246;Inherit;False;Property;_Power;Power;9;0;Create;True;0;0;False;0;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-720.3648,324.6584;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-572.79,-52.92633;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-1260.968,527.5521;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;-1;None;790068d4715e9e744a4a737a78ac2d22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-368.8979,95.14184;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-461.8147,559.7421;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-215.7625,375.1088;Inherit;False;Property;_Opacity;Opacity;10;0;Create;True;0;0;False;0;1;0.993;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-100.1704,152.0333;Inherit;False;8;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;123.0241,579.1934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-394.5352,-255.6875;Inherit;False;Property;_Color;Color;6;1;[HDR];Create;True;0;0;False;0;1.679245,0.3938755,0.2138661,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;155.8516,258.0248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;17.81462,-176.5683;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;29;623.9253,-40.64927;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Black_Ode_Au_Courage;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;2;11;0
WireConnection;12;2;9;0
WireConnection;3;0;1;0
WireConnection;3;1;12;0
WireConnection;4;0;2;0
WireConnection;4;1;10;0
WireConnection;5;1;4;0
WireConnection;6;1;3;0
WireConnection;21;0;19;1
WireConnection;7;0;6;1
WireConnection;7;1;5;1
WireConnection;24;0;21;0
WireConnection;16;0;7;0
WireConnection;16;1;24;0
WireConnection;23;0;22;0
WireConnection;23;1;16;0
WireConnection;8;0;23;0
WireConnection;20;0;17;1
WireConnection;20;1;19;1
WireConnection;27;0;26;0
WireConnection;27;1;20;0
WireConnection;25;0;14;0
WireConnection;25;1;27;0
WireConnection;13;0;15;1
WireConnection;13;1;14;0
WireConnection;29;2;13;0
WireConnection;29;9;25;0
ASEEND*/
//CHKSM=AA1311246D16763649F0B49CFB68ADE7EAF0D392