// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/AnimatedHighlight"
{
	Properties
	{
		_BaseTexture("BaseTexture", 2D) = "white" {}
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_OutlineTexture("OutlineTexture", 2D) = "white" {}
		_HighLightColor("HighLightColor", Color) = (0,0.204227,1,0)
		_OutlineColor("OutlineColor", Color) = (0,0.204227,1,0)
		_OutlineGlowPower("OutlineGlowPower", Float) = 10
		_HighLightColorBurn("HighLightColorBurn", Float) = 5
		_TimeScale("TimeScale", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _BaseColor;
		uniform sampler2D _BaseTexture;
		uniform float4 _BaseTexture_ST;
		uniform float4 _OutlineColor;
		uniform float _TimeScale;
		uniform float _OutlineGlowPower;
		uniform sampler2D _OutlineTexture;
		uniform float4 _OutlineTexture_ST;
		uniform float4 _HighLightColor;
		uniform float _HighLightColorBurn;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BaseTexture = i.uv_texcoord * _BaseTexture_ST.xy + _BaseTexture_ST.zw;
			float4 tex2DNode1 = tex2D( _BaseTexture, uv_BaseTexture );
			o.Albedo = ( _BaseColor * tex2DNode1 ).rgb;
			float4 color50 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 transform66 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 paralaxOffset68 = ParallaxOffset( 1 , 1 , transform66.xyz );
			float2 uv_TexCoord41 = i.uv_texcoord * float2( 0.1,1 ) + paralaxOffset68;
			float mulTime29 = _Time.y * _TimeScale;
			float clampResult48 = clamp( (0.0 + (sin( ( ( uv_TexCoord41.x + mulTime29 ) * 4.0 ) ) - 0.0) * (0.5 - 0.0) / (0.5 - 0.0)) , 0.0 , 1.0 );
			float4 lerpResult52 = lerp( color50 , _OutlineColor , clampResult48);
			float2 uv_OutlineTexture = i.uv_texcoord * _OutlineTexture_ST.xy + _OutlineTexture_ST.zw;
			float4 tex2DNode6 = tex2D( _OutlineTexture, uv_OutlineTexture );
			float4 color19 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 uv_TexCoord16 = i.uv_texcoord * float2( 0.1,1 ) + paralaxOffset68;
			float clampResult24 = clamp( (0.0 + (sin( ( ( uv_TexCoord16.x + mulTime29 ) * 4.0 ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float4 lerpResult18 = lerp( color19 , _HighLightColor , pow( clampResult24 , 10.0 ));
			o.Emission = ( ( pow( ( lerpResult52 * _OutlineGlowPower ) , 1.0 ) * tex2DNode6 ) + ( lerpResult18 * _HighLightColorBurn ) ).rgb;
			o.Alpha = ( _BaseColor.a * ( tex2DNode1.a + tex2DNode6.r ) );
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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
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
Version=16100
1275;91;645;927;954.6718;429.5749;1.081411;True;True
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;66;-4584.407,1101.746;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;68;-4329.935,1056.637;Float;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;49;-3296.469,929.2663;Float;False;3417.877;781.3615;Animation du Highlight;7;36;37;21;19;38;18;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-4265.792,-48.80957;Float;False;2493.953;865.8516;OutlineColor & Animation;10;41;42;44;45;46;47;51;50;48;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;36;-3246.469,1154.325;Float;False;2060.894;557.0812;Creation et animation du Ramp;7;22;30;25;26;23;24;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-4215.792,270.6128;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-4291.828,1384.946;Float;False;Property;_TimeScale;TimeScale;7;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-3894.567,1402.846;Float;False;1;0;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-3219.073,1229.665;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;42;-3882.063,381.8497;Float;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-2929.978,1217.627;Float;False;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-3575.223,486.5323;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-3298.02,464.9405;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-2513.978,1281.627;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;46;-3048.219,457.0745;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2257.978,1217.627;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;47;-2827.309,453.4714;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;3;FLOAT;0;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;26;-2008.175,1209.761;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;23;-1787.266,1206.158;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;48;-2481.613,460.3904;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;-2531.213,1.190434;Float;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;35;-1560.8,-51.59795;Float;False;903.0984;622.8404;Glow & Intensité du glow;4;9;4;8;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;51;-2520.884,177.2493;Float;False;Property;_OutlineColor;OutlineColor;4;0;Create;True;0;0;False;0;0,0.204227,1,0;0,0.204227,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;37;-975.4025,1347.727;Float;False;311;303;Power pour reduire l'étalement du blanc et augmenter celui du noir;1;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;24;-1441.57,1213.078;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-2036.839,200.5892;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1496.4,313.2424;Float;False;Property;_OutlineGlowPower;OutlineGlowPower;5;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1198.801,192.9425;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;21;-927.8658,1166.678;Float;False;Property;_HighLightColor;HighLightColor;3;0;Create;True;0;0;False;0;0,0.204227,1,0;0,0.204227,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-923.4435,979.2663;Float;False;Constant;_GradientColor1;GradientColor1;4;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;33;-708.4536,-814.4286;Float;False;749.6217;500.9573;Base Texture and color;3;2;1;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;32;-925.4025,1397.727;Float;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-535.7905,1049.235;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;34;-436.319,-197.4443;Float;False;543.3007;305.6933;Gestion de l'alpha;2;11;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-488.0738,1323.308;Float;False;Property;_HighLightColorBurn;HighLightColorBurn;6;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-1202.983,-1.597946;Float;True;Property;_OutlineTexture;OutlineTexture;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;9;-918.7015,225.2425;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-658.4536,-543.4713;Float;True;Property;_BaseTexture;BaseTexture;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-386.319,-144.751;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-113.5902,1177.336;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;5;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;-642.2229,-764.4286;Float;False;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-245.0497,191.3187;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;76;-3330.786,1672.603;Float;False;True;4;0;FLOAT3;0,0,0;False;1;FLOAT;45;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;197.5844,262.7817;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-193.8319,-648.4495;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-128.0182,-147.4443;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;467.6986,-96.88767;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/AnimatedHighlight;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;2;66;0
WireConnection;41;1;68;0
WireConnection;29;0;56;0
WireConnection;16;1;68;0
WireConnection;42;0;41;1
WireConnection;22;0;16;1
WireConnection;44;0;42;0
WireConnection;44;1;29;0
WireConnection;45;0;44;0
WireConnection;30;0;22;0
WireConnection;30;1;29;0
WireConnection;46;0;45;0
WireConnection;25;0;30;0
WireConnection;47;0;46;0
WireConnection;26;0;25;0
WireConnection;23;0;26;0
WireConnection;48;0;47;0
WireConnection;24;0;23;0
WireConnection;52;0;50;0
WireConnection;52;1;51;0
WireConnection;52;2;48;0
WireConnection;8;0;52;0
WireConnection;8;1;4;0
WireConnection;32;0;24;0
WireConnection;18;0;19;0
WireConnection;18;1;21;0
WireConnection;18;2;32;0
WireConnection;9;0;8;0
WireConnection;11;0;1;4
WireConnection;11;1;6;1
WireConnection;31;0;18;0
WireConnection;31;1;38;0
WireConnection;7;0;9;0
WireConnection;7;1;6;0
WireConnection;40;0;7;0
WireConnection;40;1;31;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;12;0;2;4
WireConnection;12;1;11;0
WireConnection;0;0;3;0
WireConnection;0;2;40;0
WireConnection;0;9;12;0
ASEEND*/
//CHKSM=A9CB5E144DE3BEBEC1F9505A4AD76DE82EF85BA5