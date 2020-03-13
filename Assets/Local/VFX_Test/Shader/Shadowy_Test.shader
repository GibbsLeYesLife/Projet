// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shadowy_Test"
{
	Properties
	{
		[Toggle(_KEYWORD0_ON)] _Keyword0("Keyword 0", Float) = 0
		_Tex_1_Tile("Tex_1_Tile", Vector) = (2,0.3,0,0)
		_Tex_1_Offset("Tex_1_Offset", Vector) = (0,0,0,0)
		_Tex_1_Pan_Speed("Tex_1_Pan_Speed", Vector) = (0,-0.2,0,0)
		_Tex_2_Pan_Speed("Tex_2_Pan_Speed", Vector) = (0,-0.15,0,0)
		_Tex_2_Tile("Tex_2_Tile", Vector) = (1,0.3,0,0)
		_Tex_2_Offset("Tex_2_Offset", Vector) = (0,0,0,0)
		_Distortion_Tile("Distortion_Tile", Vector) = (1,1,0,0)
		_Distortion_Pan_Speed("Distortion_Pan_Speed", Vector) = (0.05,-1,0,0)
		_Distortion("Distortion", 2D) = "white" {}
		_Distortion_Factor("Distortion_Factor", Range( 0 , 0.2)) = 0.06145984
		_Tex_1("Tex_1", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[Toggle(_KEYWORD1_ON)] _Keyword1("Keyword 1", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Mask_Remap("Mask_Remap", Float) = 0
		_SmoothStep_1("SmoothStep_1", Vector) = (-0.06,0.47,0,0)
		_SmoothStep_2("SmoothStep_2", Vector) = (0.22,0.31,0,0)
		[HDR]_Edge_Color("Edge_Color", Color) = (0.2923676,0.645225,1.925593,0)
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _KEYWORD0_ON
		#pragma shader_feature _KEYWORD1_ON
		#pragma surface surf Unlit alpha:fade keepalpha addshadow fullforwardshadows 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv_tex4coord;
		};

		uniform float2 _SmoothStep_1;
		uniform sampler2D _Tex_1;
		uniform float2 _Tex_1_Pan_Speed;
		uniform float2 _Tex_1_Tile;
		uniform float2 _Tex_1_Offset;
		uniform float _Distortion_Factor;
		uniform sampler2D _Distortion;
		uniform float2 _Distortion_Pan_Speed;
		uniform float2 _Distortion_Tile;
		uniform sampler2D _TextureSample0;
		uniform float2 _Tex_2_Pan_Speed;
		uniform float2 _Tex_2_Tile;
		uniform float2 _Tex_2_Offset;
		uniform sampler2D _TextureSample1;
		uniform float _Mask_Remap;
		uniform float2 _SmoothStep_2;
		uniform float4 _Edge_Color;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 Tex1PanSpeed13 = _Tex_1_Pan_Speed;
			float2 Tex1Tile7 = _Tex_1_Tile;
			float2 temp_cast_0 = (0.0).xx;
			#ifdef _KEYWORD0_ON
				float2 staticSwitch2 = i.uv_texcoord;
			#else
				float2 staticSwitch2 = temp_cast_0;
			#endif
			float2 Tex1Offset10 = ( _Tex_1_Offset + staticSwitch2 );
			float2 uv_TexCoord21 = i.uv_texcoord * Tex1Tile7 + Tex1Offset10;
			float2 panner22 = ( 1.0 * _Time.y * Tex1PanSpeed13 + uv_TexCoord21);
			float2 DistortionPanSpeed29 = _Distortion_Pan_Speed;
			float2 DistortionTile27 = _Distortion_Tile;
			float2 uv_TexCoord30 = i.uv_texcoord * DistortionTile27;
			float2 panner31 = ( 1.0 * _Time.y * DistortionPanSpeed29 + uv_TexCoord30);
			float DistortionOutput40 = ( _Distortion_Factor * (-0.5 + (tex2D( _Distortion, panner31 ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) );
			float Tex1R53 = tex2D( _Tex_1, ( panner22 + DistortionOutput40 ) ).r;
			float2 Tex2PanSpeed14 = _Tex_2_Pan_Speed;
			float2 Tex2Tile16 = _Tex_2_Tile;
			float2 Tex2Offset18 = ( _Tex_2_Offset + staticSwitch2 );
			float2 uv_TexCoord46 = i.uv_texcoord * Tex2Tile16 + Tex2Offset18;
			float2 panner52 = ( 1.0 * _Time.y * Tex2PanSpeed14 + uv_TexCoord46);
			float Tex2R54 = tex2D( _TextureSample0, ( panner52 + DistortionOutput40 ) ).r;
			float2 appendResult56 = (float2(i.uv_tex4coord.z , i.uv_tex4coord.w));
			#ifdef _KEYWORD1_ON
				float2 staticSwitch57 = appendResult56;
			#else
				float2 staticSwitch57 = float2( 0,0 );
			#endif
			float2 uv_TexCoord58 = i.uv_texcoord + staticSwitch57;
			float temp_output_62_0 = ( i.uv_tex4coord.w + _Mask_Remap );
			float temp_output_67_0 = ( ( Tex1R53 + Tex2R54 ) * (temp_output_62_0 + (tex2D( _TextureSample1, uv_TexCoord58 ).r - 0.0) * (( temp_output_62_0 + 1.0 ) - temp_output_62_0) / (1.0 - 0.0)) );
			float smoothstepResult76 = smoothstep( _SmoothStep_1.x , _SmoothStep_1.y , temp_output_67_0);
			float smoothstepResult77 = smoothstep( _SmoothStep_2.x , _SmoothStep_2.y , ( 1.0 - temp_output_67_0 ));
			o.Emission = ( ( smoothstepResult76 * smoothstepResult77 ) * _Edge_Color ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
439;489;1077;474;2827.692;-924.3801;2.546537;True;False
Node;AmplifyShaderEditor.CommentaryNode;68;-2208,416;Float;False;1604.948;888.1971;Zbeul de valeurs;21;13;6;29;4;18;12;19;10;2;15;28;8;9;27;14;26;16;3;17;7;11;Initialisation;0.8018868,0.4576807,0.4576807,1;0;0
Node;AmplifyShaderEditor.Vector2Node;26;-1872,1136;Float;False;Property;_Distortion_Tile;Distortion_Tile;7;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;28;-1440,1136;Float;False;Property;_Distortion_Pan_Speed;Distortion_Pan_Speed;8;0;Create;True;0;0;False;0;0.05,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1664,1152;Float;False;DistortionTile;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-1168,1152;Float;False;DistortionPanSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-2205.817,1418.208;Float;False;27;DistortionTile;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;3;-2160,880;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-1980.542,1406.629;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;34;-1965.369,1545.237;Float;False;29;DistortionPanSpeed;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2080,768;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;17;-1232,576;Float;False;Property;_Tex_2_Offset;Tex_2_Offset;6;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;8;-1776,624;Float;False;Property;_Tex_1_Offset;Tex_1_Offset;2;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;2;-1840,784;Float;False;Property;_Keyword0;Keyword 0;0;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;31;-1615.859,1412.568;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1008,768;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;6;-2000,480;Float;False;Property;_Tex_1_Tile;Tex_1_Tile;1;0;Create;True;0;0;False;0;2,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1472,720;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;15;-1536,464;Float;False;Property;_Tex_2_Tile;Tex_2_Tile;5;0;Create;True;0;0;False;0;1,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;35;-1352.906,1456.015;Float;True;Property;_Distortion;Distortion;9;0;Create;True;0;0;False;0;1cc7c8f54ac3f934eaf70c0e7a831a64;1cc7c8f54ac3f934eaf70c0e7a831a64;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1328,704;Float;False;Tex1Offset;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1344,480;Float;False;Tex2Tile;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1792,496;Float;False;Tex1Tile;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;37;-1039.868,1472.65;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;11;-1888,976;Float;False;Property;_Tex_1_Pan_Speed;Tex_1_Pan_Speed;3;0;Create;True;0;0;False;0;0,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;12;-1424,976;Float;False;Property;_Tex_2_Pan_Speed;Tex_2_Pan_Speed;4;0;Create;True;0;0;False;0;0,-0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-848,768;Float;False;Tex2Offset;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-816,1328;Float;False;Property;_Distortion_Factor;Distortion_Factor;10;0;Create;True;0;0;False;0;0.06145984;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-687.5125,1508.944;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1899.499,210.8067;Float;False;18;Tex2Offset;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1648,976;Float;False;Tex1PanSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-2179.815,-122.0323;Float;False;10;Tex1Offset;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-1896.873,83.44962;Float;False;16;Tex2Tile;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1168,992;Float;False;Tex2PanSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-2177.189,-249.3894;Float;False;7;Tex1Tile;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2008.927,-43.21191;Float;False;13;Tex1PanSpeed;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-448.5761,1525.579;Float;False;DistortionOutput;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-1667.105,117.5865;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1947.421,-215.2525;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;48;-1728.612,289.627;Float;False;14;Tex2PanSpeed;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;55;-599.5186,-32.57961;Float;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;52;-1374.834,137.4507;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-1680.676,-55.38876;Float;False;40;DistortionOutput;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;22;-1655.149,-195.3883;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1400.361,277.4502;Float;False;40;DistortionOutput;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-349.0721,16.70039;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1402.17,-166.7912;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1158.966,159.8624;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;60;-380.4083,306.8898;Float;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;57;-154.3179,18.23391;Float;False;Property;_Keyword1;Keyword 1;13;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-165.6932,452.7646;Float;False;Property;_Mask_Remap;Mask_Remap;15;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-1250.383,-201.6046;Float;True;Property;_Tex_1;Tex_1;11;0;Create;True;0;0;False;0;e3b399bfe2879e544bf023fdda73b79c;3ef2750b38b3bf24492daf58c7ec2b57;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;47;-1007.18,125.049;Float;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;False;0;e3b399bfe2879e544bf023fdda73b79c;55e1deb75560ace49b1b0ef035e1d83f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;95.46086,10.57738;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-695.3763,170.4014;Float;False;Tex2R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;63.77263,326.5583;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-45.95139,581.7617;Float;False;Constant;_a;a;16;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-900.8457,-145.8552;Float;False;Tex1R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;292.5086,-160.4393;Float;False;54;Tex2R;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;383.7698,-261.5;Float;False;53;Tex1R;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;222.1825,469.7867;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;348.2502,6.261969;Float;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;False;0;e0c51c9d580b0f446b5cc88d1b107a72;e0c51c9d580b0f446b5cc88d1b107a72;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;74;959.9224,-126.7618;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;66;505.4136,298.9587;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;859.796,272.7161;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;79;1116.52,-23.30318;Float;False;Property;_SmoothStep_1;SmoothStep_1;16;0;Create;True;0;0;False;0;-0.06,0.47;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;78;1086.014,477.1658;Float;True;Property;_SmoothStep_2;SmoothStep_2;17;0;Create;True;0;0;False;0;0.22,0.31;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;80;1110.234,257.0449;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;77;1338.242,285.2565;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;76;1331.988,7.969777;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;82;1677.486,490.3247;Float;False;Property;_Edge_Color;Edge_Color;18;1;[HDR];Create;True;0;0;False;0;0.2923676,0.645225,1.925593,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;1636.379,191.438;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1917.621,184.2554;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;686.4297,-181.3081;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;2488.52,67.28897;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Shadowy_Test;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;26;0
WireConnection;29;0;28;0
WireConnection;30;0;33;0
WireConnection;2;1;4;0
WireConnection;2;0;3;0
WireConnection;31;0;30;0
WireConnection;31;2;34;0
WireConnection;19;0;17;0
WireConnection;19;1;2;0
WireConnection;9;0;8;0
WireConnection;9;1;2;0
WireConnection;35;1;31;0
WireConnection;10;0;9;0
WireConnection;16;0;15;0
WireConnection;7;0;6;0
WireConnection;37;0;35;1
WireConnection;18;0;19;0
WireConnection;39;0;38;0
WireConnection;39;1;37;0
WireConnection;13;0;11;0
WireConnection;14;0;12;0
WireConnection;40;0;39;0
WireConnection;46;0;50;0
WireConnection;46;1;45;0
WireConnection;21;0;23;0
WireConnection;21;1;24;0
WireConnection;52;0;46;0
WireConnection;52;2;48;0
WireConnection;22;0;21;0
WireConnection;22;2;25;0
WireConnection;56;0;55;3
WireConnection;56;1;55;4
WireConnection;43;0;22;0
WireConnection;43;1;42;0
WireConnection;49;0;52;0
WireConnection;49;1;51;0
WireConnection;57;0;56;0
WireConnection;44;1;43;0
WireConnection;47;1;49;0
WireConnection;58;1;57;0
WireConnection;54;0;47;1
WireConnection;62;0;60;4
WireConnection;62;1;61;0
WireConnection;53;0;44;1
WireConnection;64;0;62;0
WireConnection;64;1;63;0
WireConnection;59;1;58;0
WireConnection;74;0;72;0
WireConnection;74;1;73;0
WireConnection;66;0;59;1
WireConnection;66;3;62;0
WireConnection;66;4;64;0
WireConnection;67;0;74;0
WireConnection;67;1;66;0
WireConnection;80;0;67;0
WireConnection;77;0;80;0
WireConnection;77;1;78;1
WireConnection;77;2;78;2
WireConnection;76;0;67;0
WireConnection;76;1;79;1
WireConnection;76;2;79;2
WireConnection;81;0;76;0
WireConnection;81;1;77;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;71;0;72;0
WireConnection;71;1;73;0
WireConnection;1;2;83;0
ASEEND*/
//CHKSM=F74ABB2B6670A3394027B25C64F4281B4E0C26FD