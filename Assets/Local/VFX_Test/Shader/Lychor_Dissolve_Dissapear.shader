// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lychor_Dissolve_Disappear"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Dissolve("Dissolve", Range( -10 , 10)) = 0
		_Min_Smooth("Min_Smooth", Float) = 0.26
		_Max_Smooth("Max_Smooth", Float) = 0.26
		_Main_Noise_Tile("Main_Noise_Tile", Vector) = (1,1,0,0)
		_Tile_Second("Tile_Second", Vector) = (1,1,0,0)
		_Main_Noise_Speed("Main_Noise_Speed", Vector) = (0,0,0,0)
		_Speed_Second("Speed_Second", Vector) = (0,0,0,0)
		_T_Lu_Noise_02("T_Lu_Noise_02", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Ramp("Ramp", 2D) = "white" {}
		_Emissive_Strength("Emissive_Strength", Range( 0 , 20)) = 6.1
		_Final_Power("Final_Power", Range( 0 , 10)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Background+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _Emissive_Strength;
		uniform sampler2D _Ramp;
		uniform float _Min_Smooth;
		uniform float _Max_Smooth;
		uniform sampler2D _T_Lu_Noise_02;
		uniform float2 _Main_Noise_Tile;
		uniform float2 _Main_Noise_Speed;
		uniform sampler2D _TextureSample0;
		uniform float2 _Tile_Second;
		uniform float2 _Speed_Second;
		uniform float _Dissolve;
		uniform float _Final_Power;
		uniform float _Cutoff = 0.5;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 panner39 = ( 1.0 * _Time.y * _Main_Noise_Speed + float2( 0,0 ));
			float2 uv_TexCoord44 = i.uv_texcoord * _Main_Noise_Tile + panner39;
			float2 panner59 = ( 1.0 * _Time.y * _Speed_Second + float2( 0,0 ));
			float2 uv_TexCoord60 = i.uv_texcoord * _Tile_Second + panner59;
			float Noise50 = ( tex2D( _T_Lu_Noise_02, uv_TexCoord44 ).b + tex2D( _TextureSample0, uv_TexCoord60 ).b );
			float Dissolve_Noise82 = ( Noise50 + _Dissolve );
			c.rgb = 0;
			c.a = 1;
			clip( Dissolve_Noise82 - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 panner39 = ( 1.0 * _Time.y * _Main_Noise_Speed + float2( 0,0 ));
			float2 uv_TexCoord44 = i.uv_texcoord * _Main_Noise_Tile + panner39;
			float2 panner59 = ( 1.0 * _Time.y * _Speed_Second + float2( 0,0 ));
			float2 uv_TexCoord60 = i.uv_texcoord * _Tile_Second + panner59;
			float Noise50 = ( tex2D( _T_Lu_Noise_02, uv_TexCoord44 ).b + tex2D( _TextureSample0, uv_TexCoord60 ).b );
			float Dissolve_Noise82 = ( Noise50 + _Dissolve );
			float smoothstepResult74 = smoothstep( _Min_Smooth , ( _Min_Smooth + _Max_Smooth ) , Dissolve_Noise82);
			float2 appendResult72 = (float2(smoothstepResult74 , 0.0));
			float4 temp_cast_0 = (_Final_Power).xxxx;
			float4 Ramping_Edge_Emission91 = pow( ( _Emissive_Strength * tex2D( _Ramp, appendResult72 ) ) , temp_cast_0 );
			float4 temp_output_92_0 = Ramping_Edge_Emission91;
			o.Emission = temp_output_92_0.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
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
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
110;118;1077;494;-742.6055;1029.807;1.76275;True;False
Node;AmplifyShaderEditor.CommentaryNode;119;-2381.392,-1937.349;Float;False;2239.873;1265.48;Comment;12;57;37;41;58;39;59;60;44;46;61;62;50;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;57;-2331.392,-975.8685;Float;False;Property;_Speed_Second;Speed_Second;8;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;37;-2186.546,-1535.803;Float;False;Property;_Main_Noise_Speed;Main_Noise_Speed;7;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;41;-1864.276,-1887.349;Float;False;Property;_Main_Noise_Tile;Main_Noise_Tile;5;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;58;-2009.122,-1296;Float;False;Property;_Tile_Second;Tile_Second;6;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;59;-2094.906,-1030.082;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;39;-1950.06,-1590.016;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-1752.101,-1218.902;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-1607.255,-1778.837;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;-1104.68,-1676.371;Float;True;Property;_T_Lu_Noise_02;T_Lu_Noise_02;9;0;Create;True;0;0;False;0;0478464d893083343b931277de9268e0;0478464d893083343b931277de9268e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;61;-1249.526,-1116.436;Float;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;0478464d893083343b931277de9268e0;0478464d893083343b931277de9268e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-749.0229,-1325.29;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;120;-118.8851,-1340.075;Float;False;1106.679;714.5516;Comment;4;3;54;6;82;Opacity Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-384.519,-1422.976;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-65.0211,-1201.333;Float;False;50;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-68.88511,-883.5233;Float;False;Property;_Dissolve;Dissolve;1;0;Create;True;0;0;False;0;0;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;380.9729,-1119.641;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;121;-2074.395,-543.9843;Float;False;2904.834;921.8471;Comment;12;9;75;76;83;74;72;70;79;80;90;89;91;Emissive Ramp;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2024.395,119.8628;Float;False;Property;_Max_Smooth;Max_Smooth;4;0;Create;True;0;0;False;0;0.26;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1892.547,-69.36189;Float;False;Property;_Min_Smooth;Min_Smooth;3;0;Create;True;0;0;False;0;0.26;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;735.7939,-1290.075;Float;False;Dissolve_Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-1681.717,-381.2912;Float;False;82;Dissolve_Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-1563.97,74.89455;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;-1331.399,-255.7044;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;72;-1006.875,-243.2943;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;70;-731.2432,-256.3943;Float;True;Property;_Ramp;Ramp;11;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;-499.9372,-493.9843;Float;False;Property;_Emissive_Strength;Emissive_Strength;12;0;Create;True;0;0;False;0;6.1;6.1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-440.1762,17.33449;Float;False;Property;_Final_Power;Final_Power;13;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-276.2523,-294.066;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;89;129.3192,-276.2755;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;515.4396,-290.1375;Float;False;Ramping_Edge_Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;122;-2360.007,452.5023;Float;False;2818.771;951.0077;Comment;17;100;94;93;95;96;98;97;101;99;103;104;107;111;108;114;110;102;Lighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;132;1588.013,587.8613;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;134;1829.386,851.4622;Float;False;Property;_Float2;Float 2;15;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;125;1204.715,-179.127;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;130;700.2294,529.8298;Float;True;Property;_Texture0;Texture 0;14;0;Create;True;0;0;False;0;None;None;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;1898.722,554.6133;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1981.294,632.0173;Float;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;126;1235.49,37.02428;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;1996.719,-212.5776;Float;False;82;Dissolve_Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;1522.888,-516.3862;Float;False;Property;_Float3;Float 3;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;123;1717.6,-266.5392;Float;False;Global;_GrabScreen0;Grab Screen 0;14;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;129;1242.015,606.9307;Float;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-745.6254,558.586;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;94;-2276.483,782.8983;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;131;1541.586,-35.21318;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;1683.607,-889.4644;Float;False;91;Ramping_Edge_Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;93;-2310.007,633.7285;Float;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;138;1231.263,388.212;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;104;-996.7196,912.5234;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;136;1904.181,-526.9887;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-1228.036,858.5139;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;-1633.87,872.4965;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;101;-1432.444,1094.981;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;186.7643,673.4539;Float;False;Custom_Lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;107;-721.0377,912.5632;Float;True;Property;_Ramp_Lighting;Ramp_Lighting;2;0;Create;True;0;0;False;0;None;091aed8ca4d12e4438ba8743f5592c99;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1440.996,839.3763;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;124;959.6326,-122.3059;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;95;-2004.973,866.9885;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-177.1323,647.4778;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;1838.512,60.36176;Float;False;108;Custom_Lighting;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-1783.528,855.8976;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;110;-1194.207,502.5023;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightAttenuation;99;-1720.937,1050.761;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-1979.06,1145.51;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;118;2300.209,-539.8798;Float;False;True;7;Float;ASEMaterialInspector;0;0;CustomLighting;Lychor_Dissolve_Disappear;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Background;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;1;15;10;25;True;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;2;57;0
WireConnection;39;2;37;0
WireConnection;60;0;58;0
WireConnection;60;1;59;0
WireConnection;44;0;41;0
WireConnection;44;1;39;0
WireConnection;46;1;44;0
WireConnection;61;1;60;0
WireConnection;62;0;46;3
WireConnection;62;1;61;3
WireConnection;50;0;62;0
WireConnection;6;0;54;0
WireConnection;6;1;3;0
WireConnection;82;0;6;0
WireConnection;76;0;9;0
WireConnection;76;1;75;0
WireConnection;74;0;83;0
WireConnection;74;1;9;0
WireConnection;74;2;76;0
WireConnection;72;0;74;0
WireConnection;70;1;72;0
WireConnection;80;0;79;0
WireConnection;80;1;70;0
WireConnection;89;0;80;0
WireConnection;89;1;90;0
WireConnection;91;0;89;0
WireConnection;132;0;129;1
WireConnection;132;1;129;2
WireConnection;125;0;124;1
WireConnection;125;1;124;2
WireConnection;133;0;132;0
WireConnection;133;1;134;0
WireConnection;126;0;125;0
WireConnection;126;1;124;4
WireConnection;123;0;131;0
WireConnection;129;0;130;0
WireConnection;111;0;110;1
WireConnection;111;1;102;0
WireConnection;131;0;126;0
WireConnection;131;1;133;0
WireConnection;104;0;103;0
WireConnection;136;0;92;0
WireConnection;136;1;123;0
WireConnection;136;2;137;0
WireConnection;103;0;102;0
WireConnection;103;1;101;2
WireConnection;100;0;98;0
WireConnection;100;1;97;0
WireConnection;108;0;114;0
WireConnection;107;1;104;0
WireConnection;102;0;100;0
WireConnection;102;1;99;0
WireConnection;95;0;93;0
WireConnection;95;1;94;0
WireConnection;114;0;111;0
WireConnection;114;1;107;0
WireConnection;98;0;96;0
WireConnection;98;1;95;0
WireConnection;118;2;92;0
WireConnection;118;10;84;0
ASEEND*/
//CHKSM=BE952C0129542105A1D543F122B80E4695EBF626